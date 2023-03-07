# export NIXPKGS_ALLOW_UNFREE=1 && fnix $HOME/code/nixos-config/examples/cli-tools/cli-shell.nix

with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "cli-env";

  buildInputs = with pkgs; [

    ## Utils
    thefuck             # Auto-correct miss-typed commands
    # zoxide              # Easy navigation (better cd)
    tldr                # Community-maintained docs (better man)
    scc                 # Count lines of code (better cloc)
    exa                 # Listing Files (better ls)
    duf                 # Disk Usage (better df)
    aria2               # Download Utility (better wget)
    # bat                 # Reading Files (better cat)
    diff-so-fancy       # File Comparisons (better diff)
    entr                # Watch for changes
    exiftool            # Reading + writing metadata
    fdupes              # Duplicate file finder
    # fzf                 # Fuzzy file finder (better find)
    hyperfine           # Command benchmarking
    just                # Modern command runner (better make)
    # jq                  # JSON processor
    yq                  # YAML processor
    most                # Multi-window scroll pager (better less)
    procs               # Process viewer (better ps)
    # rip                 # Deletion tool (better rm)
    # ripgrep             # Search within files (better grep)
    ack                 # grep like source code search tool
    # rsync               # Fast, incremental file transfer
    sd                  # Find and replace (better sed)
    # tre-command         # Directory hierarchy (better tree)
    xsel                # Access the clipboard

    ## CLI Monitoring and Performance Apps
    bandwhich           # Bandwidth utilization monitor
    # ctop                # Container metrics and monitoring
    # btop                # Resource monitoring (better htop)
    glances             # Resource monitor + web and API
    gping               # Interactive ping tool (better ping)
    dua                 # Disk usage analyzer and monitor (better du)
    speedtest-cli       # Command line speed test utility
    dog                 # DNS lookup client (better dig)

    ## CLI Productivity Apps
    browsh              # CLI web browser
    # buku                # Bookmark manager
    # cmus                # Music browser / player
    cointop             # Track crypto prices
    ddgr                # Search the web from the terminal
    micro               # Code editor (better nano)
    # khal                # Calendar client
    # mutt                # Email client
    # newsboat            # RSS / ATOM news reader
    # rclone              # Manage cloud storage
    # taskwarrior         # Todo + task management
    tuir                # Terminal UI for Reddit

    ## CLI Dev Suits
    # httpie              # HTTP / API testing testing client
    xh                  # Friendly and fast tool for sending HTTP requests (better httpie)
    lazydocker          # Full Docker management app
    lazygit             # Full Git management app
    # tig                 # text-mode interface for Git
    kdash               # Kubernetes dashboard app
    # gdp-dashboard       # Visual GDP debugger

    ## CLI External Sercvices
    ngrok               # Reverse proxy for sharing localhost
    tmate               # Share a terminal session via internet
    byobu               # GNU Screen terminal multiplexer (better tmux)
    asciinema           # Recording + sharing terminal sessions
    navi                # Interactive cheat sheet
    # transfer.sh         # Fast file sharing
    surge               # Deploy a site in seconds
    # wttr.in             # Check the weather

    ## CLI Fun
    cowsay              # Have an ASCII cow say your message
    figlet              # Output text as big ASCII art text
    lolcat              # Make console output raibow colored
    toilet              # A tool to display ASCII-art fonts
    neofetch            # Show system data and ditstro info

  ];

  # The '' quotes are 2 single quote characters
  # They are used for multi-line strings
  shellHook = ''
    figlet "CLI Tools!" | lolcat --freq 0.5
    neofetch

  '';
}
