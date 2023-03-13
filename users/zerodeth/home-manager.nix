{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # For our MANPAGER env var
  # https://github.com/sharkdp/bat/issues/1145
  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
    '' else ''
    cat "$1" | col -bx | bat --language man --style plain
  ''));
in {
  # Home-manager 22.11 requires this be set. We never set it so we have
  # to use the old state version.
  home.stateVersion = "18.09";

  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = [
    pkgs.byobu
    pkgs.bat
    pkgs.exa
    pkgs.fd
    pkgs.fzf
    pkgs.btop
    pkgs.ctop
    pkgs.htop
    # pkgs.gtop
    pkgs.jq
    pkgs.ripgrep
    # pkgs.tree
    pkgs.tre-command
    pkgs.trash-cli
    pkgs.watch
    pkgs.thefuck
    pkgs.zoxide
    pkgs.tig
    # pkgs.bandwhich

    pkgs.gopls
    pkgs.zigpkgs.master
  ] ++ (lib.optionals isLinux [
    pkgs.chromium
    pkgs.firefox
    pkgs.k2pdfopt
    pkgs.rofi
    pkgs.zathura

    pkgs.tlaplusToolbox
    pkgs.tetex

    pkgs.nodejs-16_x
    pkgs.yarn
    # pkgs.vscode
    # pkgs.code-server
    pkgs.vscode-fhs        #TODO: Non-Compitable with M1
    pkgs.vscode-extensions.ms-vscode-remote.remote-ssh   #Fixing remote-ssh

  ]);

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    MANPAGER = "${manpager}/bin/manpager";
  };

  home.file.".gdbinit".source = ./gdbinit;
  home.file.".inputrc".source = ./inputrc;

  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  xdg.configFile."devtty/config".text = builtins.readFile ./devtty;

  # Rectangle.app. This has to be imported manually using the app.
  xdg.configFile."rectangle/RectangleConfig.json".text = builtins.readFile ./RectangleConfig.json;

  # tree-sitter parsers
  xdg.configFile."nvim/parser/proto.so".source = "${pkgs.tree-sitter-proto}/parser";
  xdg.configFile."nvim/queries/proto/folds.scm".source =
    "${sources.tree-sitter-proto}/queries/folds.scm";
  xdg.configFile."nvim/queries/proto/highlights.scm".source =
    "${sources.tree-sitter-proto}/queries/highlights.scm";
  xdg.configFile."nvim/queries/proto/textobjects.scm".source =
    ./textobjects.scm;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.gpg.enable = !isDarwin;

  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = [ "ignoredups" "ignorespace" ];
    initExtra = builtins.readFile ./bashrc;

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gcount = "git shortlog -sn";
      glg = "git log --stat";
      gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      gfa = "git fetch --all";
      gpa = "git pull --all";
    };
  };

  programs.direnv= {
    enable = true;

    config = {
      whitelist = {
        prefix= [
          "$HOME/code/go/src/github.com/hashicorp"
          "$HOME/code/go/src/github.com/zerodeth"
        ];

        exact = ["$HOME/.envrc"];
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      "source ${sources.theme-bobthefish}/functions/fish_prompt.fish"
      "source ${sources.theme-bobthefish}/functions/fish_right_prompt.fish"
      "source ${sources.theme-bobthefish}/functions/fish_title.fish"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gcp = "git cherry-pick";
      gdiff = "git diff";
      gl = "git prettylog";
      gcount = "git shortlog -sn";
      glg = "git log --stat";
      gwch = "git whatchanged -p --abbrev-commit --pretty=medium";
      gp = "git push";
      gs = "git status";
      gt = "git tag";
      gfa = "git fetch --all";
      gpa = "git pull --all";

      ls = "exa";
      ll = "exa -l";
      la = "exa --long --all --group --header --group-directories-first --sort=type --icons";
      lla = "exa -la";
      lg = "exa --long --all --group --header --git";
      lt = "exa --long --all --group --header --tree --level ";

      rm = "trash-put";
      unrm = "trash-restore";
      rmcl = "trash-empty";
      rml = "trash-list";

      # ossw = "sudo nixos-rebuild switch --flake '/etc/nixos/#nixtst' --impure -v";
      # hmsw = "home-manager switch --flake ~/.config/nixpkgs/#$USER";
      # upa = "nix flake update ~/.config/nixpkgs -v && sudo nix flake update '/etc/nixos/' -v";
      # fusw = "upa && ossw && hmsw";
      # rusw = "ossw && hmsw";
      ucl = "nix-collect-garbage -d && nix-store --gc && nix-store --repair --verify --check-contents && nix-store --optimise -vvv";
      scl = "sudo nix-collect-garbage -d && sudo nix-store --gc && sudo nix-store --repair --verify --check-contents && sudo nix-store --optimise -vvv";
      acl = "ucl && scl";

    } // (if isLinux then {
      # Two decades of using a Mac has made this such a strong memory
      # that I'm just going to keep it consistent.
      pbcopy = "xclip";
      pbpaste = "xclip -o";
    } else {});

    plugins = map (n: {
      name = n;
      src  = sources.${n};
    }) [
      "fish-fzf"
      "fish-foreign-env"
      "theme-bobthefish"
      "fish-kubectl-completions"
      # "plugin-git"   #TODO: Issue with VSCode
      # "gitnow"       #TODO: Required modifying config.fish prompt
      "fish-ssh-agent"
      "replay.fish"
      "sponge"
      "fish-abbreviation-tips"
    ];
  };

  programs.git = {
    enable = true;
    userName = "Sherif Abdalla";
    userEmail = "sherif@abdalla.uk";
    signing = {
      key = "FDA619F16BBFA377";
      signByDefault = true;
    };
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      core.editor = "code --wait";
      credential.helper = "store"; # want to make this more secure
      github.user = "zerodeth";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
    goPath = "code/go";
    goPrivate = [ "github.com/mitchellh" "github.com/hashicorp" "rfc822.mx" ];
  };

  programs.tmux = {
    enable = true;
    terminal = "xterm-256color";
    shortcut = "l";
    secureSocket = false;

    # plugins = with pkgs; [
    #   tmuxPlugins.nord
    # ];

    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"

      set -g @dracula-show-battery false
      set -g @dracula-show-network false
      set -g @dracula-show-weather false

      set -g mouse 'off'

      set -g @continuum-restore 'on'

      set -g @suspend_key 'F12'

      bind -n C-k send-keys "clear"\; send-keys "Enter"
      bind-key C-x setw synchronize-panes on \;  set-window-option status-bg red \; display-message "pane sync on"
      bind-key M-x setw synchronize-panes off \;  set-window-option status-bg default \; display-message "pane sync off"

      run-shell ${sources.tmux-pain-control}/pain_control.tmux
      run-shell ${sources.tmux-dracula}/dracula.tmux
      run-shell ${sources.tmux-resurrect}/resurrect.tmux
      run-shell ${sources.tmux-continuum}/continuum.tmux
      run-shell ${sources.tmux-suspend}/suspend.tmux
    '';
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "xterm-256color";

      key_bindings = [
        { key = "K"; mods = "Command"; chars = "ClearHistory"; }
        { key = "V"; mods = "Command"; action = "Paste"; }
        { key = "C"; mods = "Command"; action = "Copy"; }
        { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
        { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
        { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
      ];
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = builtins.readFile ./kitty;
  };

  programs.i3status = {
    enable = isLinux;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    plugins = with pkgs; [
      customVim.vim-cue
      customVim.vim-fish
      customVim.vim-fugitive
      customVim.vim-glsl
      customVim.vim-misc
      customVim.vim-pgsql
      customVim.vim-tla
      customVim.vim-zig
      customVim.pigeon
      customVim.AfterColors

      customVim.vim-nord
      customVim.nvim-comment
      customVim.nvim-lspconfig
      customVim.nvim-plenary # required for telescope
      customVim.nvim-telescope
      customVim.nvim-treesitter
      customVim.nvim-treesitter-playground
      customVim.nvim-treesitter-textobjects

      vimPlugins.vim-airline
      vimPlugins.vim-airline-themes
      vimPlugins.vim-eunuch
      vimPlugins.vim-gitgutter

      vimPlugins.vim-markdown
      vimPlugins.vim-nix
      vimPlugins.typescript-vim

      vimPlugins.YouCompleteMe
      vimPlugins.tabnine-vim
      # vimPlugins.vikube.vm
      vimPlugins.vim-terraform
    ];

    extraConfig = (import ./vim-config.nix) { inherit sources; };
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf isLinux {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  programs.fzf = {
		enable = false;
		tmux.enableShellIntegration = true;
		enableBashIntegration = true;
		enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;

    settings = {
      # header_margin = false;
      # hideKernelThreads = true;
      # hideThreads = true;
      # hideUserlandThreads = true;
      # sortKey = "PERCENT_CPU";
      # left_meters = [ "LeftCPUs2" "Memory" "Swap" "Hostname" ];
      # right_meters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];
      # left_meters = [ "LeftCPUs2" "Memory" "CPU" ];
      # right_meters = [ "RightCPUs2" "Tasks" "LoadAverage" "Uptime" ];

      fields = [ 50 0 48 17 18 38 39 40 2 46 47 49 1 ];
      sort_key = 111;
      sort_direction = 1;
      hide_threads = 1;
      hide_kernel_threads = 1;
      hide_userland_threads = 1;
      shadow_other_users = 0;
      show_thread_names = 0;
      show_program_path = 1;
      highlight_base_name = 0;
      highlight_megabytes = 0;
      highlight_threads = 0;
      tree_view = 1;
      header_margin = 1;
      detailed_cpu_time = 1;
      cpu_count_from_zero = 1;
      update_process_names = 0;
      account_guest_in_cpu_meter = 0;
      color_scheme = 6;
      delay = 15;
      left_meters = [ "CPU" "AllCPUs" ];
      left_meter_modes = [ 2 1 ];
      right_meters = [ "Blank" "Clock" "Uptime" "LoadAverage" "Tasks" "Swap" "Memory" ];
      right_meter_modes = [ 2 2 2 2 2 2 2 ];
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

}
