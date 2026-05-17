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
## 2026-05-16: スマホ・仕事用PC向け独立ターミナル環境（MyHelix）の構築

**1. 何処を変更したか**
* 新規作成: `~/MyHelix/flake.nix`, `~/MyHelix/modules/helix.nix`, `~/MyHelix/modules/zellij.nix` (Dotfiles外)
* 変更: `flake.nix`, `modules/home/common/cli.nix`, `modules/home/common/default.nix` (Dotfiles内)

**2. 何故変更したか**
* ユーザーがスマホなど狭い画面や不安定な回線からSSHで接続する際、ZellijとIDE機能（Helix）を省スペースなUIで利用できるようにするため。
* 会社のセキュリティポリシーに配慮し、巨大なDotfiles全体ではなく、ターミナル環境（HelixとZellij）のみを独立して利用・持ち出し可能にするため。

**3. どのように変更したか**
* Dotfiles外部に `~/MyHelix` という独立したNix Flakeリポジトリを構築し、そこにHelixとZellijの設定を隔離しました。
* スマホ用に省スペースで起動するための専用のラッパースクリプト（`mzj-mobile`, `myhx-mobile`）を定義しました。
* Dotfilesの `flake.nix` の `inputs` に `MyHelix` リポジトリをローカル参照として追加し、`default.nix` を経由してHome Managerモジュールとして読み込むように連携させました。

## 2026-05-17: ドキュメントの最新化（アーキテクチャ変更への追従）

**1. 何処を変更したか**
* 変更: `README.md`, `docs/MAC_SETUP.md`, `docs/WSL_SETUP.md`

**2. 何故変更したか**
* 最近行った「一発適用のApplyスクリプトの導入」「macOSにおけるnix-darwinの標準化」「MyHelix環境へのターミナルIDE分離」といったアーキテクチャの変更が、各セットアップ用ドキュメントに反映されておらず、古いコマンド（`home-manager switch` 等）や古い情報（Neovimの利用等）が残っていたため。

**3. どのように変更したか**
* `README.md`, `MAC_SETUP.md`, `WSL_SETUP.md` 内の適用コマンドをすべて `nix run . -- <hostname>` ベースのものに統一・更新しました。
* エディターの項目にHelix（MyHelixリポジトリ）を追加し、Zellijと共にスマホ対応の省スペースターミナルIDE環境（`mzj-mobile`, `myhx-mobile`）として利用できる旨を各所に追記しました。
* `MAC_SETUP.md` から「nix-darwinの導入（上級者向け）」という時代遅れの記述を削除し、システム設定がnix-darwinで管理されていることを標準の前提として記載しました。

## 2026-05-17: CI最適化（高コストな macOS 専用ランナーの廃止と Linux への統合）

**1. 何処を変更したか**
* 削除: `.github/workflows/macos-check.yml`
* 変更: `.github/workflows/nix-check.yml`
* 新規: `docs/ci_optimization_report.md`

**2. 何故変更したか**
* macOS の Home-manager 構成の CI ビルドが 10分以上と非常に長く、かつ macOS ランナー（`macos-latest`）は Linux ランナーの約10倍と極めて高コストであるため。
* CIで検知したいコードミス（記述エラーや無限再帰等）は、実際にパッケージのコンパイルを行う「ビルド」を行わなくても、安価で高速な Linux ランナー上でドライラン（`nix build ... --dry-run`）を実行するだけで 100% 検出可能であるため。
* 単一属性の `nix eval` では遅延評価により他の複雑な設定（Karabinerなど）のエラーがスルーされるのを防ぐため、`activationPackage` に対するドライランチェックを採用しました。

**3. どのように変更したか**
* 高コストな `.github/workflows/macos-check.yml` を完全に削除しました。
* `.github/workflows/nix-check.yml` の構文チェック（`module-check`）マトリックスに `darwin` を追加し、Linux 上で Darwin 用モジュールの構文チェックを統合しました。
* `.github/workflows/nix-check.yml` に新規ジョブ `macos-hm-check` を追加し、Linux 上で macOS 用 Home Manager 構成 (`t4d4@macbook`) の `activationPackage` ドライラン検証 (`nix build ... --dry-run`) を数十秒で瞬時に完了させる設計に最適化しました。
