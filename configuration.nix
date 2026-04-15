{
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
  ];
  # environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # enable = lib.mkForce false;
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
    # lanzaboote = {
    #   enable = true;
    #   pkiBundle = "/var/lib/sbctl";
    # };
    initrd.luks.devices = {
      cryptroot = {
        device = "/dev/disk/by-uuid/de330c56-2815-45f4-8c88-811e55b8080c";
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
        initialHashedPassword = "$y$j9T$.m8fpA6JBHBgvdjhwBk/d.$IyYFB0lUq4rSxJsqGDNczXmwVpH8S72ZBxefpi9ZJH5";
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
        AuthorizedKeysFile /home/%u/.ssh/authorized_keys
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
