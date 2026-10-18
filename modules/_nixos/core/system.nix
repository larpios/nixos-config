# Shared NixOS configuration core.
{
  config,
  inputs,
}:
{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.noctalia.nixosModules.default
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nur.overlays.default
  ];
  nixpkgs.config.allowUnfree = true;

  environment.shells = [ pkgs.nushell ];
  # Use Bash as a POSIX layer to set up environment variables, then start Nushell
  programs.bash.interactiveShellInit = ''
    if [[ "$TERM" != "dumb" ]] && [[ -z "$BASH_EXECUTION_STRING" ]]; then
      exec nu
    fi
  '';

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # Networking
  networking.networkmanager.enable = true;

  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    systemd.enable = true;
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Core system & Crypto libs
    libgpg-error
    libgcrypt
    expat
    zlib
    libuuid
    libffi

    # Graphics & Hardware drivers
    mesa
    libgbm
    libdrm
    libglvnd
    vulkan-loader
    libxkbcommon

    # Windowing systems
    wayland
    libxcb
    libx11
    libxcursor
    libxext
    libxrandr
    libxi
    libxrender
    libxfixes
    libxdamage
    libxtst

    # Text, Fonts & Rendering engines
    fontconfig
    freetype
    fribidi
    harfbuzz
    pango
    cairo

    # Desktop frameworks & UI
    glib
    dbus
    nspr
    nss
    atk
    at-spi2-atk
    gdk-pixbuf
    gtk3

    # Audio
    alsa-lib
    libpulseaudio

    e2fsprogs
    krb5
    gmp
  ];

  services.udev.extraRules = ''
    # Prevent ZSA Voyager from being detected as a joystick (fixes Sekiro etc.)
    SUBSYSTEM=="input", ATTRS{idVendor}=="3297", ATTRS{idProduct}=="1977", ENV{ID_INPUT_JOYSTICK}=""
  '';

  # Printing
  services.printing.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      cursor.size = 24;
      keyboard.layout = "us";
    };
    # Cursor theme is provided by modules/theming/niko-cursors.nix.
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      ignoreUserConfig = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-mozc
        fcitx5-mozc-ut
        fcitx5-hangul
        fcitx5-chewing
        fcitx5-table-extra
        fcitx5-gtk
        fcitx5-m17n
      ];
      settings.inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "hangul";
        "Groups/0/Items/2".Name = "mozc";
        "Groups/0/Items/3".Name = "chewing";
        "Groups/0/Items/4".Name = "keyboard-fi"; # Finnish
        "Groups/0/Items/5".Name = "keyboard-ara-mac"; # Arabic Macintosh
        "Groups/0/Items/6".Name = "cangjie5"; # ← Cangjie 5
      };
    };
  };

  # Base packages
  environment.systemPackages =
    with pkgs;
    [
      file
      killall
      vim
      wget
      zip
      unzip
      less
      wezterm
      firefox
      thunderbird
      kitty
      wl-clipboard-rs
      rofi
      awww
      mpv
      vesktop
      copyq
      # Needed for quickshell
      qt6.qt5compat
      pavucontrol
      appimage-run
      anki
      zed-editor
    ]
    ++ [
      inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

  # Nix settings
  nix.extraOptions = "experimental-features = nix-command flakes";
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    auto-optimise-store = true;
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Make sure dconf is available (needed for gsettings / color-scheme)
  programs.dconf.enable = true;

  xdg.portal = {
    enable = true;
    # Prefer the GTK portal for Settings (this is what browsers + most GTK apps query for light/dark)
    config.common.default = [ "gtk" ];
    # You can be more specific if you want:
    # config.common."org.freedesktop.impl.portal.Settings" = [ "gtk" ];

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      # add others only if you actually need them (hyprland, wlr, gnome, kde…)
    ];
  };

  # Home Manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users."${config.username}" = config.flake.modules.homeManager.base;

  system.stateVersion = "26.05";
}
