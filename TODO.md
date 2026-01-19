# TODO: 複数環境対応へのリファクタリング

参考: https://zenn.dev/trifolium/articles/b3d88bbabcad2c

## 🎯 目標

このdotfilesを複数のマシン・環境（NixOS、WSL等）で使用できるように再構築する。

**記事の要点:**
- Nix Flakesを使った宣言型の環境管理
- Home Managerでユーザー環境（dotfiles + ツール）を統一管理
- OS・アーキテクチャ（x86_64-linux, aarch64-darwin等）の差異を吸収
- 共通設定と環境固有設定を分離して管理

---

## 📋 実装タスク

### Phase 1: ディレクトリ構造の再編成

- [x] **1-1. Home Manager中心の構造にリファクタリング**
  - [x] 現在の構成を確認（NixOS設定とHome Manager設定が混在）
  - [x] Home Managerをメインに、NixOS設定は補助的に扱う方針を決定
  - [x] ユーザー名の不一致（`asaki` vs `t4d4`）を解決 → `t4d4`に統一

- [x] **1-2. ホスト別設定の分離**
  - [x] `hosts/` ディレクトリを作成
  - [x] 各ホストごとに `hosts/<hostname>/` を作成
    - [x] `hosts/nixos/` （既存のNixOSデスクトップ）
      - [x] `default.nix` - ホスト固有の設定エントリーポイント
      - [x] `configuration.nix` - NixOSシステム設定（システムレベル）
      - [x] `hardware-configuration.nix` - ハードウェア設定
      - [x] `home.nix` - このホスト用のHome Manager設定
    - [x] 将来的に他のホスト（Mac、WSL等）を追加しやすい構造に
  - [x] 共通設定を分離する仕組みを導入

- [x] **1-3. Home Managerモジュールの整理**
  - [x] `modules/home/` ディレクトリを作成（記事の構成に準拠）
  - [x] 既存の `home-manager/` の内容を `modules/home/` に移動・整理
  - [x] OS共通設定とOS固有設定を分離
    - [x] `modules/home/common/` - すべてのOSで共通の設定
    - [x] `modules/home/linux/` - Linux固有の設定（Hyprland等）
    - [x] `modules/home/darwin/` - macOS固有の設定（将来用、ディレクトリ作成済み）
  - [ ] 各モジュールを条件分岐で有効/無効にできるようにする（Phase 4で実施）

- [ ] **1-4. NixOSモジュールの整理（オプショナル）**
  - [ ] `modules/nixos/` ディレクトリを作成
  - [ ] システムレベルの設定を分離
    - [ ] デスクトップ環境（GNOME, Hyprland）
    - [ ] 日本語環境設定
    - [ ] 開発環境（Docker等）
    - [ ] ネットワーク設定（Tailscale）
  - [ ] NixOS以外の環境では使用されないことを明示

### Phase 2: Flake設定の改善

- [x] **2-1. flake.nix の再構築（記事の手法を参考に）**
  - [x] ホストごとの `homeConfigurations` を定義
    - [x] `username@hostname` 形式で識別（例: `t4d4@nixos`）
    - [x] 各ホストで異なるアーキテクチャを明示的に指定
      - `x86_64-linux` - Linux（NixOS、WSL）
      - `aarch64-darwin` - Apple Silicon Mac（将来用）
      - `x86_64-darwin` - Intel Mac（将来用）
  - [x] NixOS設定は `nixosConfigurations` に分離
    - [x] `hosts/nixos/default.nix`をエントリーポイントとして使用
  - [x] rust-overlay を追加（development.nixの依存関係）
  - [ ] ホスト追加時の手順を簡略化（ドキュメント化が必要）

- [ ] **2-2. 共通設定の抽出とヘルパー関数の作成**
  - [x] `lib/` ディレクトリを作成
  - [ ] ホスト情報を定義する共通フォーマットを作成
  - [ ] OS判定やアーキテクチャ判定のヘルパー関数を実装
  - [ ] 記事のように `pkgs.stdenv.isDarwin` 等を活用した条件分岐

- [ ] **2-3. 設定ファイルの配置方法を統一**
  - [ ] `home.file` を使ってdotfilesを配置
  - [ ] リポジトリ内のファイルを `~/.config/` 等にシンボリックリンク
  - [ ] Git管理されている設定ファイルを明示的に指定

### Phase 3: ユーザー名・設定の統一

- [x] **3-1. ユーザー名の不一致を解決**
  - [x] `asaki` と `t4d4` のどちらをメインユーザーにするか決定
    - **決定**: すべて `t4d4` に統一（案A採用）
  - [x] 方針を決定:
    - 案A: すべて `t4d4` に統一 ← **採用**
    - ~~案B: ホストごとに異なるユーザー名を使用~~
  - [x] NixOS設定とHome Manager設定のユーザー名を整合させる
    - [x] xremap userName: `asaki` → `t4d4`
    - [x] users.users定義: `asaki` → `t4d4`
    - [x] hyprlock壁紙パス修正: `/home/asaki/` → `/home/t4d4/`
    - [x] root home.nix更新: `asaki` → `t4d4`

