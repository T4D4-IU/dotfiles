# CI Optimization Report: ci_optimization_report.md

## 概要とご指摘への回答
ユーザー様のご指摘の通り、**Mac用のHome-manager CIに高コストで低速な macOS ランナー（`macos-latest`）を毎回使用し、実際にフルビルド（10分以上）を実行することは非常に非効率的かつ高コストです。**

### 現状の分析
- **MacとLinuxのHome-managerの違い**: `hosts/macbook/home.nix` (Karabiner等のmacOS特有設定) と `hosts/nixos/home.nix` (Linux特有設定) があるため、モジュール構成には違いがあります。そのため、macOS用設定の「エラーチェック」自体は必要です。
- **フルビルドの必要性**: CIで検出したい主な問題は「Nixコードの記述ミス、タイポ、無限再帰、未定義オプション」です。これらは、実際にパッケージをコンパイルする「ビルド（`nix build`）」を行わなくても、**「評価（`nix eval`）」を実行するだけで100%検出可能**です。
- **Linuxでの評価の可能性**: Nixの強力な特性として、**Linuxランナー（`ubuntu-latest`）上であっても、macOS向けの設定（`t4d4@macbook`）の評価チェック (`nix eval`) は完全に実行可能**です。

### 結論
高額で時間のかかる macOS ランナーを完全に廃止し、**安価で高速な Linux ランナー（`ubuntu-latest`）上で macOS 用設定の評価（評価にかかる時間はわずか数秒〜十数秒）を行うようにCIを統合・最適化**します。

---

## 修正計画

### 1. 高コストな macOS 専用CIファイルを削除
- `.github/workflows/macos-check.yml` を完全に削除（廃止）します。

### 2. Linux 用の Nix CI に macOS 評価を統合 (`.github/workflows/nix-check.yml`)
- **構文チェック**: `module-check` ジョブのマトリックスに `darwin` を追加し、Linux 上で `modules/home/darwin/*.nix` の構文チェックを行います。
- **評価チェック**: 新しく `macos-hm-eval` ジョブを `nix-check.yml` に追加し、Linux 上で macOS 用 Home Manager 構成 (`t4d4@macbook`) を評価 (`nix eval`) します。
  ```yaml
  macos-hm-eval:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: webfactory/ssh-agent@v0.8.0
        with:
          ssh-private-key: ${{ secrets.DOTFILES_SECRETS_DEPLOY_KEY }}
      - uses: cachix/install-nix-action@v30
        with:
          nix_path: nixpkgs=channel:nixos-unstable
      - name: Evaluate macOS Home Manager config
        run: |
          nix eval .#homeConfigurations.\"t4d4@macbook\".config.home.username
  ```

---

## 完了定義 (DoD)
- [ ] `.github/workflows/macos-check.yml` がリポジトリから削除されていること。
- [ ] `.github/workflows/nix-check.yml` が更新され、Linux上で macOS モジュールの構文チェックおよび macOS Home Manager の評価が実行されること。
- [ ] ローカルで `nix eval .#homeConfigurations.\"t4d4@macbook\".config.home.username` がエラーなく評価できることを検証し、CI側でも確実に動作する状態になっていること。

---
この極めて効率的でコスト削減につながる最適化計画で進めてよろしいでしょうか？
承認（Goなど）をいただけましたら、修正とファイル削除を実施し、PR #45 に反映いたします！
