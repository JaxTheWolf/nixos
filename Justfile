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
    attic push my-config /run/current-system
    attic push my-config result

clean:
    rm -rf result
    rm -rf *.qcow2

switch:
    nh os switch

help:
    @just --list