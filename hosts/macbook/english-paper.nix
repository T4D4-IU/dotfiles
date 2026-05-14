# English Paper Reader - Read English papers and register vocabulary
# https://github.com/mksmkss/English-Paper
#
# macOS native app (Swift/SwiftUI) distributed as a .zip archive.
{
  stdenvNoCC,
  fetchurl,
  unzip,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "english-paper-reader";
  version = "0.1.6";

  src = fetchurl {
    url = "https://github.com/mksmkss/English-Paper/releases/download/v${version}/PapersApp-macOS.zip";
    hash = "sha256-ikB1lqJQXCIBt3h3R/jh2hEUdI1oMJNAHpPzMqplcIM=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src -d extracted
  '';

  sourceRoot = "extracted";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -pR PapersApp.app "$out/Applications/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Read English papers and register vocabulary for review";
    homepage = "https://github.com/mksmkss/English-Paper";
    license = licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
