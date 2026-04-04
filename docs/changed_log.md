# 変更履歴 (changed_log.md)

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
