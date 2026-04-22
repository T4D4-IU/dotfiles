# エラーレポート 4

## 状況の整理
Nix-Darwin経由でHomebrewを管理している環境では、デフォルトで `brew` コマンドへのパス（環境変数PATH）が通っていないため、直接 `brew` コマンドを叩くことができません。（`command not found: brew` の原因です）

Apple Silicon (M1/M2/M3/M4) のMacでは、Homebrewの実体は `/opt/homebrew/bin/brew` に配置されています。

## 修正計画

Nix-Darwinから離れて強制的にキャッシュをクリアするという基本方針は変わりませんが、コマンドを**フルパス**（`/opt/homebrew/bin/brew`）で指定して実行します。

### どのように修正するか

お手元のターミナルで、以下のコマンドを順番に実行してください。

**1. Homebrewのキャッシュクリアと強制アップデート（フルパス指定）**
```bash
/opt/homebrew/bin/brew cleanup
rm -rf $(/opt/homebrew/bin/brew --cache)
/opt/homebrew/bin/brew update --force
```

**2. 認識されたかの確認**
```bash
/opt/homebrew/bin/brew search google-gemini
```
ここで `==> Casks` の下に `google-gemini` が表示されれば無事修復完了です！

**3. Nix-Darwinの再適用**
問題なく表示されたら、再度Nix-Darwinを適用してください。
```bash
sudo darwin-rebuild switch --flake .#macbook
```

この手順でお試しいただけますでしょうか？
