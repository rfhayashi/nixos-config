# Install nixos using the graphical installer

## User

Create a user named rfhayashi.

## Partitions

Select "GUID Partition Table (GPT)" when creating new partitions.

### Partition One: Boot

- Size: 512M
- Partition Type: GPT
- File System: fat32
- Encrypt: Not checked
- Mount Point: /boot
- Flags: boot

### Partition Two: Root

- Size: Remaining Drive Space
- Partition Type: GPT
- File System: ftrfs
- Encrypt: Checked (Enter username, password)
- Mount Point: /
- Flags:

## Activate flakes

Add `nix.settings.experimental-features = ["nix-command" "flakes"];`
to `/etc/nixos/configuration.nix` and run `sudo nixos rebuild switch`.

## Clone this repo to `/tmp`

`nix-shell -p git --command "git clone https://github.com/rfhayashi/nixos-config"`

## Fetch age key

`bin/fetch-age-key`

## hardware-configuration.nix

Copy `/etc/nixos/hardware-configuration.nix` over `system/hardware.nix`.

Run `nix-shell -p git --command "sudo nixos-rebuild switch --flake ."` to finish installation.

## After installation

```shell
mkdir ~/dev
cd ~/dev
git clone git@github.com:rfhayashi/nixos-config
git clone git@github.com:rfhayashi/emacs.d
cd nixos-config
cp /tmp/nixos-config/system/hardware.nix system/hardware.nix
git commit -m "hardware update"
git push
rm -rf /tmp/nixos-config
```