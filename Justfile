default: switch build-laptop upload clean

vm-desktop:
    nix build .#nixosConfigurations.epiquev2.config.system.build.vm
    ./result/bin/run-epiquev2-vm

vm-laptop:
    nix build .#nixosConfigurations.dalaptop.config.system.build.vm
    ./result/bin/run-dalaptop-vm

build-laptop:
    nix build .#nixosConfigurations.dalaptop.config.system.build.toplevel --log-format internal-json -o result-laptop |& nom --json

upload:
    attic push my-config result-laptop -j2
    attic push my-config /run/current-system -j2
    attic push my-config result-tablet -j2

clean:
    rm -rf result*
    rm -rf *.qcow2

format:
    treefmt .

switch:
    nh os switch

switch-update:
    nh os switch --refresh --update

switch-update-commit:
    nh os switch --refresh --update --commit-lock-file

build-tablet:
    nix run nixpkgs#nix-output-monitor -- build .#nixosConfigurations.pipa-cross.config.system.build.toplevel -o result-tablet

build-tablet-kernel:
    nix run nixpkgs#nix-output-monitor -- build .#nixosConfigurations.pipa-cross.config.boot.kernelPackages.kernel -o result-tablet-kernel

build-tablet-images:
    nix run

deploy-tablet-switch:
    nh os switch . -H pipa --target-host nixos@192.168.0.115

deploy-tablet-boot:
    nh os boot . -H pipa --target-host nixos@192.168.0.115

flash-all:
    fastboot flash linux_boot images/boot.img
    fastboot flash linux_root images/rootfs.sparse.img
    fastboot reboot

flash-boot:
    fastboot flash linux_boot images/boot.img
    fastboot reboot

flash-root:
    fastboot flash linux_root images/rootfs.sparse.img
    fastboot reboot

help:
    @just --list