{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  # Simply install just the packages
  environment.packages = with pkgs;
    [
      # Some common stuff that people expect to have
      #procps
      bzip2
      cargo-binstall
      curl
      diffutils
      findutils
      direnv
      gcc
      git
      gnugrep
      gnupg
      gnused
      gnutar
      gzip
      hostname
      killall
      lazygit
      less
      man
      openssh
      pkg-config
      sudo
      tzdata
      unzip
      util-linux
      vim
      wget
      which
      xz
      zip
    ]
    ++ (with unstable; [
      nerd-fonts.jetbrains-mono
    ]);

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  home-manager.config = {
    imports = [./home.nix];
    _module.args = {
      inherit inputs;
      inherit unstable;
    };
    home.stateVersion = "${config.system.stateVersion}";
  };

  terminal.font = "${unstable.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  android-integration = {
    am.enable = true;
    termux-open.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    xdg-open.enable = true;
  };

  # user.shell = "${lib.getExe pkgs.fish}";
  user.shell = "${lib.getExe unstable.bash}";

  time.timeZone = "Asia/Seoul";

  # Set your time zone
  #time.timeZone = "Europe/Berlin";
}
