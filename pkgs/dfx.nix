{ stdenv, fetchurl, autoPatchelfHook }:

let
  version = "0.25.1";  # 最新の安定版に更新
  system = if stdenv.isDarwin then "x86_64-darwin" else "x86_64-linux";
in
stdenv.mkDerivation {
  pname = "dfx";
  inherit version;

  src = fetchurl {
    url = "https://github.com/dfinity/sdk/releases/download/${version}/dfx-${version}-${system}.tar.gz";
    sha256 = ""; # バイナリの正しいSHA256ハッシュを追加する必要があります
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isLinux autoPatchelfHook;

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp dfx $out/bin/
    chmod +x $out/bin/dfx
  '';
}