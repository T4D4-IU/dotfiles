# macOS セットアップガイド

このガイドでは、macOSでこのdotfilesを使用する方法を説明します。Nixのパッケージ管理とHome Managerを使用することで、NixOS・WSLと同じシェル環境・開発ツールをmacOS上でも再現できます。

## 📋 前提条件

- macOS 12 Monterey以降（Apple Silicon / Intel Mac どちらも対応）
- インターネット接続
- Xcode Command Line Tools
- 基本的なターミナル操作の知識

## 🚀 セットアップ手順

### 1. Xcode Command Line Toolsのインストール

```bash
xcode-select --install
```

ダイアログが表示されたら「インストール」をクリックしてください。

### 2. Nixのインストール

#### 推奨: Determinate Systems版Nixインストーラー（Flakes対応、アンインストールも簡単）

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### または標準のNixインストーラー

```bash
sh <(curl -L https://nixos.org/nix/install)
```

インストール後、**新しいターミナルを開く**か、以下を実行してNixを有効化します:

```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

インストールを確認:

```bash
nix --version
```

### 3. Flakesの有効化

**Determinate Systems版を使用した場合はこの手順は不要です。**

標準インストーラーを使用した場合は、`~/.config/nix/nix.conf` を作成（存在しない場合）:

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF
```

### 4. リポジトリのクローン

```bash
git clone https://github.com/T4D4-IU/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 5. ユーザー名の設定（必要な場合）

デフォルトのユーザー名は `t4d4` です。異なるユーザー名の場合は以下を編集してください。

`lib/hosts.nix` を編集:

```nix
macbook = {
  system = "aarch64-darwin";  # Intel Macの場合は "x86_64-darwin" に変更
  hostname = "macbook";
  username = "your-username";        # 実際のmacOSユーザー名
  homeDirectory = "/Users/your-username";  # 実際のホームディレクトリ
  # ...
};
```

`flake.nix` の `homeConfigurations` のキーも合わせて変更:

```nix
"your-username@macbook" = helpers.mkHomeConfiguration { ... };
```

### 6. Home Managerの初回適用

```bash
# Home Managerをインストールして適用
nix run home-manager/master -- switch --flake ~/dotfiles#t4d4@macbook
```

> ⚠️ **注意**: ユーザー名を変更した場合は `t4d4@macbook` の部分を `your-username@macbook` に変更してください。

初回は時間がかかります（パッケージのダウンロードとビルド）。

### 7. 設定の再読み込み

```bash
# Zshを使用している場合
source ~/.zshrc

# または新しいターミナルを開く
```

### 8. Zshをデフォルトシェルに設定

Home Managerでインストールされたzshをデフォルトシェルとして設定します。

```bash
# Nixのzshをシステムのシェルリスト（/etc/shells）に追加
sudo sh -c "echo $(which zsh) >> /etc/shells"

# デフォルトシェルをzshに変更
chsh -s $(which zsh)
```

**ターミナルを完全に終了して再起動**してください。

```bash
# 確認
echo $SHELL
# /Users/username/.nix-profile/bin/zsh のような出力になるはず
```

### Intel Mac の場合

`lib/hosts.nix` でシステムアーキテクチャを変更してください:

```nix
macbook = {
  system = "x86_64-darwin";  # Intel Mac
  # ...
};
```

## 📝 日常の使用

### 設定の更新

設定ファイルを編集した後:

```bash
cd ~/dotfiles
home-manager switch --flake .#t4d4@macbook
```

### 依存関係の更新

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .#t4d4@macbook
```

## 🎯 macOS環境に含まれるもの

### シェル環境

- **Zsh** + Oh My Zsh
- **Starship** プロンプト
- **zoxide** - スマートなcd
- **各種エイリアス** と便利なショートカット

### CLI強化ツール

