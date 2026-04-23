# Host: "nixos" — desktop NixOS machine (x86_64-linux, Intel).
# Registers a deferredModule under configurations.nixos.nixos.
# Audio and catppuccin are provided via flake.modules.nixos.pc.
# Home Manager config is provided via flake.modules.homeManager.base.
{
  config,
  inputs,
  ...
}: {
  configurations.nixos.nixos.module = {
    pkgs,
    lib,
    ...
  }: let
    defaultShell = pkgs.fish;
  in {
    imports = [
      ../_hardware/nixos.nix
      ../_nixos/options.nix
      ../_nixos/core/users.nix
      ../_nixos/core/fonts.nix
      ../_nixos/core/locale.nix
      ../_nixos/desktop
      ../_nixos/development
      ../_nixos/stacks/gaming.nix
      config.flake.modules.nixos.pc
      (import ../_nixos/core/system.nix {inherit config inputs;})
    ];

    networking.hostName = "nixos";

    # Torrent
    services.qbittorrent = {
        enable = true;
        user = config.username;
    };

    programs = import ../_shell/interactive-shell-init.nix {inherit lib defaultShell;};

    # Gaming stack
    my.stacks.gaming.enable = true;
  };
}
