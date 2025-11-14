self: super: {
  linuxZenWMuQSS = pkgs.linuxPackagesFor (pkgs.linux_zen.override {
    structuredExtraConfig = with lib.kernel; {
      SCHED_MUQSS = yes;
    };
    ignoreConfigErrors = true;
  }
