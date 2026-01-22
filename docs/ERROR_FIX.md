# ERROR_FIX.md - Nix Dotfiles Maintenance Guide

このドキュメントは、このNix Dotfilesリポジトリにおいて `nix flake check` やビルドエラーが発生した際に、AIエージェントが自律的に修正を行うための指針です。

## 1. 基本ワークフロー

エラー修正は以下の優先順位で実行すること。

1.  **依存関係の更新**: `deprecated` 警告や整合性エラーが出た場合、まずは `nix flake update` を試行する。
2.  **自動フォーマット**: Alejandraによる整形を行う。
3.  **Lintエラー修正 (Deadnix/Statix)**: 未使用変数や構文の最適化を行う（※後述の注意点を厳守）。
4.  **ビルド検証**: 修正後は必ずビルドテストを行う（チェックのみでなく構築テスト）。

## 2. 過去に発生したエラーと対応

### A. Glibc / ロケール関連エラー
**症状:** `error: build of ...-options.json.drv failed` や `glibc-locales> Error: unsupported locales detected:`
**原因:** 設定ファイル内のロケール指定文字列におけるタイポ（特に余計なスペース）。
**対応:**
*   `i18n.defaultLocale` などの設定値を検索する。
*   `"ja_JP. UTF-8"` のようにドットの後にスペースが含まれている場合は削除し、`"ja_JP.UTF-8"` に修正する。

### B. Deadnix (未使用変数) の修正ルール 【重要】
**症状:** `Warning: Unused lambda pattern: ...` や `Unused let binding: ...`
**禁止事項:**
*   **関数引数のリネームは原則禁止**。特に `modules` や `imports` で呼び出されるファイルにおいて、`{ pkgs, ... }` を `{ _pkgs, ... }` にリネームしてはならない。呼び出し元が `pkgs` を渡しているにもかかわらず、受け取り側が `_pkgs` を要求することになり、`called without required argument` エラーでビルドが破壊される。

**正しい対応:**
1.  **Lambda引数 (`{...}:`) の場合**:
    *   `...` (省略記号) が**ある**場合: 未使用の変数をリストから**削除**する。
        *   ❌ `modules/home/common/default.nix`: `{ _config, ... }`
        *   ✅ `modules/home/common/default.nix`: `{ ... }`
    *   `...` が**ない**場合、または引数が1つだけの場合: 引数全体を `_` または `args` に変更し、内容を無視する形式にする。
        *   ❌ `lib/hosts.nix`: `{ lib }: ...`
        *   ✅ `lib/hosts.nix`: `{ ... }: ...` または `_: ...`
2.  **Let binding (`let ... in`) の場合**:
    *   未使用の定義行そのものを削除する。

### C. Statix (静的解析) の修正と設定
**症状 1:** `error: The argument '--ignore ...' requires a value but none was supplied`
**原因:** `statix` コマンドへの引数渡しにおけるバグ。
**対応:** `flake.nix` の `checks` 設定において、`statix.settings.ignore` にダミー値（例: `[ ".direnv" ]`）を追加するか、一時的に `statix.enable = false` にする。

**症状 2:** `The key '...' is first assigned here ... repeated here`
**原因:** 同じ属性セット（例: `programs`, `services`）が複数回定義されている。
**対応:** バラバラに定義されているキーを1つのブロックに統合（マージ）する。
*   **修正前:**
    ```nix
    programs.zoxide.enable = true;
    programs.gh.enable = true;
    ```
*   **修正後:**
    ```nix
    programs = {
      zoxide.enable = true;
      gh.enable = true;
    };
    ```

### D. Alejandra / フォーマットエラー
**症状:** `hook id: alejandra ... files were modified by this hook`
**対応:**
*   Nixファイル: `nix run nixpkgs#alejandra -- .` を実行する。
*   Markdownファイル (`trim-trailing-whitespace`): 行末の空白を削除する。`sed -i 's/[ \t]*$//' <filename>` を使用可能。

## 3. 検証コマンド

修正を行った後は、以下の手順で検証を行うこと。Gitがdirtyな状態でも検証できるよう留意する。

1.  **変更のステージング** (FlakeはGit管理下のファイルのみ認識するため):
    ```bash
    git add .
    ```
2.  **チェックの実行**:
    ```bash
    nix flake check
    ```
3.  **ビルドテスト (Dry Run)**:
    チェックが通ってもビルドが通るとは限らないため、実際の構成をドライランする。
    ```bash
    nix build .#homeConfigurations."t4d4@nixos".activationPackage --dry-run
    ```
    ※ ユーザー名やホスト名は適宜 `flake.nix` の定義に合わせる。
