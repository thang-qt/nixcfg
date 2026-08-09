---
name: sops-nix-secrets
description: Safely manages SOPS-encrypted secrets, native age identities, recipient policy, sops-nix declarations, Home Manager secrets, host provisioning, validation, and rotation in this NixOS flake. Use for any change involving .sops.yaml, secrets/, sops-nix, age keys, credentials, password files, or secret-consuming services.
compatibility: Nix flakes with sops-nix, native age identities, NixOS, and Home Manager
---

# SOPS and sops-nix

Use this workflow for every secret-related change in this repository.

## Non-negotiable safety rules

- Never read, print, reveal, log, summarize, or paste plaintext secret values or
  private key material.
- Never run a command that writes decrypted content to stdout or a captured tool
  result.
- Never use `cat`, `head`, `tail`, `sed`, an editor, or similar tools on private
  identities or decrypted runtime secret files.
- Never introduce credentials in Nix expressions, command-line arguments,
  shell history, Git commit messages, generated derivations, or temporary
  plaintext files. If existing plaintext is discovered, report only its
  location and purpose—never its value—and propose a SOPS migration.
- Never copy a personal or machine private identity between hosts.
- If an operation cannot be completed without exposing plaintext to the agent,
  stop and ask the user to perform the secure value-entry step.
- Public `age1...` recipients and SSH public keys are safe to inspect. Private
  age and SSH identities are not.
- Prefer metadata-only inspection: paths, ownership, modes, recipient names,
  service state, exit status, and warning counts.

When validating decryption, always discard output:

```console
sops decrypt --output /dev/null "$encrypted_file"
```

Redirect command output when a tool might report sensitive material. Do not
retain logs that may contain plaintext; rely on exit status or diagnostics known
to contain metadata only.

## Repository policy

Encrypted files live under a directory named for the consuming host:

```text
secrets/
  <host>/
    <service>.yaml
    <service>.json
```

Every encrypted file must match exactly one host-scoped creation rule in
`.sops.yaml`. Its final recipient set contains exactly:

1. the personal editor/recovery recipient;
2. the dedicated native age recipient for the consuming machine.

Do not introduce a broad catch-all rule or grant unrelated hosts access.

## Identity model

### Personal identity

SOPS discovers the personal editor/recovery identity at:

```text
~/.config/sops/age/keys.txt
```

It must remain outside the repository, mode `0600`, and have a secure external
backup. An agent may derive its public recipient with `age-keygen -y`, but must
never print or read the private identity.

### Machine identity

Each NixOS host uses:

```text
/var/lib/sops-nix/key.txt
```

Required metadata:

```text
/var/lib/sops-nix          0700 root:root
/var/lib/sops-nix/key.txt  0600 root:root
```

`modules/nixos/sops.nix` uses this native age identity, disables SSH/GPG
fallbacks, and fails closed when the expected key is missing.

## Safe inspection

Inspect encrypted recipient metadata without reading encrypted values:

```console
rg -o 'recipient: [^ ]+|"recipient": "[^"]+"' "$encrypted_file"
sops filestatus "$encrypted_file"
```

Inspect runtime metadata without reading content:

```console
stat /var/lib/sops-nix /var/lib/sops-nix/key.txt
stat "/run/secrets/$secret_name"
systemctl is-active "$service.service"
```

Validate specifically with a machine identity rather than allowing SOPS to
discover the personal identity:

```console
sudo env SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.txt \
  sops decrypt --output /dev/null "$encrypted_file" >/dev/null 2>&1
```

Run that command on the consuming host. A zero exit status proves that the
configured machine identity can unwrap the file; it does not expose plaintext.

For root-owned paths, use an approved secure elevation method. Never place a
sudo password in chat, environment variables, shell arguments, or stdin managed
by the agent. On a graphical local host, `pkexec` is preferred when interactive
authentication is required. Use passwordless remote sudo only when already
configured and explicitly authorized.

## Adding or changing a secret

1. Identify the single consuming host and service.
2. Place ciphertext under `secrets/<host>/`.
3. Ensure the matching `.sops.yaml` rule contains only the personal and target
   host recipients.
4. Declare only the required key in the consuming module.
5. Choose ownership and mode based on the service account.
6. Prefer systemd credentials for `DynamicUser` services and root-owned source
   files.
7. Add `restartUnits` or `reloadUnits` when the consumer must react to changes.
8. Validate personal decryption to `/dev/null`.
9. Validate target-host decryption to `/dev/null`.
10. Confirm an unrelated machine identity cannot decrypt the file.
11. Evaluate/build before activation and verify the dependent service after it.

A typical NixOS declaration is:

