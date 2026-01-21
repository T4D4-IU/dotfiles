# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: {
  # Bootloader and kernel configuration
  boot = {
    # change kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    # Bootloader.
    # boot.loader.grub.enable = true;
    # boot.loader.grub.device = "/dev/sda";
    # boot.loader.grub.useOSProber = true;
    # systemd-bootを有効化
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true; # Nix storeの最適化
      experimental-features = ["nix-command" "flakes"];
    };
    # ガベージコレクションを自動実行
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # プロプライエタリなパッケージを許可する
  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networkmanager.enable = true;

    firewall = {
      enable = true;
      # tailscaleの仮想NICを信頼する
      # `<Tailscaleのホスト名>:<ポート番号>`のアクセスが可能になる
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };
  };

  xdg.portal.enable = true;

  # Enable Docker
  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true; # $DOCKER_HOSTを設定
      };
    };
  };

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ]
    # xremapのNixOS modulesを使えるようにする
    ++ [
      inputs.xremap.nixosModules.default
    ];

  services = {
    # tailscaleを有効化
    tailscale.enable = true;

    # Linuxデスクトップ向けのパッケージマネージャー
    # アプリケーションをサンドボックス化して実行する
    # NixOSが対応していないアプリのインストールに使う
    flatpak.enable = true;

    # xremapでキー設定をいい感じに変更
    xremap = {
      userName = "t4d4";
      serviceMode = "system";
      config = {
        modmap = [
          {
            # CapsLockをCtrlに置換
            name = "CapsLock is dead";
            remap = {
              CapsLock = "Ctrl_L";
            };
          }
        ];
        keymap = [
          {
            # Ctrl + HがどのアプリケーションでもBackSpaceになるように変更
            name = "Ctrl+H should be enabled on all apps as BackSpace";
            remap = {
              C-h = "Backspace";
            };
            # 一部アプリケーションを対象から除外
            application = {
              not = ["Alacritty" "Kitty" "Wezterm" "warp-terminal"];
            };
          }
        ];
      };
    };

    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "jp";
        variant = "";
      };
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "ja_JP.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "ja_JP.UTF-8";
      LC_IDENTIFICATION = "ja_JP.UTF-8";
      LC_MEASUREMENT = "ja_JP.UTF-8";
      LC_MONETARY = "ja_JP.UTF-8";
      LC_NAME = "ja_JP.UTF-8";
      LC_NUMERIC = "ja_JP.UTF-8";
      LC_PAPER = "ja_JP.UTF-8";
      LC_TELEPHONE = "ja_JP.UTF-8";
      LC_TIME = "ja_JP.UTF-8";
    };

    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5.addons = [pkgs.fcitx5-mozc];
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.t4d4 = {
    isNormalUser = true;
    description = "t4d4";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # enable packages with config
  programs = {
    git = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true; # $EDITOR=nvim
    };

    zsh = {
      enable = true;
    };
    # Install firefox.
    firefox.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
