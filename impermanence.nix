{ inputs, lib, ... }:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    # 1. Wait for LUKS
    udevadm settle
    # 2. Force the pool into the "garage"
    zpool import -f -N rpool
    # 3. Clean the slate
    zfs rollback -r rpool/local/root@blank
    # 4. Give the pool back to the system
    zpool export rpool
  '';

  environment.persistence."/persist" = {
    directories = [
      # "/var/lib/sbctl"
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
