# AGENTS.md

## Repository

This is a personal NixOS and Home Manager configuration repository built as a
Nix flake and pinned to NixOS 26.05.

### Hosts

- **pathway — x86_64-linux:** personal laptop and primary workstation.
- **nebula — aarch64-linux:** main always-on server for self-hosting and general
  services.
- **petri — aarch64-linux:** on-demand research host; it may be powered off.

Keep host-specific behavior under the matching host directory and reusable
behavior in shared modules.

## Layout

- `flake.nix` / `flake.lock` — inputs and top-level outputs.
- `nixos/<host>/` — NixOS host entry points and hardware configuration.
- `home/thang/common.nix` — shared Home Manager configuration.
- `home/thang/<host>/` — host-specific Home Manager profiles.
- `modules/nixos/` — reusable NixOS modules.
- `modules/home-manager/` — reusable Home Manager modules.
- `overlays/` and `pkgs/` — package overlays and local packages.
- `secrets/<host>/` — host-scoped SOPS ciphertext.
- `.agents/skills/` — project-specific agent workflows.

NixOS outputs are `nixosConfigurations.{pathway,nebula,petri}`. Matching Home
Manager outputs are `homeConfigurations."thang@<host>"`.

## Working in the repository

Enter the development environment with `direnv allow` or `nix develop`. It
provides Alejandra, Statix, Deadnix, `nixd`, `nh`, SOPS, age, and the pre-commit
hook.

Run before completion:

```console
nix fmt -- .
statix check .
deadnix --fail .
pre-commit run --all-files
NIXPKGS_ALLOW_UNFREE=1 nix flake check --no-build --impure
```

The unfree override is expected because the flake intentionally exposes unfree
packages.

## Change rules

- Prefer declarative Nix changes over imperative host changes.
- Put shared behavior in reusable modules and machine-specific ports, mounts,
  and services in `nixos/<host>/`.
- Keep user-session configuration in Home Manager unless it requires system or
  privileged ownership.
- Add packages through `pkgs/` and the existing overlay/package outputs.
- Do not modify generated `hardware-configuration.nix` files unless the task is
  explicitly about detected hardware, storage, or boot configuration.
- Preserve `system.stateVersion` and `home.stateVersion` unless a migration is
  explicitly requested.
- Avoid unrelated `flake.lock` updates.
- Use Alejandra; keep Statix and Deadnix clean. Statix's `repeated_keys` rule is
  intentionally disabled because dotted NixOS/Home Manager option assignments
  are often clearer than large nested attrsets.

## Secrets

For changes involving `.sops.yaml`, `secrets/`, age identities, sops-nix,
credentials, password files, or secret-consuming services, load and follow:

```text
.agents/skills/sops-nix-secrets/SKILL.md
```

Never inspect or reveal plaintext secrets or private keys. Do not introduce
plaintext credentials in Nix source. If existing plaintext is found, report only
its location and purpose and propose a SOPS migration. Public recipients and
public SSH keys are not secret.

## Evaluation and deployment

Evaluate the affected output first:

```console
host=pathway
nix eval --raw ".#nixosConfigurations.$host.config.system.build.toplevel"
nix eval --raw ".#homeConfigurations.\"thang@$host\".activationPackage"
```

Build Pathway locally:

```console
nh os build . --hostname pathway
```

Use Nebula or Petri as its own aarch64 build host:

```console
host=nebula
nh os build . \
  --hostname "$host" \
  --build-host "$host" \
  --target-host "$host"
```

Building and evaluation are non-mutating. Do not run `test`, `switch`, Home
Manager activation, reboot, or remote mutation without user authorization. For
authorized NixOS deployments, use `test` before `switch`, retain a rollback
path, and validate affected services afterward. Do not expose service
environments or credentials during validation.

## Git discipline

- Inspect and preserve existing working-tree changes.
- Keep changes focused; run repository-wide formatting only when requested.
- Do not update generated `.direnv/` or `.pre-commit-config.yaml` state.
- Do not bypass pre-commit hooks.
- Do not commit unless the user asks.
