{ stdenv, fetcFromGitHub }:

let
  version = "0.25.0"; # バージョンを変数として定義
in
stdenv.mkDerivation {
  pname = "dfx";
  inherit  version; # バージョンを継承

  src = fetcFromGitHub {
    owner = dfinity;
    repo = "sdk";
    rev = "v${version}";
    sha256 = "0hjz2xjahj2byzbbdf6x47qafdffhcgv2ikrwbh5mbcxp4iy41ww"; # SHA-256 ハッシュ
  };
}