- `eza` - モダンなls
- `bat` - catの代替
- `fd` - findの代替
- `ripgrep` - grepの高速版
- `fzf` - ファジーファインダー
- `dust` - duの可視化版
- `duf` - dfの改良版
- `procs` - psの代替
- `bottom` - topの改良版
- `delta` - Git diff可視化
- `lazygit` - Git TUI
- `yazi` - ファイルマネージャー
- `tmux` / `zellij` - ターミナルマルチプレクサー

### 開発ツール

- **エディター**: Neovim (nix run経由)
- **Git**: git, GitHub CLI (gh)
- **direnv** - プロジェクト環境管理
- **言語**: Rust, Go, Python, Node.js, Deno, Bun
- **ビルドツール**: devbox, devenv

### GUIアプリ (macOS固有)

- **Brave** - ブラウザ
- **Discord** - チャット
- **Obsidian** - ノート管理
- **Raycast** - ランチャー
- **Spotify** - 音楽
- **Syncthing** - ファイル同期

## 🔧 カスタマイズ

### 追加パッケージのインストール

`hosts/macbook/home.nix` に追加:

```nix
{pkgs, ...}: {
  home.packages = with pkgs; [
    # 追加したいパッケージ
    htop
    curl
    wget
  ];
}
```

### macOS専用の設定追加

`modules/home/darwin/` に新しいモジュールを作成し、`default.nix` にインポートを追加します。

### GUIアプリの追加/削除

`modules/home/darwin/gui.nix` を編集してください。

## ⚠️ トラブルシューティング

### Nixがインストールできない

macOS 15 Sequoia以降でボリューム作成に問題が発生する場合があります。Determinate Systems版インストーラーを使用してください:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### zshをデフォルトシェルに設定できない

**エラー例:**
```
chsh: /Users/username/.nix-profile/bin/zsh はシェルに指定できません
```

**解決方法:**
```bash
# zshを/etc/shellsに登録
sudo sh -c "echo $(which zsh) >> /etc/shells"

# 再度chshを実行
chsh -s $(which zsh)
```

### ビルドエラー: platform not supported

一部のパッケージはLinux専用のため、macOSでビルドできない場合があります。

`development.nix` や `cli.nix` から問題のパッケージをコメントアウトするか、`hosts/macbook/home.nix` でオーバーライドしてください。

### ディスク容量不足

```bash
# 古いgenerationを削除
nix-collect-garbage -d

# ストレージ最適化
nix-store --optimise
```

### Home Managerのロールバック

```bash
# 世代を確認
home-manager generations

# ロールバック
home-manager switch --flake .#t4d4@macbook --rollback
```

### Flakeロックの問題

```bash
# flake.lockを再生成
cd ~/dotfiles
rm flake.lock
nix flake update
```

## 🔗 NixOS・WSLとの違い

macOS環境では以下が**含まれません**:

- ❌ NixOSシステム設定（`nixos-rebuild`は不要）
- ❌ Linuxカーネルモジュール（xremap等）
- ❌ Wayland/GTKツール（grimblast, hyprpaper等）
- ❌ Linux専用GUIアプリ（blueberry等）

代わりにmacOS固有のアプリ・設定が含まれます。

## 📚 参考リンク

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [nix-darwin (macOSシステム設定の管理)](https://github.com/LnL7/nix-darwin)

## 💡 ヒント

### nix-darwinの導入（上級者向け）

macOSのシステムレベルの設定（Dock、Finder、システムサービス等）も管理したい場合は、[nix-darwin](https://github.com/LnL7/nix-darwin)の導入を検討してください。

### Homebrewとの共存

NixとHomebrewは共存できます。Nixでは管理しにくいmacOS固有のアプリ（Karabiner-Elements等）はHomebrewで管理する方法もあります。

### Git設定

macOSでGit設定を行う:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH鍵の設定

```bash
# 新しいSSH鍵を生成
ssh-keygen -t ed25519 -C "your.email@example.com"

# SSH agentに追加
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 公開鍵をGitHubに追加
cat ~/.ssh/id_ed25519.pub
```

## 🎉 完了！

これでmacOS環境でもNixOSと同じシェル環境とCLIツールが使えます！
