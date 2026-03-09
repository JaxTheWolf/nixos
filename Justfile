default: switch build-laptop upload clean

vm-desktop:
    nix build .#nixosConfigurations.epiquev2.config.system.build.vm
    ./result/bin/run-epiquev2-vm

vm-laptop:
    nix build .#nixosConfigurations.dalaptop.config.system.build.vm
    ./result/bin/run-dalaptop-vm

build-laptop:
    nix build .#nixosConfigurations.dalaptop.config.system.build.toplevel

upload:
    attic push my-config result
    attic push my-config /run/current-system

clean:
    rm -rf result
    rm -rf *.qcow2

format:
    treefmt .

switch:
    nh os switch

switch_update:
    nh os switch --refresh --update

help:
    @just --list
