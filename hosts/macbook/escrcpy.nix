# Escrcpy - Graphical Scrcpy to display and control Android devices
# https://github.com/viarotel-org/escrcpy
#
# Note: The DMG uses APFS format, so we use 7zz instead of undmg (HFS+ only).
{
  stdenvNoCC,
  fetchurl,
  _7zz,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "escrcpy";
  version = "2.10.2";

  src = fetchurl {
    url = "https://github.com/viarotel-org/escrcpy/releases/download/v${version}/Escrcpy-${version}-mac-arm64.dmg";
    hash = "sha256-8BsqhXI7yf7aRC3s5dzw8UHS4a9bV2UwNTT4VG6vXb4=";
  };

  nativeBuildInputs = [_7zz];

  unpackPhase = ''
    7zz x $src -oextracted
  '';

  sourceRoot = "extracted";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -pR Escrcpy.app "$out/Applications/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Graphical Scrcpy to display and control Android devices, powered by Electron";
    homepage = "https://github.com/viarotel-org/escrcpy";
    license = licenses.asl20;
    platforms = ["aarch64-darwin"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
  };
}
