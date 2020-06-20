# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

 # Enable swapfile
 swapDevices = [
    {
      device = "/swapfile";
      priority = 0;
      size = 2048;
    }
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "lilicenco-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
	font = "Lat2-Terminus16";
	keyMap = "fr";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Enable no free software
  nixpkgs.config.allowUnfree = true;
 
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	wget vim mc htop screenfetch hplipWithPlugin ntfs3g
	kdeconnect okular gwenview kcolorchooser kget ktorrent
	libreoffice
  ];

  # Enabling Plasma Browser Integration
#  nixpkgs.config.firefox.enablePlasmaBrowserIntegration = true;
  
  # TLP power management
  services.tlp.enable = true;

  # tp-smapi for thinkpad work with TLP
  boot = {
    kernelModules = [ "tp_smapi" ];
    extraModulePackages = with config.boot.kernelPackages; [ tp_smapi ];
  };

  # Intel microcode
  hardware.cpu.intel.updateMicrocode = true;
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable intel video driver
  # services.xserver.videoDrivers = [ "intel" ];

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Auto login for SDDM (KDE)
  services.xserver.displayManager.sddm = {
  autoLogin.enable = true;
  autoLogin.user = "lilicenco";
  };

  # For Enable VIRTUALBOX
  virtualisation.virtualbox.host = {
	enable = true;
  	enableExtensionPack = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lilicenco = {
  	isNormalUser = true;
	extraGroups = ["networkmanager" "sudo" "wheel" "user-with-access-to-virtualbox" ]; # Enable ‘sudo’ for the user.
  };

  # Enable Automatic Upgrades
  system.autoUpgrade = {
	enable = true;
	# allowReboot = true;
	dates = "15:00";
	channel = https://nixos.org/channels/nixos-20.03;
  };

  # Nix Garbage Collector очистка системы каждую неделю пакеты которые страше 30 дней
  nix.gc = {
	automatic = true;
	dates = "weekly";
	options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

}

