## Cheatsheets

- [NETWORK.md](docs/NETWORK.md) — mtr, tcpdump, nmap, dnsutils, dog, iperf3, bandwhich, wireguard-tools, mosh, nftables
- [DISK.md](docs/DISK.md) — gdu, duf, dust, ouch, smartmontools, nvme-cli, rsync

## Before you start

Run the commands below from the root of this repo.

`--flake .` selects the configuration that matches the host name. Keep it: without it,
`nixos-rebuild` may read `/etc/nixos` instead of this repo.

A new file must be added with `git add` before Nix can see it.

## Update

Update every input:
```
nix flake update
```

Update only the dotfiles:
```
nix flake update dotfiles
```

## Test

Check the Nix files:
```
statix check
deadnix --fail .
```

### NixOS

Show what would be built or downloaded:
```
nixos-rebuild dry-build --flake .
```

Evaluate a host without building it:
```
nix eval --raw .#nixosConfigurations.ary.config.system.build.toplevel.drvPath
nix eval --raw .#nixosConfigurations.blind-warrior.config.system.build.toplevel.drvPath
```

Build without activating:
```
nix build .#nixosConfigurations.blind-warrior.config.system.build.toplevel -o /tmp/system
```

Compare that build with the running system:
```
nix store diff-closures /run/current-system /tmp/system
```

Build and show what activation would change:
```
sudo nixos-rebuild dry-activate --flake .
```

Activate now and revert on reboot:
```
sudo nixos-rebuild test --flake .
```

### macOS

Do not use `darwin-rebuild check` or `darwin-rebuild switch --dry-run`.
Both can activate the configuration. See
[nix-darwin #1700](https://github.com/nix-darwin/nix-darwin/issues/1700) for `check`.

Show what would be built or downloaded:
```
nix build .#darwinConfigurations.orange-m4.system --dry-run
```

Evaluate without building. This also works on Linux:
```
nix eval --raw .#darwinConfigurations.orange-m4.system.drvPath
```

Build without activating:
```
nix build .#darwinConfigurations.orange-m4.system -o /tmp/system
```

Compare that build with the running system:
```
nix store diff-closures /run/current-system /tmp/system
```

## Switch

### NixOS

Activate now and make it the boot default:
```
sudo nixos-rebuild switch --flake .
```

Make it the boot default without activating it now:
```
sudo nixos-rebuild boot --flake .
```

### macOS

First switch, before `darwin-rebuild` exists:
```
sudo nix --extra-experimental-features "nix-command flakes" run \
  nix-darwin/master#darwin-rebuild -- switch --flake "github:4ry1337/nixfiles#orange-m4"
```

From this repo:
```
sudo darwin-rebuild switch --flake .
```

From GitHub, without a clone. `--refresh` fetches the latest commit instead of a cached copy:
```
sudo darwin-rebuild switch --refresh --flake "github:4ry1337/nixfiles#orange-m4"
```

## Roll back

### NixOS

List generations:
```
nixos-rebuild list-generations
```

Return to the previous generation:
```
sudo nixos-rebuild switch --rollback
```

### macOS

List generations:
```
sudo darwin-rebuild --list-generations
```

Return to the previous generation:
```
sudo darwin-rebuild --rollback
```

Switch to a specific generation:
```
sudo darwin-rebuild --switch-generation 12
```

## Clean up

`hosts/common` already deletes generations older than 7 days on a schedule.

Preview what would be deleted:
```
nix-collect-garbage --dry-run
```

Delete generations older than 7 days:
```
sudo nix-collect-garbage --delete-older-than 7d
```

Delete all old generations. You cannot roll back to them afterwards:
```
sudo nix-collect-garbage -d
```

Replace identical files in the store with hard links:
```
nix store optimise
```

On NixOS, remove deleted generations from the boot menu:
```
sudo nixos-rebuild boot --flake .
```

On macOS, uninstall nix-darwin:
```
sudo darwin-uninstaller
```
