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

    persistence."/persist" = {
      directories = [
        { directory = ".ssh"; mode = "0700"; }
        { directory = ".config/git"; mode = "0700"; }
      ];
    };
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
    desktop = null;
    documents = null;
    download = "/home/erik/downloads";
    music = null;
    pictures = null;
    publicShare = null;
    templates = null;
    videos = null;
    extraConfig = {
      XDG_PROJECTS_DIR = "/home/erik/projects";
      XDG_NOTES_DIR = "/home/erik/notes";
    };
  };
}
