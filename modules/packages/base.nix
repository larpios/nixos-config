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
        choose
        cmake
        delta
        difftastic
        duf # Disk Usage/Free Utility
        dust
        eva
        fastfetch
        fd

        # Custom Prompt Engine
        starship

        # System Monitoring
        btop
        bottom

        # Terminal Multiplexer
        zellij
        tmux

        # TUI File Explorer
        yazi

        # Shell
        nushell
        fish
        # Shell Completion
        bash-completion

        # Fish shell LSP
        fish-lsp
        mkcert # Simple tool to make locally trusted development certificates
        fselect

        # Fuzzy Finder
        fzf

        ripdrag # Drag and drop files into the terminal
        gh

        # Version Control System
        git
        jujutsu
        jj-starship

        git-absorb
        gitoxide
        gitui
        glow
        gpg-tui
        hexyl
        httm
        hyperfine
        just
        lazygit
        lazyjj
        gopass # CLI password manager written in Go
        lemmeknow
        lsd
        mcfly
        mprocs
        navi
        nb # local web note‑taking, bookmarking, archiving, and knowledge base
        neovim
        tree-sitter
        nh
        nil
        ninja
        nufmt # Nushell Formatter
        openssh
        ouch
        procs
        ripgrep
        ripgrep-all
        rm-improved
        rnr
        runiq # Efficient way to filter duplicate lines from input, à la uniq
        ruplacer # Find and replace text in source files
        rust-parallel
        rust-script
        rustup
        scout
        sd # Intuitive find & replace CLI (sed alternative)
        sops
        ssh-to-age
        tealdeer
        tere
        tokei
        tre-command
        tree
        trippy
        vaultwarden
        wakatime-cli
        xcp
        xh
        xxh
        zig
        zmate # Instant terminal sharing using Zellij

        # Image Manipulation
        imagemagick
        # Image viewer
        chafa

        # Media
        ffmpeg
        mpv

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
        elephant
        gcc
        grim # Screenshot tool
        inputs.awww.packages.${stdenv.hostPlatform.system}.awww # Wallpaper manager
        inputs.quickshell.packages.${stdenv.hostPlatform.system}.quickshell # Top bar
        slurp # Clipboard tool
        wox
      ]
      ++ lib.optionals isDarwin [
        aerospace
        sketchybar
      ];

    services.walker = lib.mkIf isLinux {
      enable = true;
    };
  };
}
