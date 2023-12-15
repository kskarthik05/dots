{ config, pkgs, ... }:
{
  # …

  # Don't allow mutation of users outside of the config.
  users.mutableUsers = false;

  # Set a root password, consider using initialHashedPassword instead.
  #
  # To generate a hash to put in initialHashedPassword
  # you can do this:
  # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd
  users.users.root.initialHashedPassword = "$6$VB2.r0lLdqZ8KWEi$/UMLDeXwSRvZAQ22HUJqFnecbh8VzLiuv8gsLMfrXlL7tCbT9XyGtUleXtrvNMsjKpchc6sdnCPGkBOC3UkM/1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.keisuke5 = {
    home="/home/keisuke5";
    initialHashedPassword="$6$ZKqa0w3vM1rX9f1W$GvWMBomAs1pSgwQ2C6p8DZg5tvOdGNIxks7RpPUcIY9Rnf.aLH3kBPkEts28FFfPtkHXtTM.q0JkXP.u5m4NC0";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      tree
    ];
  };

}
