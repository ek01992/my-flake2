{
  lib,
  pkgs,
  ...
}:
{
  home = {
    username = "erik";
    homeDirectory = lib.mkDefault "erik";
    stateVersion = "26.05";
  };

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    helix.enable = true;
    ripgrep.enable = true;
    fastfetch.enable = true;
    git = {
      enable = true;
      settings = {
        user = {
          name = "Erik";
          email = "ek01992@proton.me";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
