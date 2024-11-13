{ pkgs, xclj-pkgs, metadata, ... }:

{
  imports =
    [
      ./hardware.nix
      ./modules
      ../shared
    ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;
  services.libinput.touchpad.naturalScrolling = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.displayManager.session = [
    {
      manage = "window";
      name = "xclj";
      start = ''
       ${xclj-pkgs.default}/bin/xclj &
       waitPID=$!
      '';
    }
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${metadata.username} = {
    isNormalUser = true;
    description = "${metadata.fullname}";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["${metadata.username}"];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  virtualisation.docker.enable = true;

  system.stateVersion = "24.05";

  fonts.packages = with pkgs; [ source-code-pro ];

  services.autorandr = {
    enable = true;
    hooks = {
      postswitch = {"status-bar" = "${pkgs.eww}/bin/eww open --screen 0 bar";};
    };
    profiles = {
      "laptop" = {
        fingerprint = {
          "eDP-1" = "00ffffffffffff0030e48d0600000000001e0104951f1178e2adf5985e598b261c5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a582b80a070381f403020350035ae1000001a000000fe00304858434b803134305746480a000000000000413199001000000a010a20200082";
        };
        config = {
          "eDP-1" = {
            enable = true;
            primary = true;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };
      "dual" = {
        fingerprint = {
          "eDP-1" = "00ffffffffffff0030e48d0600000000001e0104951f1178e2adf5985e598b261c5054000000010101010101010101010101010101012e3680a070381f403020350035ae1000001a582b80a070381f403020350035ae1000001a000000fe00304858434b803134305746480a000000000000413199001000000a010a20200082";
          "HDMI-1" = "00ffffffffffff0010acf7414c3336301e210103803c2278eab9a5a356509f260e5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c450056502100001e000000ff004837394a3650330a2020202020000000fc0044454c4c205332373231484e0a000000fd00304b1e5312000a202020202020011b02032bf14f90050403020716010611121513141f230907078301000065030c001000681a00000101304be62a4480a0703827403020350056502100001a011d8018711c1620582c250056502100009e011d007251d01e206e28550056502100001e8c0ad08a20e02d10103e9600565021000018000000000000000000000000f0";
        };
        config = {
          "eDP-1" = {
            enable = true;
            primary = true;
            position = "0x1080";
            mode = "1920x1080";
          };
          "HDMI-1" = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
          };
        };
      };
    };
  };

}