- [x] **3-2. Home Manager設定の統合**
  - [x] ルートの `home.nix`（最小構成）の役割を確認 → 後方互換性用
  - [x] `home-manager/home.nix`（詳細構成）をメインにする
  - [x] ホストごとの `hosts/<hostname>/home.nix` に統合
  - [x] 共通設定は `modules/home/common/` に抽出
  - [x] ホスト固有の設定は `hosts/<hostname>/home.nix` に記述

- [ ] **3-3. パッケージ管理の方針統一**
  - [ ] `home.packages` でユーザー環境のツールをインストール
  - [ ] `environment.systemPackages` はシステム全体で必要なもののみに限定
  - [ ] GUI/CLIツールの配置場所を整理

### Phase 4: OS・環境別の柔軟性向上（記事の核心部分）

- [ ] **4-1. OS判定による条件分岐の実装**
  - [ ] `pkgs.stdenv.isDarwin` でmacOS判定
  - [ ] `pkgs.stdenv.isLinux` でLinux判定
  - [ ] ホスト名やユーザー名による分岐も実装
  - [ ] 記事のサンプルコードを参考に実装

- [ ] **4-2. アーキテクチャ別のパッケージ指定**
  - [ ] `x86_64-linux` 用のパッケージセット
  - [ ] `aarch64-darwin` 用のパッケージセット（Apple Silicon Mac用）
  - [ ] アーキテクチャ非依存の共通パッケージ

- [ ] **4-3. 機能別モジュールのトグル化**
  - [ ] GUI環境（Hyprland、Rofi等）の有効/無効
  - [ ] CUIのみの環境（WSL、サーバー等）をサポート
  - [ ] 開発ツールセットの選択（言語別、プロジェクト別）
  - [ ] 各ホストの `home.nix` でインポートするモジュールを選択

- [ ] **4-4. dotfilesの配置の柔軟化**
  - [ ] OS別の設定ファイルパスに対応
    - Linux: `~/.config/`
    - macOS: `~/.config/` または `~/Library/Application Support/`
  - [ ] `home.file` と `xdg.configFile` の使い分け

### Phase 5: ドキュメント整備

- [ ] **5-1. README.md の更新**
  - [ ] 記事の内容を踏まえた導入手順を記載
  - [ ] 新しいディレクトリ構造を反映
  - [ ] ホストの追加方法を具体的に記載
    - `flake.nix` への追加方法
    - `hosts/<new-host>/` の作成手順
  - [ ] 環境別のコマンド例を記載
    - NixOS: `sudo nixos-rebuild switch --flake .#nixos`
    - Home Manager: `home-manager switch --flake .#t4d4@nixos`
    - macOS用: `nix run home-manager/master -- switch --flake .#user@macbook`
  - [ ] トラブルシューティングを追加

- [ ] **5-2. 各モジュールのドキュメント作成**
  - [ ] `modules/home/README.md` を作成
  - [ ] 各モジュールの目的と有効化方法を説明
  - [ ] OS別の利用可能性を明記
  - [ ] 設定例とカスタマイズ方法を記載

- [ ] **5-3. 新規環境セットアップガイド**
  - [ ] 初回セットアップ手順を記載
  - [ ] Nixのインストール（Determinate Systems版の推奨）
  - [ ] リポジトリのクローンと初回適用
  - [ ] 環境変数や認証情報の設定方法

### Phase 6: テスト・検証

- [ ] **6-1. CI/CDの更新**
  - [ ] 複数ホスト構成のビルドテスト
  - [ ] 複数ユーザー構成のテスト
  - [ ] 各モジュールの独立性テスト

- [ ] **6-2. 実環境での検証**
  - [ ] 現在の環境で正常に動作するか確認
  - [ ] 別のマシンでの動作確認（可能であれば）

---

## 🗂️ 最終的なディレクトリ構造（目標）

記事の構成とNixOSサポートを両立させた構造:

```
dotfiles/
├── flake.nix                      # エントリーポイント（複数ホスト対応）
├── flake.lock
├── README.md
├── TODO.md
├── lib/                           # ヘルパー関数・共通ユーティリティ
│   ├── default.nix
│   └── helpers.nix                # OS判定、ホスト設定生成等
├── modules/
│   ├── home/                      # Home Managerモジュール（クロスプラットフォーム）
│   │   ├── common/                # OS共通設定
│   │   │   ├── cli.nix            # CLI基本ツール（git, vim, zsh等）
│   │   │   ├── dev.nix            # 開発ツール
│   │   │   ├── editors/
│   │   │   │   ├── neovim.nix
│   │   │   │   └── zed.nix
│   │   │   └── shells/
│   │   │       ├── zsh.nix
│   │   │       └── starship.nix
│   │   ├── linux/                 # Linux固有設定
│   │   │   ├── gui.nix            # GUIアプリ
│   │   │   ├── hyprland.nix       # Hyprland WM
│   │   │   ├── hyprlock.nix
│   │   │   └── rofi.nix
│   │   └── darwin/                # macOS固有設定（将来用）
│   │       └── gui.nix
│   └── nixos/                     # NixOSシステムモジュール
│       ├── desktop/
│       │   ├── gnome.nix
│       │   └── hyprland.nix
│       ├── i18n/
│       │   └── japanese.nix
│       ├── development/
│       │   ├── docker.nix
│       │   └── common.nix
│       └── networking/
│           └── tailscale.nix
├── hosts/                         # ホスト別設定
│   ├── nixos/                     # NixOSデスクトップ
│   │   ├── default.nix            # ホスト設定のエントリーポイント
│   │   ├── configuration.nix      # NixOSシステム設定
│   │   ├── hardware-configuration.nix
│   │   └── home.nix               # このホスト用のHome Manager設定
│   ├── wsl/                       # WSL環境（将来用）
│   │   ├── default.nix
│   │   └── home.nix               # NixOS設定なし、Home Managerのみ
│   └── macbook/                   # macOS環境（将来用）
│       ├── default.nix
│       └── home.nix
├── pkgs/                          # カスタムパッケージ
│   ├── default.nix
│   ├── dfx.nix
│   └── haystack-editor.nix
└── dotfiles/                      # 実際の設定ファイル（オプション）
    ├── .gitconfig
    ├── .zshrc
    └── config/
        └── ...
```

---

## 🔄 移行手順の推奨順序

1. **Phase 1 → Phase 2**: まず構造を整える
2. **Phase 3**: 設定の整合性を確保
3. **Phase 4**: 柔軟性を追加
4. **Phase 5**: ドキュメント化
5. **Phase 6**: テストと検証

各Phaseは段階的にコミットし、動作確認しながら進めることを推奨。

---

## ⚠️ 注意事項

- リファクタリング中は必ずバックアップを取る
- 各変更後に `nix flake check` でエラーがないか確認
- 可能であればVMやコンテナで先に動作確認
- Git履歴を保持しながら段階的に進める

---

## 📝 メモ・検討事項

- [ ] xremapの設定をホスト固有にするか共通にするか検討
  - Linux固有の設定なので `modules/home/linux/` に配置
- [ ] カスタムパッケージ（dfx, haystack-editor）の配置場所を検討
  - `pkgs/` に維持、OS別のビルド対応が必要か確認
- [ ] Secrets管理（sops-nix、agenix等）の導入を検討
  - APIキー、SSH鍵、認証トークンの安全な管理
- [ ] Nixpkgsのバージョン管理戦略
  - 現在: `nixos-unstable`
  - 安定性重視なら `nixos-24.11` 等のstableブランチも検討
- [ ] Home Managerのスタンドアロン使用
  - NixOS以外（Mac、WSL）では必須
  - 記事ではスタンドアロン使用が前提
- [ ] Determinate Systems版Nixインストーラーの採用
  - 記事で推奨されているより簡単で高速なインストーラー
  - 標準のインストーラーとの違いを確認
- [ ] 環境ごとの適用コマンドを統一
  - `justfile` や `Makefile` でラッパーを作成？
  - `nix run .#apply-<hostname>` のような統一インターフェース
- [ ] CI/CDでの複数環境ビルドテスト
  - GitHub Actions で Linux/macOS 両方をテスト
  - `nix flake check` で全ホストを検証

---

## 📊 進捗サマリー

### ✅ 完了したフェーズ

#### Phase 1: ディレクトリ構造の再編成 (完了)
- ホスト別設定: `hosts/nixos/` を作成し、NixOS設定を配置
- Home Managerモジュール: `modules/home/{common,linux}` に整理
- flake.nix: 新構造を反映、rust-overlay追加
- 非推奨オプションの修正（GNOME、GDM、fonts）

#### Phase 2-1: flake.nix の再構築 (部分完了)
- `homeConfigurations` を `t4d4@nixos` 形式で定義
- `nixosConfigurations` を `hosts/nixos/` から読み込み
- アーキテクチャ指定: `x86_64-linux`

#### Phase 3: ユーザー名・設定の統一 (完了)
- すべての設定を `t4d4` に統一
- xremap、NixOSユーザー定義、Home Manager、hyprlockパス全て修正

### 🚧 次のステップ

1. **Phase 1-4**: NixOSモジュールの整理（オプション）
2. **Phase 2-2**: ヘルパー関数の作成（lib/）
3. **Phase 4**: OS・環境別の柔軟性向上（条件分岐の実装）
4. **Phase 5**: ドキュメント整備（README更新）
5. **Phase 6**: テスト・検証

### 📝 コミット履歴

- `1109677`: Phase 1: Restructure to host-based configuration
- `faad3f8`: Phase 3-1: Unify username to t4d4