```nix
sops.secrets.example = {
  sopsFile = ../../secrets/example-host/example-service.yaml;
  key = "example_key";
  mode = "0400";
  owner = "root";
};
```

Use SOPS templates for configuration or environment files containing multiple
values. Do not interpolate plaintext during Nix evaluation.

If a new value must be entered, prepare the policy and declaration, then ask the
user to run the interactive `sops` editor. Do not ask the user to paste the
value into chat.

## Moving or rekeying encrypted files

After moving a file or changing recipient policy, update only the encrypted
data-key wrappers:

```console
sops updatekeys --yes "$encrypted_file"
sops decrypt --output /dev/null "$encrypted_file"
```

Suppress `updatekeys` output when appropriate. Review only recipient metadata
and ensure secret payloads remain SOPS ciphertext in the Git diff.

During migration, retain the identity required by the currently deployed
configuration until the replacement has been validated. Remove legacy
recipients only after the new identity works on the target and rollback remains
possible.

## Provisioning a machine identity

The machine identity must exist before the first activation that consumes its
ciphertext. Obtain `age-keygen` without globally installing it:

```console
agePackage=$(nix build --no-link --print-out-paths nixpkgs#age)
sudo install -d -m 0700 -o root -g root /var/lib/sops-nix
sudo "$agePackage/bin/age-keygen" -o /var/lib/sops-nix/key.txt
sudo chmod 0600 /var/lib/sops-nix/key.txt
sudo "$agePackage/bin/age-keygen" -y /var/lib/sops-nix/key.txt
```

The last command emits only the public recipient. Add it to `.sops.yaml`, update
the host rule, and rekey before activation.

For a fresh installation, restore the original key or generate the replacement
under the mounted target:

```text
/mnt/var/lib/sops-nix/key.txt
```

If a replacement is generated, rekey the host's files from the personal
identity before the first install or activation.

## Home Manager secrets

Home Manager cannot read the root-owned machine identity. A user service may
use the personal identity at `~/.config/sops/age/keys.txt`.

- Import the Home Manager SOPS module only for profiles declaring user secrets.
- Order consuming user services after `sops-nix.service` and require it when
  startup cannot proceed without the secret.
- Prefer NixOS SOPS for system services and Home Manager SOPS only for
  user-session consumers.
- Validate user service state and secret metadata without printing content.

## Deployment and validation

Test locally:

```console
host=example-host
nh os test . --hostname "$host"
```

Test a remote host that builds its own closure:

```console
nh os test . \
  --hostname "$host" \
  --build-host "$host" \
  --target-host "$host" \
  --elevation-strategy passwordless
```

Use `switch` only after `test` and service validation. Do not deploy or mutate a
host unless the user has authorized it. Keep a recovery session or rollback
path for remote changes.

Validate with:

```console
nix fmt -- .
statix check .
deadnix --fail .
NIXPKGS_ALLOW_UNFREE=1 nix flake check --no-build --impure
```

Check expected runtime metadata, service state, and warning counts. Never print
runtime secrets, service environments, or credential contents.

## Rotation and recovery

To rotate a machine identity safely:

1. generate the replacement at a separate root-only staging path such as
   `/var/lib/sops-nix/key.next.txt`; do not overwrite the active key;
2. obtain only the replacement's public recipient;
3. temporarily retain old and new recipients in the host rule;
4. run `sops updatekeys` for that host;
5. validate the replacement explicitly by setting
   `SOPS_AGE_KEY_FILE=/var/lib/sops-nix/key.next.txt` and decrypting to
   `/dev/null` under secure elevation;
6. retain the active key as `/var/lib/sops-nix/key.previous.txt`, atomically move
   the staged replacement to `/var/lib/sops-nix/key.txt`, and preserve mode
   `0600 root:root`;
7. run `nh os test`, verify secret metadata and consumers, then promote with
   `switch` only after success;
8. if activation fails, atomically restore the previous key and reactivate the
   previous configuration while the old recipient is still present;
9. retain the previous key and recipient for a bounded rollback window;
10. remove the old recipient, run `sops updatekeys` again, validate, and only
    then securely delete the previous identity.

Use the same staged approach for the personal identity. Rekeying only changes
who can unwrap the SOPS data key; it does not revoke plaintext previously
exposed. Rotate the underlying service credential if plaintext or a private
identity may have been compromised.

## Completion checklist

- No plaintext or private identity entered the repository or tool output.
- The file is under the consuming host's secret directory.
- Exactly the personal and matching host recipients are present.
- Personal and target-host decryption succeed with output discarded.
- Unrelated-host decryption fails.
- Ownership and mode match the consumer.
- Service credential delivery is appropriate for its account model.
- Restart/reload behavior is declared when required.
- Formatting, lint, evaluation, and focused service validation pass.
