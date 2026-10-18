# Host: "macbook" — nix-darwin configuration (aarch64-darwin).
# Registers a deferredModule under configurations.darwin.macbook.
# Home Manager config is provided via flake.modules.homeManager.base.
{
  config,
  inputs,
  ...
}: {
  configurations.darwin.macbook.module = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      (import ../_darwin/core.nix {inherit config inputs;})
    ];

    nixpkgs.overlays = [
      inputs.jj-starship.overlays.default
    ];

    system.defaults.NSGlobalDomain._HIHideMenuBar = true;

    services.aerospace = {
      enable = true;
    };
    launchd.user.agents.aerospace.serviceConfig = {
      # This prevents Nix from passing its own config path,
      # allowing AeroSpace to fall back to its default (~/.config/aerospace/aerospace.toml)
      ProgramArguments = [
        "/run/current-system/sw/bin/aerospace"
      ];
      EnvironmentVariables = {
        PATH = "/opt/homebrew/bin:/run/current-system/sw/bin:/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };

    services.jankyborders = {
      enable = true;
      active_color = "0xFFDC8A78";
      inactive_color = "0xFF7287FD";
      width = 7.0;
      blur_radius = 2.0;
    };
    services.sketchybar = {
      enable = true;
    };
    services.tailscale.enable = true;
  };
}
