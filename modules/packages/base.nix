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
        # === Utilities ===
        yazi # TUI File Explorer
        btop # System Monitoring
        bat # Cat with syntax highlighting
        ast-grep # AST Grep
        duf # Disk Usage/Free Utility
        dust # A better du
        fastfetch # System Information Tool
        fd # Simple, fast and user-friendly alternative to find
        hexyl # Hex viewer
        ripgrep # Search tool
        ripgrep-all # Search tool that supports multiple file types
        fzf # Fuzzy Finder
        tealdeer # Fuzzy Finder
        tokei # Code stats

        # === Shell ===
        starship # Custom Prompt Engine
        nushell
        fish
        bash-completion # Shell Completion
        fish-lsp # Fish shell LSP

        # === Version Control System ===
        git
        jujutsu
        jj-starship
        gh # GitHub CLI
        delta # Git diff viewer
        difftastic # Git diff viewer

        # === Editors ===
        neovim
        tree-sitter # Neovim Syntax Highlighting

        # === Languages ===
        rust-parallel
        rust-script
        rustup
        nil # Nix language server
        alejandra # Nix formatter
        zig

        # === Media ===
        yt-dlp      # Video Downloader
        ffmpeg      # Video manipulation
        mpv         # Media player
        chafa       # Image viewer
        imagemagick # Image Manipulation

        # === Fonts ===
        nerd-fonts.jetbrains-mono

        # === Archiver ===
        _7zz-rar
        ouch
        unzip

        # === LLM Agents ===
        # inputs.llm-agents.packages.${hostSystem}.claude-code
        # inputs.llm-agents.packages.${hostSystem}.gemini-cli
        # inputs.llm-agents.packages.${hostSystem}.opencode
        # inputs.llm-agents.packages.${hostSystem}.rtk

        # === Build System ===
        just
        gnumake 
        cmake
        ninja

        # === Security ===
        openssh 
        ssh-to-age
        sops
        age
        bitwarden-cli
        vaultwarden

        # === Nix ===
        nh # Nix helper
        cachix # Nix package cache

        # === Multiplexers ===
        zellij # Modern Terminal Multiplexer in Rust
        tmux # Terminal Multiplexer 

        # === Misc ===
        nb # local web note‑taking, bookmarking, archiving, and knowledge base
        cargo-binstall # Install binaries from crates.io
        cargo-watch # Watch and recompile a project on file changes
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
        aerospace # Tiling window manager
        sketchybar # Status bar
      ];
  };
}
