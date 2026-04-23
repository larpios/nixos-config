# Shared NixOS configuration core.
{
  config,
  inputs,
}: {
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nur.overlays.default
  ];
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Networking
  networking.networkmanager.enable = true;

  # Printing
  services.printing.enable = true;

  # Base packages
  environment.systemPackages = with pkgs;
    [
      vim
      wget
      zip
      unzip
      less
      wezterm
      wl-clipboard-rs
    ]
    ++ [
      inputs.zen-browser.packages.x86_64-linux.twilight
    ];

  # Nix settings
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.settings = {
    auto-optimise-store = true;
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users."${config.username}" = config.flake.modules.homeManager.base;

  system.stateVersion = "25.11";
}
