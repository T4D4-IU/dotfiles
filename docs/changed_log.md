# 変更ログ

## 1. 何処を
- `/Users/t4d4/dotfiles/hosts/macbook/default.nix` 内の `homebrew.casks` のリスト

## 2. 何故
- ユーザーより Mac に Google-Gemini (https://formulae.brew.sh/cask/google-gemini#default) を追加したいという要望があったため。

## 3. どのように
- リストのアルファベット順を保つため、`"google-drive"` と `"google-japanese-ime"` の間に `"google-gemini"` を追記しました。

---
## 1. 何処を (追加修正)
- `/Users/t4d4/dotfiles/hosts/macbook/default.nix` 内の `homebrew` 設定

## 2. 何故 (追加修正)
- `google-gemini` などの新しいCaskを取得する際、ローカルのHomebrewインデックスが古いために `No available formula` エラーが発生したため。

## 3. どのように (追加修正)
- `homebrew` の設定に `onActivation.autoUpdate = true;` を追加し、Nix-Darwin環境の適用時（`darwin-rebuild switch` 実行時）にHomebrewが自動更新されるようにしました。

---
## 1. 何処を (Audiorelayの追加)
- `/Users/t4d4/dotfiles/hosts/macbook/default.nix` 内の `homebrew.casks` リスト

## 2. 何故 (Audiorelayの追加)
- ユーザーより Audiorelay の追加要望があったため。

## 3. どのように (Audiorelayの追加)
- アルファベット順を保つため、`"appcleaner"` と `"bluestacks"` の間に `"audiorelay"` を追記しました。

---
## 1. 何処を (AudioRelayの削除)
- `/Users/t4d4/dotfiles/hosts/macbook/default.nix` 内の `homebrew.casks` リスト

## 2. 何故 (AudioRelayの削除)
- ユーザーより「AudioRelayの調子が悪いので一度消したい」という要望があったため。

## 3. どのように (AudioRelayの削除)
- `homebrew.casks` のリストから `"audiorelay"` を削除しました。

---
## 1. 何処を (SonoBusの追加)
- `/Users/t4d4/dotfiles/hosts/macbook/default.nix` 内の `homebrew.casks` リスト

## 2. 何故 (SonoBusの追加)
- ユーザーより代わりに SonoBus を追加したいという要望があったため。

## 3. どのように (SonoBusの追加)
- アルファベット順を保つため、`"shottr"` と `"spotify"` の間に `"sonobus"` を追記しました。

---
## 1. 何処を (Escrcpyの追加) — 2026-05-14
- `hosts/macbook/escrcpy.nix`（新規作成）
- `hosts/macbook/default.nix`

## 2. 何故 (Escrcpyの追加)
- Escrcpy（scrcpy の GUI フロントエンド）を追加するにあたり、Homebrew の Cask（`viarotel-org/escrcpy`）経由でのインストールを試みたが、Cask の `postflight` スクリプトにユーザー入力待ちの処理があり、`darwin-rebuild switch` 経由ではプロンプトが表示されずハングする問題が発生した。
- そのため Homebrew を使わず、Nix derivation として GitHub Releases から `.dmg` を直接取得・展開する方式に切り替えた。

## 3. どのように (Escrcpyの追加)
1. `hosts/macbook/escrcpy.nix` を新規作成。`fetchurl` で GitHub Releases の `.dmg` を取得し、`undmg` で展開して `$out/Applications/Escrcpy.app` に配置する derivation を定義。
2. `hosts/macbook/default.nix` の引数を `_:` から `{ pkgs, ... }:` に変更し、`environment.systemPackages` で上記 derivation を導入。
3. Mac 専用 GUI アプリの設定を `hosts/macbook/` 配下に閉じることで、他プラットフォームへの影響を回避。

---
## 1. 何処を (English Paper Readerの追加) — 2026-05-14
- `hosts/macbook/english-paper.nix`（新規作成）
- `hosts/macbook/default.nix`

## 2. 何故 (English Paper Readerの追加)
- 英語論文を読みながら単語を登録・復習できる macOS アプリ「English Paper Reader」を追加するため。
- Homebrew Cask には存在しないため、Escrcpy と同様に Nix derivation で GitHub Releases から直接取得する方式を採用。

## 3. どのように (English Paper Readerの追加)
1. `hosts/macbook/english-paper.nix` を新規作成。`fetchurl` で GitHub Releases の `.zip` を取得し、`unzip` で展開して `$out/Applications/PapersApp.app` に配置する derivation を定義。
2. `hosts/macbook/default.nix` の `environment.systemPackages` に追加。
