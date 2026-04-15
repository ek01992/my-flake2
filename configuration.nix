{
  ...
}:

{
  imports = [
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

  boot = {
    loader = {
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
    supportedFilesystems = [ "zfs" ];
    zfs = {
      devNodes = "/dev/";
      requestEncryptionCredentials = false;
    };
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/1639f270-49c7-4802-a5e4-ce5dde56a7d6";
        allowDiscards = true;
        preLVM = true;
      };
    };
    kernelParams = [ "console=tty1" ];
  };

  systemd.services.zfs-mount.enable = false;

  networking = {
    hostId = "e1add2a5";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ------------------------------------------------------------------
  #  Users
  # ------------------------------------------------------------------

  users = {
    mutableUsers = false;
    users = {
      root.initialPassword = "$y$j9T$CX.Q79tmrCY1nKHGCpjq2.$uqarPMOsKeIbAUMp9C26DyGVHAkS2cTxNCTjj714VD.";
      erik = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
         ];
        group = "erik";
        initialHashedPassword = "$y$j9T$CX.Q79tmrCY1nKHGCpjq2.$uqarPMOsKeIbAUMp9C26DyGVHAkS2cTxNCTjj714VD.";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAFlPT1jGxLHKRxId53rGNGWT6pI8HzGQ2nyKcG4RGBa erik@home-desktop"
        ];
      };
    };
    groups.erik = {};
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = true;
        PrintMotd = false;
        UsePAM = true;
      };
      extraConfig = ''
        AllowGroups wheel
        PermitEmptyPasswords no
        ChallengeResponseAuthentication no
        AuthenticationMethods publickey
        AuthorizedKeysFile /home/erik/.ssh/authorized_keys
      '';
    };
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
      # autoSnapshot = true;
    };
  };
  system.stateVersion = "26.05";
}
