# 変更履歴 (changed_log.md)

## 2026-04-05: MacBook 設定の更新（Minecraft 削除, Prism Launcher 追加）

### 1. 何処を
- `hosts/macbook/default.nix`
- `README.md`
- `docs/MAC_SETUP.md`

### 2. 何故
- 公式の Minecraft ランチャーではなく、マルチインスタンス管理に優れた Prism Launcher を使用するため。

### 3. どのように
- `hosts/macbook/default.nix` の `homebrew.casks` リストから `minecraft` を削除し、`prismlauncher` を追加しました。
- `README.md` と `docs/MAC_SETUP.md` のアプリケーションリストから `Minecraft` を削除し、`Prism Launcher` を追加した際、リスト全体のアルファベット順を正しくソートしました。
- `docs/MAC_SETUP.md` の GUI アプリリストを `default.nix` と同様に厳密なアルファベット順（Brave, Discord, Ghostty, Google...）に整理しました。

## 2026-04-04: MacBook 設定の更新（Minecraft, OneDrive 追加）

### 1. 何処を
- `hosts/macbook/default.nix`
- `README.md`
- `docs/MAC_SETUP.md`

### 2. 何故
- MacBook の環境に `minecraft` と `onedrive` を追加するため。
- メインのドキュメントおよび macOS セットアップガイドのアプリケーションリストを現状に合わせて最新化するため。

### 3. どのように
- `hosts/macbook/default.nix` の `homebrew.casks` リストに `minecraft` と `onedrive` を追加しました。
- `README.md` の「ホスト: macbook」セクションの GUI アプリリストに `Minecraft`, `OneDrive` を追記しました。
- `docs/MAC_SETUP.md` の「GUIアプリ (macOS固有)」セクションに `Minecraft (ゲーム)`, `OneDrive (クラウドストレージ)` を追記しました。
