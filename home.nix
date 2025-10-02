{ config, pkgs, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
  {
  # manage.
  home.username = "goldencoderam";
  home.homeDirectory = "/home/goldencoderam";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
    "mongodb-compass"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgsUnstable.devenv

    # Nvim related packages.
    pkgs.luarocks
    pkgs.nodejs_24

    # Clipboard utility for Vim.
    pkgs.xclip

    pkgs.picom

    pkgs.p7zip

    # Tmux session management.
    pkgs.sesh
    pkgs.tree-sitter

    # These are mine.
    pkgs.netcat

    pkgs.dbeaver-bin

    pkgs.podman-compose

    # Android development
    pkgs.android-studio
    pkgs.flutter
    pkgs.sqlite
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/goldencoderam/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    SHELL = "nu";
    EDITOR = "nvim";
  };

  services = {
      clipcat = {
          enable = true;
          menuSettings = {
              finder = "rofi";
              rofi = {
                  line_length = 80;
                  menu_length = 30;
                  menu_prompt = "Clipcat";
              };
          };
      };

    podman = {
      enable = true;
    };

    polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };
      script = ''
        for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
        MONITOR=$m polybar --reload bottom &
        done
        '';
      settings = {
        "ash" = {
          text = "#9c9eb4";
          subtext1 = "#a6adc3";
          subtext0 = "#9399ad";
          overlay2 = "#7f8497";
          overlay1 = "#686c7d";
          overlay0 = "#646782";
          surface2 = "#555873";
          surface1 = "#31323c";
          surface0 = "#1e2122";
          base = "#0a0a0c";
          mantle = "#020203";
          crust = "#000000";
          seafoam = "#8dd3c3";
          rose = "#e77f88";
          ember = "#d08770";
          storm = "#8796aa";
          crimson = "#bf616a";
          rust = "#bc735c";
          frost = "#96a8ad";
          sage = "#9db89c";
          tide = "#79a0aa";
          slate = "#7c7d8c";
          drift = "#8d9da1";
          charcoal = "#636778";
          fog = "#a0a0af";
          transparent = "#00000000";
        };
        "module/i3" = {
          type = "internal/i3";
          label-focused = "%index%";
          label-focused-padding = "1";
          label-focused-underline = "\${ash.ember}";
          label-focused-foreground = "\${ash.rose}";
          label-focused-background = "\${ash.surface0}";
          label-visible = "%index%";
          label-visible-padding = "1";
          label-visible-underline = "\${ash.surface1}";
          label-visible-background = "\${ash.surface0}";
          label-unfocused = "%index%";
          label-unfocused-padding = "1";
          label-unfocused-foreground = "\${ash.surface2}";
          label-unfocused-background = "\${ash.surface0}";
          label-urgent = "%index%";
          label-urgent-padding = "1";
          label-urgent-foreground = "\${ash.mantle}";
          label-urgent-underline = "\${ash.seafoam}";
          label-urgent-background = "\${ash.tide}";
        };
        "module/volume" = {
          type = "internal/pulseaudio";
          click-right = "pavucontrol &";
          format-volume = "<ramp-volume> <label-volume>";
          label-muted = " ";
          ramp-volume-0 = "";
          ramp-volume-1 = " ";
          ramp-volume-2 = " ";
          label-muted-foreground = "#666";
        };
        "module/time" = {
          type = "internal/date";
          interval = "1";
          date = "%Y/%m/%d | %H:%M";
        };
        "module/filesystem" = {
          type = "internal/fs";
          interval = "5";
          mount-0 = "/";
          label-mounted = "%free%";
          label-mounted-foreground = "\${ash.charcoal}";
        };
        "module/cpu" = {
          type = "internal/cpu";
          warn-percentage = "80";
          format = "<label>";
          label = "%percentage%  ";
          format-warn = "<label-warn>";
          label-warn = "%{F#bf616a}%percentage%   %{F-}";
        };
        "module/temp" = {
          type = "internal/temperature";
          interval = "1";
          thermal-zone = "0";
          hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input";
          base-temperature = "20";
          warn-temperature = "70";
          label = "%temperature-c% ";
          label-warn = "%{F#d08770}%temperature-c%   %{F-}";
        };
        "module/tray" = {
          type = "internal/tray";
          tray-spacing = "8px";
        };
      };
      config = {
        "bar/bottom" = {
          monitor = "\${env:MONITOR:}";
          bottom = true;
          font-0 = "CommitMono Nerd Font:size=10";
          modules-left = "i3";
          modules-right = "temp filesystem cpu time volume tray";
          separator = " : ";
          height = "20pt";
          background = "\${ash.transparent}";
          foreground = "\${ash.text}";
          padding-left = "10pt";
          padding-right = "10pt";
          line-size = 5;
          enable-ipc = true;
        };
      };
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    htop.enable = true;

    fzf = {
      enable = true;

      tmux.enableShellIntegration = true;
    };

    direnv = {
      enable = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    nushell = {
      enable = true;

      plugins = [
        pkgs.nushellPlugins.query
      ];

      shellAliases = {
        tsl = "sesh connect (sesh list | fzf)";
      };
      extraConfig = ''
        $env.config.edit_mode = "vi"

        # Direnv config.
        $env.config.hooks = {
          pre_prompt: [{ || 
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            if "ENV_CONVERSIONS" in $env and "PATH" in $env.ENV_CONVERSIONS {
              $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
            }
          }]
        }

        # Keybind config.
        $env.config.keybindings = [
          {
            name: history_hint_complete
            modifier: control
            keycode: char_y
            mode: [vi_normal, vi_insert]
            event: { send: HistoryHintComplete }
          }
        ]
      '';
    };

    oh-my-posh = {
      enable = true;

      enableNushellIntegration = true;
      settings = builtins.fromJSON(''
        {
          "version": 2,
          "final_space": true,
          "console_title_template": "{{ .Shell }} in {{ .Folder }}",
          "transient_prompt": {
            "background": "transparent",
            "foreground_templates": [
              "{{ if gt .Code 0 }}red{{ end }}",
              "{{ if eq .Code 0 }}magenta{{ end }}"
            ],
            "template": "❯ "
          },
          "secondary_prompt": {
            "background": "magenta",
            "foreground": "transparent",
            "template": "❯❯ "
          },
          "blocks": [
            {
              "type": "prompt",
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "type": "path",
                  "style": "plain",
                  "background": "transparent",
                  "foreground": "blue",
                  "template": "{{ .Path }}",
                  "properties": {
                    "style": "full"
                  }
                },
                {
                  "type": "git",
                  "style": "plain",
                  "background": "transparent",
                  "foreground": "gray",
                  "template": " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}{{ end }}{{ if gt .Ahead 0 }}{{ end }}",
                  "properties": {
                    "branch_icon": "",
                    "commit_icon": "@",
                    "fetch_status": true
                  }
                }
              ]
            },
            {
              "type": "rprompt",
              "overflow": "hidden",
              "segments": [ 
                {
                  "type": "executiontime",
                  "style": "plain",
                  "background": "transparent",
                  "foreground": "yellow",
                  "template": "{{ .FormattedMs }}",
                  "properties": {
                    "threshold": 5000
                  }
                } 
              ]
            },
            {
              "type": "prompt",
              "alignment": "left",
              "newline": true,
              "segments": [
                {
                  "type": "text",
                  "style": "plain",
                  "background": "transparent",
                  "foreground_templates": [
                    "{{ if gt .Code 0 }}red{{ end }}",
                    "{{ if eq .Code 0 }}magenta{{ end }}"
                  ],
                  "template": "❯"
                }
              ]
            }
          ]
        }
      '');
    };

    lazygit.enable = true;

    feh.enable = true;

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };

    tmux = {
      enable = true;
      shell = "${pkgs.nushell}/bin/nu";
      baseIndex = 1;
      prefix = "C-Space";
      keyMode = "vi";

      plugins = with pkgs; [
        tmuxPlugins.fingers
      ];

      extraConfig = ''
        # Base config
        set -g renumber-windows on

        # Statusbar
        set -g status-position top

        ## COLORSCHEME: everforest
        set -g status-style 'bg=#272E33'
        set -g status-right ""

        # Don't exit from tmux when closing a session
        set -g detach-on-destroy off

        # moving between panes with vim movement keys
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Kill panel
        bind-key "q" detach
        # Kill session
        bind-key "Q" kill-session

        # Sesh configuration
        bind-key "K" run-shell "sesh connect $(sesh list | fzf-tmux -p 55%,60%)"
      '';
    };
  };
}
