vm-desktop:
    nix build .#nixosConfigurations.epiquev2.config.system.build.vm
    ./result/bin/run-epiquev2-vm

vm-laptop:
    nix build .#nixosConfigurations.dalaptop.config.system.build.vm
    ./result/bin/run-dalaptop-vm

clean:
    rm -rf result
    rm -rf *.qcow2

switch:
    nh os switch

help:
    @just --list