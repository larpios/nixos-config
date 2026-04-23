# Host: "laptop" — modular NixOS desktop machine (x86_64-linux, placeholder hardware).
# Registers a deferredModule under configurations.nixos.laptop.
# Audio and catppuccin are provided via flake.modules.nixos.pc.
# Home Manager config is provided via flake.modules.homeManager.base.
{
  config,
  inputs,
  ...
}: {
  configurations.nixos.laptop.module = {pkgs, ...}: {
    imports = [
      ../_hardware/laptop.nix
      ../_nixos/options.nix
      ../_nixos/core/users.nix
      ../_nixos/core/fonts.nix
      ../_nixos/core/locale.nix
      ../_nixos/desktop
      ../_nixos/development
      ../_nixos/stacks/ai.nix
      ../_nixos/stacks/music.nix
      ../_nixos/stacks/gaming.nix
      ../_nixos/profiles/work.nix
      config.flake.modules.nixos.pc
      (import ../_nixos/core/system.nix {inherit config inputs;})
    ];

    networking.hostName = "laptop";

    # Base packages additions
    environment.systemPackages = [
      pkgs.nodejs
    ];

    # Profile & stacks
    my.profile = "desktop";
    my.stacks.gaming.enable = true;
  };
}
