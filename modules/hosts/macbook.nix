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
  }: let
    defaultShell = pkgs.nushell;
  in {
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
      shell = defaultShell;
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

    programs = {
      bash.interactiveShellInit =
        # zsh
        ''
          if ! [ "$TERM" = "dumb" ] && [ -z "$BASH_EXECUTION_STRING" ]; then
            exec "${lib.getExe defaultShell}"
          fi
        '';

      zsh.interactiveShellInit =
        # zsh
        ''
          if ! [ "$TERM" = "dumb" ] && [ -z "$ZSH_EXECUTION_STRING" ]; then
            exec "${lib.getExe defaultShell}"
          fi
        '';
      fish.enable = true;
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
          # Hide menu bar
          _HIHideMenuBar = true;
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
    services.aerospace = {
      enable = true;
      settings = {
        after-startup-command = [
          "exec-and-forget sketchybar"
          "exec-and-forget borders"
        ];
        exec-on-workspace-change = [
          "/usr/bin/env"
          "bash"
          "-c"
          "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
        ];
        enable-normalization-flatten-containers = true;
        enable-normalization-opposite-orientation-for-nested-containers = true;
        accordion-padding = 30;
        default-root-container-layout = "tiles";
        default-root-container-orientation = "auto";
        on-focused-monitor-changed = [
          "move-mouse monitor-lazy-center"
        ];
        automatically-unhide-macos-hidden-apps = true;
        key-mapping = {
          preset = "qwerty";
        };
        gaps = {
          inner = {
            horizontal = 24;
            vertical = 24;
          };
          outer = {
            left = 24;
            bottom = 24;
            top = 24;
            right = 24;
          };
        };
        mode = {
          main = {
            binding = {
              alt-w = "exec-and-forget current_workspace=\"$(aerospace list-workspaces --focused)\"; aerospace close; aerospace workspace \"$current_workspace\"";
              alt-slash = "layout tiles horizontal vertical";
              alt-comma = "layout accordion horizontal vertical";
              alt-h = "focus left";
              alt-j = "focus down";
              alt-k = "focus up";
              alt-l = "focus right";
              alt-shift-h = "move left";
              alt-shift-j = "move down";
              alt-shift-k = "move up";
              alt-shift-l = "move right";
              alt-minus = "resize smart -50";
              alt-equal = "resize smart +50";
              alt-1 = "workspace 1";
              alt-2 = "workspace 2";
              alt-3 = "workspace 3";
              alt-4 = "workspace 4";
              alt-5 = "workspace 5";
              alt-6 = "workspace 6";
              alt-7 = "workspace 7";
              alt-8 = "workspace 8";
              alt-9 = "workspace 9";
              alt-shift-1 = "move-node-to-workspace 1";
              alt-shift-2 = "move-node-to-workspace 2";
              alt-shift-3 = "move-node-to-workspace 3";
              alt-shift-4 = "move-node-to-workspace 4";
              alt-shift-5 = "move-node-to-workspace 5";
              alt-shift-6 = "move-node-to-workspace 6";
              alt-shift-7 = "move-node-to-workspace 7";
              alt-shift-8 = "move-node-to-workspace 8";
              alt-shift-9 = "move-node-to-workspace 9";
              alt-tab = "workspace-back-and-forth";
              alt-shift-tab = "move-workspace-to-monitor --wrap-around next";
              alt-shift-semicolon = "mode service";
            };
          };
          service = {
            binding = {
              esc = [
                "reload-config"
                "mode main"
              ];
              r = [
                "flatten-workspace-tree"
                "mode main"
              ];
              f = [
                "layout floating tiling"
                "mode main"
              ];
              backspace = [
                "close-all-windows-but-current"
                "mode main"
              ];
              alt-shift-h = [
                "join-with left"
                "mode main"
              ];
              alt-shift-j = [
                "join-with down"
                "mode main"
              ];
              alt-shift-k = [
                "join-with up"
                "mode main"
              ];
              alt-shift-l = [
                "join-with right"
                "mode main"
              ];
              down = "volume down";
              up = "volume up";
              shift-down = [
                "volume set 0"
                "mode main"
              ];
            };
          };
        };
        on-window-detected = [
          {
            "if".app-id = "com.github.wez.wezterm";
            run = "move-node-to-workspace 1";
          }
          {
            "if".app-id = "org.mozilla.floorp";
            run = "move-node-to-workspace 2";
          }
          {
            "if".app-id = "com.hnc.Discord";
            run = "move-node-to-workspace 3";
          }
        ];
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
