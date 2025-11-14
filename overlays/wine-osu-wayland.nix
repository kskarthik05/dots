self: super: {
  wineWowPackages = super.wineWowPackages // {
    waylandFull = super.wineWowPackages.waylandFull.overrideAttrs (oa: {
      patches = [
        ./patches/wine-osu-wayland/wine-pulse-patch.patch
      ];
    });
  };
}
