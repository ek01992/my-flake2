{
  lib,
  pkgs,
  ...
}:
{
  # Change your-user
  home.username = "erik";
  # Change your-user
  home.homeDirectory = lib.mkDefault "erik";
  home.stateVersion = "26.05";

  imports = [
  ];
  programs.home-manager.enable = true;
  programs.bat.enable = true;
  programs.helix.enable = true;
  programs.ripgrep.enable = true;
  programs.fastfetch.enable = true;
  programs.git = {
    enable = true;
    settings.user = {
      name = "Erik";
      email = "ek01992@proton.me";
    };
    settings.init.defaultBranch = "main";
    settings.pull.rebase = true;
  };

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = [ "gtk" ];
  # };
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
}
