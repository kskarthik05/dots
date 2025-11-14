self: super: {
  xwayland = super.xwayland.overrideAttrs (oa: {
    patches = [
      ./patches/xwayland/xwayland-vsync.diff
    ];
  });
}
