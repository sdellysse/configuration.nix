{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  # For enpass
  nixpkgs.config.allowUnfree = true;

  # Bootlooader Configuration
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [
    "pcie_aspm=force"
    "i915.i915_enable_rc6=1"
    "i915.i915_enable_fbc=1"
    "i915.lvds_downclock=1"
  ];

  # Misc System Config
  hardware.pulseaudio.enable       = true;
  security.sudo.wheelNeedsPassword = false;
  services.ntp.enable              = true;
  time.timeZone                    = "America/New_York";

  # Networking 
  networking.hostName              = "nix";
  networking.networkmanager.enable = true;

  # Setup root and regular users. Don't allow usage of user{add,mod,del}
  users = {
    mutableUsers = false;

    users.root = {
      hashedPassword = "$6$EH26T4KF$F5tdXgFINwdWq8MSr8quCjn0TW0sFNJiyfBu0gmPxW74ypDo3iz1gKC/f2lJSutp/q2x9je72vNX.B4gWl/Hz/";
    };

    extraUsers.shawn = {
      isNormalUser   = true;
      hashedPassword = "$6$2PcChvFIM$wcWiPdRdtn8ONFNifwgvalU1s0Lrl030juZ/zg6OCC/hr9e8sepH3pG4MYo3lS0j6yCnQDIz26F1ExLpKi3kP.";
      extraGroups    = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  # Packages
  environment.systemPackages = [
    pkgs.enpass
    pkgs.irssi
    pkgs.firefox
    pkgs.git
    pkgs.powertop
    pkgs.nodejs
    pkgs.vim
    pkgs.xsel

    # For X220
    pkgs.linuxPackages.acpi_call
    pkgs.linuxPackages.tp_smapi
  ];


  # Enable the X Server
  services.xserver.enable                        = true;
  services.xserver.displayManager.lightdm.enable = true;

  # Enable XFCE
  services.xserver.desktopManager.xfce.enable = true;
  services.udisks2.enable                     = true;

  # TLP for power management
  services.tlp.enable = true;
}
