{
  sound.enable = false;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
  context.properties = {
    default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000];
    default.clock.rate = 48000;
    default.clock.quantum = 32;
    default.clock.min-quantum = 4;
    default.clock.max-quantum = 128;
  };
  };
}
