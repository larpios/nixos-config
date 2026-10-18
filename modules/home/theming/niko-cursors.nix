# OneShot "Niko" cursor theme (packaged in pkgs/niko-cursors).
# Contributes to flake.modules.nixos.pc: installs the theme system-wide,
# selects it for the session and for the login greeter.
{...}: {
  flake.modules.nixos.pc = {pkgs, ...}: {
    environment.systemPackages = [
      (pkgs.callPackage ../../../pkgs/niko-cursors {})
    ];

    environment.sessionVariables = {
      XCURSOR_THEME = "niko-oneshot";
      XCURSOR_SIZE = "24";
    };

    services.displayManager.noctalia-greeter.cursorTheme = {
      package = pkgs.callPackage ../../../pkgs/niko-cursors {};
      name = "niko-oneshot";
    };
  };
}
