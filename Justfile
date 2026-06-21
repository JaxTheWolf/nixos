# --- Variables ---
cache := "my-config"
tablet_ip := "nixos@192.168.0.115"
user := "jax"

# --- Default ---
default: sync-laptop

sync-laptop: switch build-os-laptop build-home-all upload clean
    @echo "Laptop sync complete!"

sync-all: build-os-all build-home-all upload clean
    @echo "All devices synced and cached!"

# --- Core NixOS & Home Manager ---

switch *args:
    nh os switch {{args}}

home *args:
    nh home switch {{args}}

# --- Building System & Home Closures ---

build-os host:
    nix build .#nixosConfigurations.{{host}}.config.system.build.toplevel --log-format internal-json -o result-{{host}} |& nom --json

build-os-laptop:
    just build-os dalaptop

build-os-all:
    just build-os epiquev2
    just build-os dalaptop
    just build-os pipa

build-home host:
    nix build .#homeConfigurations."{{user}}@{{host}}".activationPackage -o result-home-{{host}}

build-home-all:
    just build-home epiquev2
    just build-home dalaptop
    just build-home pipa

vm host:
    nix build .#nixosConfigurations.{{host}}.config.system.build.vm
    ./result/bin/run-{{host}}-vm

# --- Caching ---

upload:
    attic push {{cache}} result* /run/current-system -j2
    nix-store --query --requisites $(nix eval --raw .#nixosConfigurations.pipa.config.system.build.toplevel.drvPath) | xargs attic push {{cache}}

# --- Tablet Specific Commands ---

deploy-tablet action="switch":
    nh os {{action}} . -H pipa --target-host {{tablet_ip}}

build-tablet-kernel:
    nix build .#nixosConfigurations.pipa.config.boot.kernelPackages.kernel -o result-tablet-kernel |& nom --json

build-tablet-images:
    nix run

flash part="all":
    #!/usr/bin/env bash
    if [ "{{part}}" = "all" ] || [ "{{part}}" = "boot" ]; then fastboot flash linux_boot images/boot.img; fi
    if [ "{{part}}" = "all" ] || [ "{{part}}" = "root" ]; then fastboot flash linux_root images/rootfs.sparse.img; fi
    fastboot reboot

# --- Utilities ---

clean:
    rm -rf result* *.qcow2

format:
    treefmt .

help:
    @just --list
