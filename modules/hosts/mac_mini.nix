# Host: "mac_mini" — nix-darwin configuration (aarch64-darwin).
# Registers a deferredModule under configurations.darwin.mac_mini.
# Home Manager config is provided via flake.modules.homeManager.base.
{
  config,
  inputs,
  ...
}: {
  configurations.darwin.mac_mini.module = {
    pkgs,
    lib,
    ...
  }: let
    defaultShell = pkgs.nushell;
  in {
    imports = [
      (import ../_darwin/core.nix {inherit config inputs;})
    ];

    users.users."${config.username}".shell = defaultShell;

    programs = import ../_shell/interactive-shell-init.nix {inherit lib defaultShell;};
  };
}
