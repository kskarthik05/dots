self: super: {
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (oa: {
    patches = [
      ./patches/sway/tearing1.patch
      ./patches/sway/tearing2.patch
      ./patches/sway/tearing3.patch
      ./patches/sway/tearing4.patch
      ./patches/sway/tearing5.patch
      ./patches/sway/tearing6.patch
    ];
  });
}
