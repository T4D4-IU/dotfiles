{ stdenv, fetchzip }:

let
  version = "0.25.0"; # バージョンを変数として定義
in
stdenv.mkDerivation {
  pname = "dfx";
  inherit  version; # バージョンを継承

  src = fetchzip {
    url = "https://github.com/dfinity/sdk/releases/download/${version}/dfx-${version}-x86_64-linux.tar.gz";
    sha256 = "OWqmvgMd2dT8rSlrrLtfmNm1/sjYa1h6+AbpX7uWdnk="; # SHA-256 ハッシュ
  };
  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';
}
