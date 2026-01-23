[![Nix Check](https://github.com/T4D4-IU/dotfiles/actions/workflows/nix-check.yml/badge.svg)](https://github.com/T4D4-IU/dotfiles/actions/workflows/nix-check.yml)

# T4D4's NixOS Dotfiles

このリポジトリは、NixOS及びHome Managerを使用した、複数環境対応のシステム設定管理用dotfilesです。

## ✨ 特徴

- 🏠 **ホスト別設定管理**: 各マシンの設定を独立して管理
- 🔄 **クロスプラットフォーム対応**: Linux/macOS で共通設定を共有
- 📦 **モジュール化**: OS共通・OS固有の設定を明確に分離
- 🛠️ **ヘルパーライブラリ**: 新しいホストの追加が容易
- 🔒 **型安全**: Nix Flakesによる宣言的な設定管理
- 🐧 **WSL/Ubuntu対応**: 非NixOS環境でも同じ設定を使用可能

## 🚀 クイックスタート

### NixOS環境
詳細は[使用方法](#🚀-使用方法)セクションを参照

### WSL/Ubuntu環境
**[📘 WSLセットアップガイド](docs/WSL_SETUP.md)** を参照してください。

CLI専用のツールとシェル環境を簡単にセットアップできます。

## 📁 ディレクトリ構造

```
dotfiles/
├── flake.nix                      # Flakeエントリーポイント
├── flake.lock                     # 依存関係のロック
├── hosts/                         # ホスト別設定
│   ├── nixos/                     # NixOSデスクトップ
│   │   ├── default.nix            # ホスト設定エントリー
│   │   ├── configuration.nix      # NixOSシステム設定
│   │   ├── hardware-configuration.nix  # ハードウェア設定
│   │   └── home.nix               # このホスト用のHome Manager設定
│   └── wsl/                       # WSL環境
│       └── home.nix               # WSL用のHome Manager設定
├── modules/                       # 再利用可能なモジュール
│   └── home/                      # Home Managerモジュール
│       ├── common/                # OS共通設定
│       │   ├── default.nix        # 共通モジュール自動インポート
│       │   ├── cli.nix            # CLIツール
│       │   ├── development.nix    # 開発ツール全般（言語固有環境・補助ツール）
│       │   ├── direnv.nix         # direnv設定
│       │   ├── gh.nix             # GitHub CLI設定
│       │   ├── git.nix            # Git設定
│       │   ├── starship.nix       # プロンプト設定
│       │   ├── zoxide.nix         # zoxide設定
│       │   └── zsh.nix            # Zshシェル
│       ├── linux/                 # Linux固有設定
│       │   ├── default.nix        # Linuxモジュール自動インポート
│       │   ├── gui.nix            # GUIアプリケーション
│       │   └── zed.nix            # Zedエディター
│       └── darwin/                # macOS固有設定（将来用）
│           └── default.nix        # macOSモジュール自動インポート
├── lib/                           # ヘルパー関数
│   ├── default.nix                # ライブラリエントリー
│   ├── helpers.nix                # 設定生成ヘルパー
│   └── hosts.nix                  # ホスト定義
├── pkgs/                          # カスタムパッケージ
│   ├── default.nix                # パッケージエントリー
│   ├── dfx.nix                    # DFINITY SDK
│   └── haystack-editor.nix        # Haystackエディター
├── configuration.nix              # (後方互換用、非推奨)
├── hardware-configuration.nix     # (後方互換用、非推奨)
└── home.nix                       # (後方互換用、非推奨)
```

## 🖥️ 現在の設定

### ホスト: nixos (x86_64-linux)

**システムレベル (NixOS)**:
- **ユーザー**: `t4d4`
- **カーネル**: Linux Zen
- **ブートローダー**: systemd-boot
- **デスクトップ環境**: GNOME
- **ディスプレイマネージャー**: GDM
- **日本語環境**:
  - ロケール: ja_JP.UTF-8
  - インプットメソッド: fcitx5 + Mozc
  - フォント: Noto CJK、Nerd Fonts
- **ネットワーク**: Tailscale
- **仮想化**: Docker (rootless)
- **キーリマップ**: xremap (CapsLock→Ctrl, Ctrl+H→Backspace)

**ユーザーレベル (Home Manager)**:
- **シェル**: Zsh + Starship
- **エディター**: Neovim, Zed, Cursor
- **開発ツール**: Git, GitHub CLI, direnv
- **CLI強化**: eza, bat, fd, ripgrep, fzf, zoxide
- **GUIアプリ**: Brave, Discord, Obsidian, Slack等

### カスタムパッケージ
- **dfx**: DFINITY SDK (Internet Computer開発)
- **haystack-editor**: Haystackコードエディター

## 🧹 コード品質

このプロジェクトでは、Nixコードの品質を保つために以下のツールを使用：
- **alejandra**: コードフォーマッター
- **statix**: リンター（アンチパターン検出）
- **deadnix**: 未使用コード検出

詳細は **[📘 リンター・フォーマッター設定](docs/LINTING.md)** を参照。

### 開発環境

```bash
# 開発シェルに入る（pre-commitフックが自動設定される）
nix develop
```

Push時に自動でリンター/フォーマッターがチェックされます。

## 🚀 使用方法

### 初回セットアップ

1. **リポジトリのクローン**:
```bash
git clone https://github.com/T4D4-IU/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. **NixOSシステムの適用**:
```bash
sudo nixos-rebuild switch --flake .#nixos
```

3. **Home Managerの適用**:
```bash
home-manager switch --flake .#t4d4@nixos
```

### 日常の更新

**設定変更後の適用**:
```bash
# NixOSシステム設定の更新
sudo nixos-rebuild switch --flake .#nixos

# Home Manager設定の更新
home-manager switch --flake .#t4d4@nixos
```

**依存関係の更新**:
```bash
# flake.lockを更新
nix flake update

# 更新後に適用
sudo nixos-rebuild switch --flake .#nixos
home-manager switch --flake .#t4d4@nixos
```

### 設定の検証

```bash
# Flake全体の検証（注意: ビルドを実行するため時間がかかります）
nix flake check

# 構造の確認のみ
nix flake show

# 設定の評価のみ
nix eval .#nixosConfigurations.nixos.config.networking.hostName
nix eval .#homeConfigurations.\"t4d4@nixos\".config.home.username
```

## ➕ 新しいホストの追加方法

### 1. ホスト定義の追加

`lib/hosts.nix` に新しいホストを追加:

```nix
{
  # 既存のnixosホスト
  nixos = { ... };

  # 新しいホスト（例: MacBook）
  macbook = {
    system = "aarch64-darwin";
    hostname = "macbook";
    username = "t4d4";
    homeDirectory = "/Users/t4d4";

    features = {
      gui = true;
      development = true;
    };

    homeModules = [
      ../hosts/macbook/home.nix
    ];
  };
}
```

### 2. ホスト専用ディレクトリの作成

```bash
mkdir -p hosts/macbook
```

### 3. ホスト設定ファイルの作成

`hosts/macbook/home.nix`:
```nix
{ config, pkgs, ... }:

{
  home.username = "t4d4";
  home.homeDirectory = "/Users/t4d4";
  home.stateVersion = "24.11";

  imports = [
    ../../modules/home/common    # 共通設定
    ../../modules/home/darwin    # macOS専用設定
  ];

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
}
```

### 4. flake.nixに追加

`flake.nix` の `homeConfigurations` に追加:
```nix
homeConfigurations = {
  "t4d4@nixos" = helpers.mkHomeConfiguration {
    inherit inputs;
    system = hosts.nixos.system;
    username = hosts.nixos.username;
    homeDirectory = hosts.nixos.homeDirectory;
    modules = hosts.nixos.homeModules;
  };

  # 新しいホスト
  "t4d4@macbook" = helpers.mkHomeConfiguration {
    inherit inputs;
    system = hosts.macbook.system;
    username = hosts.macbook.username;
    homeDirectory = hosts.macbook.homeDirectory;
    modules = hosts.macbook.homeModules;
  };
};
```

### 5. 適用

```bash
home-manager switch --flake .#t4d4@macbook
```

## 🔧 トラブルシューティング

### ディスク容量不足

```bash
# 古いgenerationを削除
nix-collect-garbage -d

# システム全体のガベージコレクション (要root)
sudo nix-collect-garbage -d

# ストレージ最適化
sudo nix-store --optimise
```

### 設定エラーのデバッグ

```bash
# 詳細なエラー情報を表示
nix flake check --show-trace

# 特定の設定を評価
nix eval .#nixosConfigurations.nixos.config.system.build.toplevel --show-trace
```

### Home Managerの問題

```bash
# Home Managerの世代を確認
home-manager generations

# 前の世代にロールバック
home-manager switch --flake .#t4d4@nixos --rollback
```

## 📊 CI/CD

GitHub Actionsで以下を自動チェック:

### 🔍 主要なチェック
- ✅ **Flake設定の妥当性検証** - メタデータと構造の確認
- ✅ **カスタムパッケージのビルド** - dfx, haystack-editor
- ✅ **NixOSシステム設定の評価** - configuration.nixの検証
- ✅ **複数ホストのHome Manager設定** - nixos, wsl両方をテスト
- ✅ **モジュールの構文チェック** - 個別モジュールの独立性確認

### 🚀 CI/CDワークフロー

**Linux (ubuntu-latest)**:
- パッケージビルド（並列実行）
- NixOS設定のドライビルド
- Home Manager設定（nixos, wsl）のビルド
- モジュール構文チェック

**macOS (macos-latest)** ※将来対応時:
- Darwin固有モジュールの構文チェック
- macOS Home Manager設定のビルド

### 📈 最適化
- **Cachix統合**: ビルドキャッシュで高速化
- **並列実行**: 複数ジョブの同時実行
- **段階的チェック**: 軽量チェックから重いビルドへ

## 📚 参考資料

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [複数環境対応の参考記事](https://zenn.dev/trifolium/articles/b3d88bbabcad2c)

## 📝 ライセンス

MIT License

## 🙏 謝辞

このdotfilesは、以下の記事を参考に複数環境対応を実装しました:
- [Zenn: NixとHome Managerで複数環境のdotfilesを管理する](https://zenn.dev/trifolium/articles/b3d88bbabcad2c)
