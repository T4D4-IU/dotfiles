# Home Manager モジュール

このディレクトリには、Home Managerで管理されるユーザー環境設定のモジュールが格納されています。

## 📂 ディレクトリ構造

```
modules/home/
├── common/           # OS共通設定（すべての環境で使用）
├── linux/            # Linux固有設定
└── darwin/           # macOS固有設定（将来用）
```

## 🌍 OS共通モジュール (common/)

すべてのプラットフォームで共有される設定。

### cli.nix
**CLIツールとユーティリティ**

インストールされるツール:
- `eza` - モダンなlsコマンド
- `bat` - catコマンドの代替（シンタックスハイライト付き）
- `fd` - findコマンドの代替
- `ripgrep` - grepの高速代替
- `fzf` - ファジーファインダー
- `zoxide` - スマートなcdコマンド
- `dust` - duコマンドの可視化版
- `duf` - dfコマンドの改良版
- `procs` - psコマンドの代替
- `bottom` - topコマンドの改良版
- `delta` - Git diffの可視化
- `lazygit` - Git TUI
- `yazi` - ターミナルファイルマネージャー
- `tmux` - ターミナルマルチプレクサー
- その他多数

### dev.nix
**開発補助ツール**

- `marp-cli` - Markdownプレゼンテーション作成
- `textlint` - テキストリンター
- `zizmor` - GitHub Actions静的解析ツール
- `valgrind` - メモリリーク検出
- `act` - GitHub Actionsローカル実行
- `pinact` - GitHub Actionsバージョン固定ツール
- `actionlint` - GitHub Actionsワークフローチェッカー

### development.nix
**言語固有の開発環境**

サポート言語:
- **Rust**: rust-bin (stable/nightly対応)
- **Go**: go_1_23
- **Python**: python3, pip, uv
- **Node.js**: nodejs_23
- **Deno**: deno
- **Bun**: bun
- **WebAssembly**: wasmtime, wasmer
- **データベース**: postgresql, sqlite

### direnv.nix
**direnv設定**

プロジェクトごとの環境変数とツールの自動ロード。

### starship.nix
**Starshipプロンプト設定**

カスタマイズされたシェルプロンプト。Nerd Fonts必須。

### zed.nix
**Zedエディター設定**

- テーマ: One Dark
- UI設定: コンパクトモード、タブバー
- Vim モード有効化
- 各言語のLSP設定

### zsh.nix
**Zshシェル設定**

- oh-my-zsh統合
- 各種プラグイン
- エイリアス設定
- カスタムショートカット

## 🐧 Linux固有モジュール (linux/)

Linux環境専用の設定。

### gui.nix
**GUIアプリケーション**

インストールされるアプリ:
- **ブラウザ**: Brave
- **コミュニケーション**: Discord, Slack, Telegram, Zulip
- **生産性**: Obsidian, Anki
- **メディア**: Spotify
- **同期**: Syncthing
- **ネットワーク**: Wireshark
- **システム**: NetworkManager Applet, Blueberry (Bluetooth)

## 🍎 macOS固有モジュール (darwin/)

将来のmacOS対応用。現在は空。

## 🔧 使用方法

### ホスト設定で使用する

`hosts/<hostname>/home.nix` で必要なモジュールをインポート:

```nix
{
  imports = [
    ../../modules/home/common    # 共通設定
    ../../modules/home/linux     # Linux専用（Linuxホストのみ）
    # ../../modules/home/darwin  # macOS専用（macOSホストのみ）
  ];
}
```

### 個別モジュールのカスタマイズ

各モジュールは独立しているため、必要に応じて個別にカスタマイズ可能:

```nix
{
  imports = [
    ../../modules/home/common/cli.nix
    ../../modules/home/common/zsh.nix
    # 他のモジュールは除外
  ];

  # モジュール設定を上書き
  programs.zsh.shellAliases = {
    myalias = "echo 'custom'";
  };
}
```

## 📝 新しいモジュールの追加

1. **適切なディレクトリに配置**:
   - OS共通 → `common/`
   - Linux専用 → `linux/`
   - macOS専用 → `darwin/`

2. **モジュールファイルを作成**:
```nix
{ config, pkgs, lib, ... }:

{
  # あなたの設定
  programs.myapp = {
    enable = true;
    # ...
  };
}
```

3. **default.nixに追加** (自動インポートする場合):
```nix
{
  imports = [
    ./cli.nix
    ./myapp.nix  # 追加
  ];
}
```

## 🎯 ベストプラクティス

1. **モジュールは単一責任**: 1つのモジュールは1つの機能/ツールに集中
2. **依存関係を明確に**: 必要なパッケージは同じモジュール内で定義
3. **OS固有の設定は分離**: 条件分岐ではなく、ディレクトリで分離
4. **コメントを書く**: 特殊な設定には理由を記載

## 🔗 参考リンク

- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [NixOS Packages Search](https://search.nixos.org/packages)
