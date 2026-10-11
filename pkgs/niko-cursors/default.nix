# XCursor theme: "niko-oneshot" — the Niko cursor set from OneShot,
# originally distributed as Windows .ani cursors by @minimoonbun.
#
# The files under ./niko-oneshot are the pre-converted XCursor theme
# (produced with `win2xcur`), committed directly so this package has no
# build-time dependencies. To regenerate, run win2xcur over the upstream
# .ani files and restore the standard XCursor names/aliases.
{stdenvNoCC, lib, ...}:
stdenvNoCC.mkDerivation {
  pname = "niko-oneshot-cursors";
  version = "unstable-2023-12-08";

  src = ./niko-oneshot;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/share/icons"
    cp -a "$src" "$out/share/icons/niko-oneshot"
    runHook postInstall
  '';

  meta = {
    description = "Niko (OneShot) animated XCursor theme";
    homepage = "https://twitter.com/minimoonbun/status/1733174903023812885";
    platforms = lib.platforms.all;
  };
}
