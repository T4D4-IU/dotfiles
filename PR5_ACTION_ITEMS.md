# PR #5 対応アクションアイテム

**作成日時**: 2026-01-20  
**PR**: [#5 🚀 Refactor: Multi-environment support with enhanced modularity](https://github.com/T4D4-IU/dotfiles/pull/5)

---

## 📊 進捗状況

- [x] Critical (3/3) ✅ **完了**
- [x] High Priority (3/3) ✅ **完了**
- [ ] Medium Priority (4/4)
- [ ] Low Priority (3/3)

---

## 🔴 Critical (必須対応) ✅ **完了**

### 1. wasmerビルドエラーの修正
- [x] **対応完了**
- **問題**: Home Manager設定のビルドが`wasmer`パッケージのリンクエラーで失敗
- **エラー内容**: `undefined reference to '__rust_probestack'`
- **原因**: `modules/home/common/development.nix`で`wasmer`パッケージを含めている
- **対応方法**: 
  - オプション1: `wasmer`をパッケージリストから削除
  - オプション2: ビルド設定を修正（より複雑）
- **影響ファイル**: 
  - `modules/home/common/development.nix`
- **関連ログ**: Job #60798790709, #60798790711

### 2. pre-commitフォーマット適用
- [x] **対応完了**
- **問題**: `alejandra`フォーマッターによる自動整形が必要
- **影響ファイル**: 
  - `pkgs/dfx.nix`
  - `pkgs/haystack-editor.nix`
- **対応方法**: 
  ```bash
  nix fmt
  git add pkgs/dfx.nix pkgs/haystack-editor.nix
  git commit -m "style: Apply alejandra formatting"
  ```
- **関連ログ**: Job #60798790702

### 3. flake.nix修正 (activation-script → activationPackage)
- [x] **対応完了**
- **問題**: 誤った属性名を使用（CodeRabbit指摘）
- **ファイル**: `flake.nix` line 66
- **現在**: `self.homeConfigurations."t4d4@nixos".activation-script`
- **修正後**: `self.homeConfigurations."t4d4@nixos".activationPackage`
- **レビュアー**: CodeRabbit (coderabbitai)

---

## 🟡 High Priority (重要)

### 4. 冗長なhome.username/home.homeDirectory定義の削除
- [ ] **対応完了**
- **問題**: `lib/helpers.nix`の`mkHomeConfiguration`で既に設定されている値を重複定義
- **影響ファイル**:
  - [ ] `hosts/nixos/home.nix` (lines 6-7)
  - [ ] `hosts/wsl/home.nix` (lines 6-7)
- **対応方法**: 該当行を削除
- **レビュアー**: Gemini Code Assist, Copilot

### 5. WSLドキュメントの修正
- [x] **対応完了**
- **問題**: ユーザー名が`t4d4`以外の場合に失敗する手順
- **ファイル**: `docs/WSL_SETUP.md` line 69
- **対応方法**: 
  - flake.nixの`homeConfigurations`がハードコードされていることを明記
  - ユーザー名変更時はflake.nixも修正が必要と追記
  - または動的生成への変更を検討（lib.mapAttrs'使用）
- **レビュアー**: Gemini Code Assist

### 6. common CLIモジュールからWayland専用ツールを移動
- [x] **対応完了**
- **問題**: WSL（CLI専用）でも読み込まれるcommonモジュールにGUI専用ツールが含まれる
- **ファイル**: `modules/home/common/cli.nix` (lines 43-47)
- **対象パッケージ**:
  - `grimblast` (Hyprlandスクリーンショットヘルパー)
  - `hyprpaper` (Hyprland壁紙ユーティリティ)
  - `cliphist` (Waylandクリップボードマネージャー)
  - `wl-clipboard` (Waylandクリップボードマネージャー)
  - `brightnessctl` (画面輝度制御、ラップトップGUI向け)
- **移動先**: `modules/home/linux/gui.nix`
- **レビュアー**: Copilot, Gemini Code Assist

---

## 🟢 Medium Priority (改善推奨)

### 7. ドキュメントの一貫性修正 (Hyprland参照削除)
- [ ] **README.md** (line 55): ディレクトリ構造からHyprland関連ファイルの記載削除
- [ ] **TODO.md** (line 173): 重複セクション見出し（5-3）の整理
- [ ] **TODO.md** (line 224): 最終的なディレクトリ構造からHyprland参照削除
- [ ] **lib/README.md** (lines 106-107, 133): `hyprland = true`の例を削除または`gnome = true`に変更
- [ ] **modules/home/README.md** (line 41-45): `dev.nix`の説明を実装内容に合わせて更新
- **理由**: PR概要で「Hyprland削除・GNOME専用化」を実施
- **レビュアー**: Copilot, Gemini Code Assist

### 8. ファイル末尾改行の追加
- [ ] `modules/home/common/direnv.nix` (line 6)
- [ ] `modules/home/common/starship.nix` (line 59)
- [ ] `modules/home/common/zsh.nix` (line 31)
- **理由**: POSIX標準とエディタ慣習への準拠
- **レビュアー**: Gemini Code Assist

### 9. Markdownリンティング修正
- [ ] `docs/CI_CD.md` (line 103): 裸URL `https://cachix.org` を `[Cachix](https://cachix.org)` に変更
- [ ] `docs/CI_CD.md` (line 130): コードブロックに言語指定 ` ```text` を追加
- [ ] `docs/WSL_SETUP.md` (lines 14, 19): 太字セクションタイトルを`### `ヘッダーに変更
- **ツール**: markdownlint-cli2
- **レビュアー**: CodeRabbit

---

## 🔵 Low Priority (任意)

### 10. コメントタイポ修正
- [ ] `modules/home/common/cli.nix` (line 37): "commanads" → "commands"
- [ ] `modules/home/common/development.nix` (line 22): `#cargo-llvm-covに使う` → `# cargo-llvm-covに使う`
- **レビュアー**: Copilot

### 11. starship設定の改善検討
- [ ] **検討完了**
- **ファイル**: `modules/home/common/starship.nix` (line 58)
- **現状**: `home.file`で直接`~/.config/starship.toml`に書き込み
- **改善案**: `programs.starship.settings`を使った型安全な設定への移行
- **メリット**: Home Manager統合、型検証、バリデーション
- **レビュアー**: Copilot

### 12. CI/CD summaryジョブの改善
- [ ] **対応完了**
- **ファイル**: `.github/workflows/nix-check.yml` (lines 175-189)
- **問題**: summaryジョブが`full-check`に依存せず、無条件に成功を報告
- **対応方法**: 
  - needsに`full-check`を追加
  - `full-check`の結果を条件チェック
- **レビュアー**: CodeRabbit

---

## 📌 推奨作業順序

### Phase 1: CI修正 (最優先)
1. ✅ wasmerビルドエラー修正
2. ✅ pre-commitフォーマット適用
3. ✅ flake.nix修正

### Phase 2: 構造改善
4. ✅ 冗長な定義削除
5. ✅ Wayland専用ツール移動
6. ✅ WSLドキュメント修正

### Phase 3: ドキュメント整備
7. ✅ Hyprland参照削除
8. ✅ ファイル末尾改行追加
9. ✅ Markdownリンティング修正

### Phase 4: 細かい改善（任意）
10. ✅ コメントタイポ修正
11. ✅ starship設定検討
12. ✅ CI summaryジョブ改善

---

## 🔗 参考リンク

- **PR URL**: https://github.com/T4D4-IU/dotfiles/pull/5
- **Actions失敗ログ**: https://github.com/T4D4-IU/dotfiles/actions/runs/21142196042
- **失敗したジョブ**:
  - lint-format: https://github.com/T4D4-IU/dotfiles/actions/runs/21142196042/job/60798790702
  - home-manager-configs (nixos): https://github.com/T4D4-IU/dotfiles/actions/runs/21142196042/job/60798790709

---

## 📝 メモ

- Copilot, Gemini, CodeRabbitの3つのAIボットからレビューコメントあり（合計37件）
- 主な問題はビルドエラーとコードスタイルの不一致
- ドキュメントの一貫性についての指摘が多い
