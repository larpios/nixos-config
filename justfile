# https://just.systems

default:
    @just -l

darwin:
    @nu setup.nu system -H macbook

nixos:
    @nu setup.nu system

linux:
    @nu setup.nu home

check:
    @nu setup.nu check

fmt:
    @nu setup.nu fmt
