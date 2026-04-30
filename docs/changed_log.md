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
