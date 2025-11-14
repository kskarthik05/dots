{pkgs, ... }: {
programs = {
  gamescope = {
    enable = true;
    capSysNice = true;
  };
  steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
};
hardware.xone.enable = true; # support for the xbox controller USB dongle
}
