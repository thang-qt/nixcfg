# Secrets management

This repository uses SOPS with native age identities through `sops-nix`.

## Identity model

Every encrypted file has exactly two recipients:

1. the personal editor/recovery identity declared as `thang` in `.sops.yaml`;
2. the dedicated machine identity for the host consuming that file.

Machine identities are stored at `/var/lib/sops-nix/key.txt` with root ownership
and mode `0600`. The containing directory is mode `0700`. They are provisioned
before activation and must not be copied between hosts. The shared policy in
`modules/nixos/sops.nix` fails closed if the expected identity is missing.

The personal identity is stored outside this repository at
`~/.config/sops/age/keys.txt`, mode `0600`, and is backed up in the 1Password
Private vault. Never commit, print, or send an age private identity.

Public `age1...` recipients are not secret and are recorded in `.sops.yaml`.

## Layout

Secrets are grouped by consuming host:

```text
secrets/pathway/
secrets/nebula/
secrets/petri/
```

Creation rules in `.sops.yaml` cover both YAML and JSON. Do not add a broad
catch-all rule that grants every machine access.

## Editing

SOPS discovers the personal identity at its standard location:

```console
sops secrets/pathway/restic.yaml
```

After changing recipients or moving a file, update its encrypted data-key
wrappers without displaying plaintext:

```console
sops updatekeys --yes secrets/pathway/restic.yaml
sops decrypt --output /dev/null secrets/pathway/restic.yaml
```

Review recipient metadata before committing. Each file must contain only the
personal recipient and its matching host recipient.

## Adding a host

1. Add the shared NixOS SOPS module to the host through `modules/nixos/common.nix`.
2. Build the `age` package temporarily and generate the machine identity on the
   target:

   ```console
   agePackage=$(nix build --no-link --print-out-paths nixpkgs#age)
   sudo install -d -m 0700 -o root -g root /var/lib/sops-nix
   sudo "$agePackage/bin/age-keygen" -o /var/lib/sops-nix/key.txt
   sudo chmod 0600 /var/lib/sops-nix/key.txt
   sudo "$agePackage/bin/age-keygen" -y /var/lib/sops-nix/key.txt
   ```

3. Add only the printed public recipient to `.sops.yaml`.
4. Add a host-scoped creation rule containing the personal and host recipients.
5. Rekey the host's encrypted files.
6. Validate decryption with the personal identity and on the target host before
   activation.

Pre-generating the key is required because `generateKey = false` deliberately
prevents silent identity drift. During a fresh installation, either restore the
original key to the mounted target or generate the replacement at
`/mnt/var/lib/sops-nix/key.txt`, rekey that host's files from the personal
identity, and only then run the first `nixos-install`/activation. Never activate
ciphertext addressed to a different machine identity.

## Deployment

Test before promoting a configuration:

```console
nh os test . --hostname pathway
nh os test . --hostname nebula --build-host nebula --target-host nebula \
  --elevation-strategy passwordless
nh os test . --hostname petri --build-host petri --target-host petri \
  --elevation-strategy passwordless
```

After service validation, replace `test` with `switch`. When deploying remotely,
`nh --diff always` may compare the target closure with the local machine and
produce a misleading diff; use a target-side `nix store diff-closures` when an
exact remote comparison is required.

Pathway additionally uses the personal identity at login for its Home Manager
Rescrobbled secret. After restoring or rotating that identity, run
`home-manager switch --flake .#thang@pathway` and verify both
`sops-nix.service` and `rescrobbled.service`. Petri and Nebula do not use Home
Manager SOPS.

Verify only status and metadata—never print secret files:

- machine key directory `0700 root:root`;
- machine key `0600 root:root`;
- expected `/run/secrets` ownership and modes;
- dependent services active without new warnings.

Repository-wide evaluation, including the intentionally unfree Cider package:

```console
NIXPKGS_ALLOW_UNFREE=1 nix flake check --no-build --impure
```

Use the remote hosts as `--build-host` for their `aarch64-linux` closures.

## Recovery and rotation

If a machine identity is lost:

1. generate a replacement on that host;
2. obtain its public recipient;
3. update `.sops.yaml` using the personal recovery identity;
4. run `sops updatekeys` for that host's files;
5. deploy and validate before removing the old recipient.

During rotation, retain old and new recipients until every consumer has been
validated. Keep old private identities only for a bounded rollback window, then
delete them securely. Rewrapping ciphertext does not revoke plaintext already
exposed through an old identity; rotate the underlying service credential when
an identity may have been compromised.

## Exceptions and follow-up

`/etc/luks-keys/data.key` is an early-boot bootstrap secret and is intentionally
not managed by this SOPS migration.

Plaintext account and Kairos passwords currently present in Nix configuration
must be migrated separately to host-scoped SOPS secrets and the underlying
passwords rotated.
