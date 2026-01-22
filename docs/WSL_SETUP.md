# WSL/Ubuntu セットアップガイド

このガイドでは、WSL（Windows Subsystem for Linux）やUbuntuなどの非NixOS環境でこのdotfilesを使用する方法を説明します。

## 📋 前提条件

- WSL2またはLinuxディストリビューション（Ubuntu推奨）
- インターネット接続
- sudo権限を持つユーザーアカウント
- 基本的なLinuxコマンドの知識

## 🚀 セットアップ手順

### 1. Nixのインストール

#### 推奨: Determinate Systems版Nixインストーラー
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

#### または標準のNixインストーラー
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

インストール後、新しいシェルを開くか、以下を実行:
```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### 2. Flakesの有効化

`~/.config/nix/nix.conf` を作成（存在しない場合）:
```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << 'EOF'
experimental-features = nix-command flakes
EOF
```

### 3. リポジトリのクローン

```bash
git clone https://github.com/T4D4-IU/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 4. ユーザー名の設定

`hosts/wsl/home.nix` を編集して、自分のユーザー名に変更:
```nix
home.username = "your-username";  # 実際のWSLユーザー名
home.homeDirectory = "/home/your-username";  # 実際のパス
```

`lib/hosts.nix` も同様に変更:
```nix
wsl = {
  # ...
  username = "your-username";
  homeDirectory = "/home/your-username";
  # ...
};
```

### 5. Home Managerの初回適用

```bash
# Home Managerをビルドして適用
# ⚠️ 注意: ユーザー名が t4d4 以外の場合、flake.nix の homeConfigurations を修正する必要があります
nix run home-manager/master -- switch --flake ~/dotfiles#t4d4@wsl
```

**ユーザー名をカスタマイズする場合:**
1. `flake.nix` の `homeConfigurations` セクション（103-111行目付近）を編集
2. `"t4d4@wsl"` を `"your-username@wsl"` に変更
3. または `lib/hosts.nix` でユーザー名を設定し、動的生成に変更することも可能

初回は時間がかかる場合があります（パッケージのダウンロードとビルド）。

### 6. 設定の再読み込み

```bash
# Zshを使用している場合
source ~/.zshrc

# または新しいシェルを開く
exec $SHELL
```

### 7. Zshをデフォルトシェルに設定

Home Managerでzshをインストールした後、ログインシェルとして設定する必要があります。

#### Nixでインストールしたzshを/etc/shellsに登録

```bash
# zshのパスを確認
which zsh

# /etc/shellsに追加（sudoが必要）
sudo bash -c "echo $(which zsh) >> /etc/shells"

# 登録されたことを確認
cat /etc/shells
```

#### デフォルトシェルを変更

```bash
# chshコマンドでzshをデフォルトに設定
chsh -s $(which zsh)
```

パスワードを入力後、**SSH接続を完全に切断して再接続**してください。

```bash
# 再接続後、シェルを確認
echo $SHELL
# /home/username/.nix-profile/bin/zsh または /nix/store/.../bin/zsh のような出力になるはず

# 起動中のシェルを確認
ps -p $$
# zsh と表示されるはず
```

## 📝 日常の使用

### 設定の更新

設定ファイルを編集した後:
```bash
cd ~/dotfiles
home-manager switch --flake .#your-username@wsl
```

### 依存関係の更新

```bash
cd ~/dotfiles
nix flake update
home-manager switch --flake .#your-username@wsl
```

## 🎯 WSL環境に含まれるもの

### シェル環境
- **Zsh** + oh-my-zsh
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
- `tmux` - ターミナルマルチプレクサー

### 開発ツール
- **エディター**: Neovim, Zed, Cursor
- **Git**: git, GitHub CLI (gh)
- **direnv** - プロジェクト環境管理
- **言語**: Rust, Go, Python, Node.js, Deno, Bun
- **データベース**: PostgreSQL, SQLite
- **WebAssembly**: Wasmtime, Wasmer

### 開発支援
- `gibo` - .gitignore生成
- `atuin` - シェル履歴管理
- `zellij` - ターミナルマルチプレクサー

## 🔧 カスタマイズ

### 追加パッケージのインストール

`hosts/wsl/home.nix` に追加:
```nix
{
  home.packages = with pkgs; [
    # 追加したいパッケージ
    htop
    curl
    wget
  ];
}
```

### モジュールの追加/削除

不要なモジュールをコメントアウト:
```nix
imports = [
  ../../modules/home/common
  # ../../modules/home/common/development.nix  # 開発ツールが不要な場合
];
```

## ⚠️ トラブルシューティング

### zshをデフォルトシェルに設定できない

**エラー例:**
```
chsh: /home/username/.nix-profile/bin/zsh はシェルに指定できません
```

**原因:** Nixでインストールしたzshが `/etc/shells` に登録されていない

**解決方法:**
```bash
# zshを/etc/shellsに登録
sudo bash -c "echo $(which zsh) >> /etc/shells"

# 再度chshを実行
chsh -s $(which zsh)

# SSH接続を切断して再接続
exit
# 再接続後、echo $SHELL でzshが表示されることを確認
```

**代替方法（chshが使えない環境の場合）:**

`hosts/wsl/home.nix` に以下を追加して、bash起動時に自動的にzshに切り替える：

```nix
programs.bash = {
  enable = true;
  initExtra = ''
    # Auto-start zsh if not already in zsh
    if [ -z "$ZSH_VERSION" ] && command -v zsh &> /dev/null; then
      exec zsh
    fi
  '';
};
```

その後、Home Managerを再適用：
```bash
cd ~/dotfiles
home-manager switch --flake .#your-username@wsl
```

### ディスク容量不足

```bash
# 古いgenerationを削除
nix-collect-garbage -d

# ストレージ最適化
nix-store --optimise
```

### パーミッションエラー

```bash
# Nixデーモンの再起動
sudo systemctl restart nix-daemon
```

### Flakeロックの問題

```bash
# flake.lockを再生成
cd ~/dotfiles
rm flake.lock
nix flake update
```

### Home Managerのロールバック

```bash
# 世代を確認
home-manager generations

# ロールバック
home-manager switch --flake .#your-username@wsl --rollback
```

## 🔗 GUI版との違い

WSL環境では以下が**含まれません**:
- ❌ GUIアプリケーション（Brave, Discord等）
- ❌ Waylandツール
- ❌ デスクトップ環境固有の設定

CLI専用ツールとシェル環境のみが提供されます。

## 📚 参考リンク

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)

## 💡 ヒント

### WSLでのVSCode統合

WSL内にRemote-WSL拡張を使用してVSCodeから接続できます:
```bash
code .
```

### Git設定

WSL内でGit設定を行う:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### SSH鍵の共有

Windows側のSSH鍵をWSLで使用する場合:
```bash
ln -s /mnt/c/Users/YourWindowsUser/.ssh ~/.ssh
chmod 600 ~/.ssh/*
```

## 🎉 完了！

これでWSL/Ubuntu環境でもNixOSと同じシェル環境とCLIツールが使えます！
