# Base package set for all platforms.
# Contributes to flake.modules.homeManager.base.
{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.base = {pkgs, ...}: let
    isLinux = pkgs.stdenv.isLinux;
    isDarwin = pkgs.stdenv.isDarwin;
  in {
    home.packages = with pkgs;
      [
        # Archiver
        _7zz-rar

        age
        alejandra
        ast-grep
        bat
        bitwarden-cli
        gnumake
        cmake
        ninja
        unzip
        cachix
        cargo-binstall
        cargo-watch
        cmake
        delta
        difftastic
        duf # Disk Usage/Free Utility
        dust
        fastfetch
        fd

        starship # Custom Prompt Engine

        btop # System Monitoring

        zellij # Terminal Multiplexer
        tmux

        yazi # TUI File Explorer

        # === Shell ===
        nushell
        fish
        # Shell Completion
        bash-completion

        # Fish shell LSP
        fish-lsp

        fzf # Fuzzy Finder


        # === Version Control System ===
        git
        jujutsu
        jj-starship
        gh # GitHub CLI

        hexyl
        just
        nb # local web note‑taking, bookmarking, archiving, and knowledge base
        neovim
        tree-sitter
        nh # Nix helper
        nil # Nix language server
        ninja
        nufmt # Nushell Formatter
        openssh
        ouch
        ripgrep
        ripgrep-all
        rust-parallel
        rust-script
        rustup
        sops
        ssh-to-age
        tealdeer
        tokei
        tree
        vaultwarden
        zig


        # === Media ===
        ffmpeg      # Video manipulation
        mpv         # Media player
        chafa       # Image viewer
        imagemagick # Image Manipulation

        # Fonts
        nerd-fonts.jetbrains-mono

        # LLM Agents
        # inputs.llm-agents.packages.${hostSystem}.claude-code
        # inputs.llm-agents.packages.${hostSystem}.gemini-cli
        # inputs.llm-agents.packages.${hostSystem}.opencode
        # inputs.llm-agents.packages.${hostSystem}.rtk
      ]
      ++ lib.optionals isLinux [
        clang-tools
        gcc

        inputs.awww.packages.${stdenv.hostPlatform.system}.awww # Wallpaper manager
        inputs.quickshell.packages.${stdenv.hostPlatform.system}.quickshell # Top bar

        eww

        ripdrag # Drag and drop files into the terminal

        grim # Screenshot tool, used together with slurp
        slurp # Get a region of the screen
      ]
      ++ lib.optionals isDarwin [
        aerospace
        sketchybar
      ];
  };
}
