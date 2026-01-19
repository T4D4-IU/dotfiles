[![Nix Check](https://github.com/T4D4-IU/dotfiles/actions/workflows/nix-check.yml/badge.svg)](https://github.com/T4D4-IU/dotfiles/actions/workflows/nix-check.yml)

# T4D4's NixOS Dotfiles

このリポジトリは、NixOS及びHome Managerを使用したシステム設定管理用のdotfilesです。

## 📁 ディレクトリ構造

```
dotfiles/
├── flake.nix                      # Flakeのエントリーポイント
├── configuration.nix              # NixOSシステム設定（システムレベル）
├── home.nix                       # Home Manager設定（ルート用）
├── hardware-configuration.nix     # ハードウェア固有の設定
├── home-manager/                  # Home Manager モジュール群
│   ├── home.nix                   # メインのHome Manager設定
│   ├── cli.nix                    # CLIツール設定
│   ├── dev.nix                    # 開発環境設定
│   ├── development.nix            # 開発ツール設定
│   ├── direnv.nix                 # direnv設定
│   ├── gui.nix                    # GUI関連設定
│   ├── hyprland.nix               # Hyprland設定
│   ├── hyprlock.nix               # Hyprlockスクリーンロック設定
│   ├── rofi.nix                   # Rofiランチャー設定
│   ├── security.nix               # セキュリティ関連設定
│   ├── starship.nix               # Starshipプロンプト設定
│   ├── zed.nix                    # Zedエディター設定
│   └── zsh.nix                    # Zsh設定
└── pkgs/                          # カスタムパッケージ定義
    ├── default.nix                # パッケージセット
    ├── dfx.nix                    # DFINITY SDK
    └── haystack-editor.nix        # Haystackエディター
```

## 🖥️ 現在の構成状況

### システムレベル設定 (configuration.nix)

- **カーネル**: Linux Zen
- **ブートローダー**: systemd-boot
- **デスクトップ環境**: GNOME + Hyprland
- **ディスプレイマネージャー**: GDM
- **日本語環境**: 
  - ロケール: ja_JP.UTF-8
  - インプットメソッド: fcitx5 + Mozc
  - フォント: Noto CJK、Nerd Fonts (Hack, JetBrains Mono)
- **ネットワーク**: Tailscale有効化
- **仮想化**: Docker (rootless mode)
- **キーリマップ**: xremap (CapsLock → Ctrl, Ctrl+H → Backspace)
- **その他**: Flatpak有効化

### ユーザーレベル設定 (Home Manager)

**対象ユーザー**: 
- システム設定: `asaki` (configuration.nix)
- Home Manager: `t4d4` (home-manager/home.nix)

**主要ツール**:
- シェル: Zsh + Starship
- エディター: Neovim, Zed
- 開発ツール: Git, GitHub CLI (gh) + 拡張機能
- ディレクトリ移動: zoxide
- ウィンドウマネージャー: Hyprland
- ランチャー: Rofi

### カスタムパッケージ

- **dfx**: DFINITY SDK（Internet Computerの開発ツール）
- **haystack-editor**: Haystackコードエディター

## 🔧 現在の課題・改善点

### 1. ユーザー名の不一致
- NixOSシステム: `asaki`
- Home Managerメイン: `t4d4`
- Home Managerルート: `asaki`

→ 複数環境対応のため、ユーザー名を統一するか、環境変数化する必要があります。

### 2. システム固有の設定がハードコード
- ホスト名: `nixos` (固定)
- システムアーキテクチャ: `x86_64-linux` (固定)

→ 複数マシンで使用する場合、ホスト名やアーキテクチャを柔軟に切り替える仕組みが必要です。

### 3. Home Managerの二重設定
- ルートの `home.nix` (最小構成)
- `home-manager/home.nix` (詳細な構成)

→ どちらを使うのか明確にする必要があります。

## 📝 今後の改善方針

参考記事: https://zenn.dev/trifolium/articles/b3d88bbabcad2c

### 複数環境対応のために実装すべきこと

1. **ホスト別設定の分離**
   - `hosts/` ディレクトリを作成し、ホストごとの設定を管理
   - 共通設定とホスト固有設定を分離

2. **ユーザー設定の柔軟化**
   - ユーザー名を環境変数や引数で切り替え可能にする
   - `users/` ディレクトリでユーザー別設定を管理

3. **モジュール化の推進**
   - システム設定をより細かいモジュールに分割
   - 共通モジュールとホスト固有モジュールの明確化

4. **設定の統一**
   - Home Managerの設定場所を統一
   - ユーザー名の不整合を解消

## 🚀 使用方法

### NixOSシステムのビルド
```bash
sudo nixos-rebuild switch --flake .#nixos
```

### Home Managerの適用
```bash
home-manager switch --flake .#t4d4@nixos
```

### 設定チェック
```bash
nix flake check
```

## 📊 CI/CD

GitHub Actionsで以下を自動チェック:
- Flake設定の妥当性検証
- カスタムパッケージのビルド確認
- NixOSシステム設定の評価
- Home Manager設定の評価
