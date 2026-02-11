{ config, pkgs, ... }:

{
  # 1. パッケージのインストール
  home.packages = [ pkgs.code-server ];

  # 2. Systemd ユーザーサービスの定義
  # (Home Managerに専用オプションがないため、自分で定義します)
  systemd.user.services.code-server = {
    Unit = {
      Description = "code-server";
      After = [ "network.target" ];
    };

    Service = {
      Type = "simple";
      # 起動コマンド
      # --bind-addr: 127.0.0.1:8080 (Tailscale ServeやSSHトンネル用)
      # --auth: password (設定ファイルのパスワードを使用)
      # 必要に応じて --user-data-dir などを追加可能
      ExecStart = "${pkgs.code-server}/bin/code-server --bind-addr 127.0.0.1:8080 --auth password";

      # 落ちても再起動する設定
      Restart = "always";

      # 環境変数の設定が必要な場合はここに追加
      Environment = "PATH=${config.home.profileDirectory}/bin:/usr/bin:/bin";
    };

    Install = {
      # ログイン時に自動起動
      WantedBy = [ "default.target" ];
    };
  };
}
