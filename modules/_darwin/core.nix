# Shared nix-darwin configuration core.
{
  config,
  inputs,
}: {
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.determinate.darwinModules.default
    inputs.home-manager.darwinModules.home-manager
  ];

  nixpkgs.overlays = [
    inputs.neovim-nightly-overlay.overlays.default
    inputs.nur.overlays.default
  ];
  nixpkgs.config.allowUnfree = true;

  users.users."${config.username}" = {
    name = "${config.username}";
    home = "/Users/${config.username}";
  };

  homebrew = {
    enable = true; # this does not install homebrew
    taps = ["BarutSRB/tap"];
    casks = [
      "battery"
      "discord"
      "floorp"
      "font-jetbrains-mono-nerd-font"
      "steam"
      "telegram-desktop"
      "thunderbird"
      "wezterm@nightly"
      "barutsrb/tap/omniwm"
      "raycast"
    ];
    global = {
      brewfile = true; # Generates a Brewfile to `$HOMEBREW_BUNDLE_FILE`
    };
    onActivation = {
      # cleanup = "uninstall";
    };
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  system.activationScripts.postActivation.text = ''
    sudo nvram BootPreference=%00
  '';

  launchd.daemons.automountd = {
    serviceConfig = {
      Disabled = true;
      Label = "com.apple.automountd";
      ProgramArguments = ["/usr/sbin/automountd"];
    };
  };

  nix.settings = {
    experimental-features = "nix-command flakes";
    extra-substituters = ["https://cache.numtide.com"];
    extra-trusted-public-keys = ["niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="];
  };

  determinateNix = {
    enable = true;
    determinateNixd = {
      garbageCollector.strategy = "automatic";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = false;
  home-manager.backupFileExtension = "bak";
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users."${config.username}" = config.flake.modules.homeManager.base;

  nix.settings.auto-optimise-store = true;

  system = {
    defaults = {
      dock = {
        # Auto show and hide dock
        autohide = true;
        # Remove delay for showding dock
        autohide-delay = 0.0;
        # How fast is the dock showing animation
        autohide-time-modifier = 0.2;
        expose-animation-duration = 0.2;
        static-only = false;
        show-process-indicators = true;
        showhidden = true;
        # Mouse in top right corner behavior: 5 - Start screensaver
        wvous-tr-corner = 5;
      };
      finder.AppleShowAllExtensions = true;
      controlcenter.BatteryShowPercentage = true;
      NSGlobalDomain = {
        # Fastest is 2
        KeyRepeat = 2;
        # Fastest is 15
        InitialKeyRepeat = 15;
        ApplePressAndHoldEnabled = false;
        # Show extensioons in Finder
        AppleShowAllExtensions = true;
        # Terminate inactive apps
        NSDisableAutomaticTermination = true;
        # Don't upload new documents to iCloud
        NSDocumentSaveNewDocumentsToCloud = false;
      };
      trackpad = {
        Clicking = true;
        Dragging = true;
        TrackpadThreeFingerTapGesture = 2;
      };
      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.screensaver" = {
          # Require password immediately after sleep or screen saver begins
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.mail" = {
          # Disable inline attachments (just show the icons)
          DisableInlineAttachmentViewing = true;
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
      };
    };
    keyboard.enableKeyMapping = true;

    stateVersion = 4;
    primaryUser = "${config.username}";
  };
}
