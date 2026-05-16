# 変更履歴 (PRレビュー対応およびCIエラー修正)

## 1. 変更箇所: `lib/helpers.nix` および `modules/home/common/default.nix`
*   **何故**: GitHub Actions の `macos-home-manager` や `nixos-config` のCIが `infinite recursion encountered`（無限再帰）エラーで失敗していたためです。このエラーは、`modules/home/common/default.nix` の `imports` セクション内でOSを判定するために `pkgs.stdenv.isDarwin` 等を参照したことで発生していました。Home Managerは `pkgs` の構築のために `imports` を評価しようとするため、そこで `pkgs` を参照すると依存関係がループしてしまいます。
*   **どのように**: `lib/helpers.nix` 側で `system` 変数からOSを判定した結果 (`isDarwin`, `isLinux`) を `extraSpecialArgs` に直接追加しました。そして `modules/home/common/default.nix` では、`pkgs` を使わずにその引数 (`isDarwin`, `isLinux`) を受け取って `imports` の条件分岐に使用するように修正しました。

## 2. 変更箇所: `flake.nix` (applyスクリプト部分)
*   **何故**: GitHub Copilot のレビューから、「macOSやWSLでは実際のホスト名(`hostname -s`)が、flake上の名前(`macbook` や `wsl`)と一致しないことが多く、そのまま `nix run .` を実行するとエラーになる可能性がある」との指摘を受けたためです。
*   **どのように**: `HOSTNAME="''${1:-$(hostname -s)}"` とすることで、`nix run . -- wsl` のようにコマンドライン引数からホスト名を直接指定（上書き）できるようにしました。引数がない場合はこれまで通り自動で `hostname -s` を取得して利用します。

## 3. 変更箇所: `hosts/*/home.nix` および `modules/home/common/default.nix` (前回の修正を含む)
*   **何故**: オプション名と引数名の衝突による評価エラーを防止するためです。
*   **どのように**: 各ホストの `home.nix` に直書きされていた `features` ブロックを削除し、純粋に `extraSpecialArgs` から渡される `features` 引数を参照する設計に統一しました。

## 4. 変更箇所: `modules/home/darwin/gui.nix` および `modules/home/linux/gui.nix`
*   **何故**: 前回 `modules/home/common/default.nix` で `options.features` を削除したことで、これらGUIモジュール内に記述されていた `config.features.gui` へのアクセスがエラー（`attribute 'features' missing`）を引き起こしていました。
*   **どのように**: これらのファイルはすでに親モジュール（`common/default.nix`）側で `isDarwin && guiEnabled` や `isLinux && guiEnabled` に基づいて条件付きでインポートされるようになっているため、ファイル内部での `config.features.gui` による条件分岐 (`lib.mkIf`) を削除し、直接パッケージリストを設定するように修正しました。
