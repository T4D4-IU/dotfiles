{
  stdenv,
  fetchzip,
}: let
  version = "0.20.3";
in
  stdenv.mkDerivation {
    pname = "haystack-editor";
    inherit version;

    src = fetchzip {
      url = "https://d2dv27o1k99orf.cloudfront.net/Haystack+Editor+Linux-${version}.zip";
      sha256 = "sha256-ABs1aSpeFWEVag29OOQHd0F7HUHy9zXLTXtCDG+PQVk=";
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r * $out/bin
      runHook postInstall
    '';
  }
