{
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./impermanence.nix
  ];
  #============================#
  #      Lanzaboote
  # ===========================#
  # environment.systemPackages = [ pkgs.sbctl ];

  # boot.loader.systemd-boot.enable = lib.mkForce false;

  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/var/lib/sbctl";
  # };
  # =================================#

  boot.loader = {
    systemd-boot = {
      enable = true;
      consoleMode = "max";
      editor = false;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/"; # Critical for VMs
  # Not needed with LUKS
  boot.zfs.requestEncryptionCredentials = false;
  # systemd handles mounting
  systemd.services.zfs-mount.enable = false;

  services.zfs = {
    autoScrub.enable = true;
    # periodically runs `zpool trim`
    trim.enable = true;
    # autoSnapshot = true;
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      # replace `uuid#` with output of UUID # from `sudo blkid /dev/vda2`
      device = "/dev/disk/by-uuid/1639f270-49c7-4802-a5e4-ce5dde56a7d6";
      allowDiscards = true;
      preLVM = true;
    };
  };

  # ------------------------------------------------------------------
  #  Basic system
  # ------------------------------------------------------------------
  # Unique 8-hex hostId (run once in live ISO: head -c4 /dev/urandom | xxd -p)
  networking.hostId = "e1add2a5"; # <<<--- replace with your own value
  networking.networkmanager.enable = true;

  users.users.root.initialPassword = "$y$j9T$CX.Q79tmrCY1nKHGCpjq2.$uqarPMOsKeIbAUMp9C26DyGVHAkS2cTxNCTjj714VD."; # change after first login

  boot.kernelParams = [ "console=tty1" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ------------------------------------------------------------------
  #  Users
  # ------------------------------------------------------------------

  users.mutableUsers = false;

  # CHANGE `your-user`
  users.users.erik = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    group = "erik";
    # :r /tmp/pass.txt:
    initialHashedPassword = "$y$j9T$CX.Q79tmrCY1nKHGCpjq2.$uqarPMOsKeIbAUMp9C26DyGVHAkS2cTxNCTjj714VD.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFlPT1jGxLHKRxId53rGNGWT6pI8HzGQ2nyKcG4RGBa erik@home-desktop"
    ];
  };

  # This enables `chown -R your-user:your-user`
  # CHANGE `your-user`
  users.groups.erik = { };

  # ------------------------------------------------------------------
  #  (Optional) Helpful for recovery situations
  # ------------------------------------------------------------------
  # users.users.admin = {
  #  isNormalUser = true;
  #  description = "admin account";
  #  extraGroups = [ "wheel" ];
  #  group = "admin";
  # initialHashedPassword = "Output of `:r /tmp/pass.txt`";
  # };

  # users.groups.admin = { };
  # ------------------------------------------------------------------

  # ------------------------------------------------------------------
  # (Optional) Enable SSH for post-install configuration
  # ------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = "no";
      KbdInteractiveAuthentication = "no";
      PrintMotd = "no";
      UsePAM = "yes";
      X11Forwarding = "no";
      PermitEmptyPasswords = "no";
      PubkeyAuthentication = "yes";
    };
  };
  system.stateVersion = "26.05";
}
