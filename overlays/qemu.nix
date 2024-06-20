self: super: {
  qemu = super.qemu.overrideAttrs (oa: {
    patches = [
      ./patches/qemu/qemu-8.2.0.patch
    ];
  });
}

