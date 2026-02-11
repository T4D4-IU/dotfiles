{ config, pkgs, ... }:

{
  # パッケージのインストールとサービスの有効化をここで行います
  services.code-server = {
    enable = true;

    # ポート設定（デフォルトは8080）
    port = 8080;

    # 【重要】セキュリティ設定
    # Tailscaleを使っているのであれば、
    # 1. "127.0.0.1" (localhostのみ) にして SSHポートフォワードで接続する
    # 2. TailscaleのIPアドレスを指定して、Tailscale経由でのみアクセスさせる
    # のどちらかが安全です。"0.0.0.0" (全公開) は認証があってもリスクがあります。
    host = "127.0.0.1";

    # 認証設定 ("password" または "none")
    # TailscaleやSSH経由なら "none" でも比較的安全ですが、
    # 念のため "password" にして ~/.config/code-server/config.yaml のパスワードを使うのが無難です。
    auth = "password";
  };
}
