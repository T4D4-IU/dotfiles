# Nixリンター・フォーマッター設定

このプロジェクトでは、Nixコードの品質を保つために以下のツールを使用しています。

## 🛠️ 使用ツール

### フォーマッター
- **alejandra**: 公式推奨のNixフォーマッター
  - 一貫したコードスタイル
  - 自動整形

### リンター
- **statix**: Nixコードのアンチパターンを検出
  - コードの改善提案
  - ベストプラクティスの推奨
- **deadnix**: 未使用コードの検出
  - 使われていない変数や関数を発見

### 追加チェック
- マージコンフリクトの検出
- ファイル末尾の改行
- 行末の空白削除

## 🚀 使い方

### 開発環境のセットアップ

```bash
# 開発シェルに入る
nix develop

# または
nix-shell
```

開発シェルに入ると、pre-commitフックが自動的にインストールされます。

### 手動実行

```bash
# すべてのpre-commitチェックを実行
nix flake check .#checks.x86_64-linux.pre-commit-check

# または開発シェル内で
pre-commit run --all-files
```

### 個別ツールの実行

```bash
# フォーマット
alejandra .

# フォーマットチェック（CI用）
alejandra --check .

# リンター
statix check .

# 未使用コード検出
deadnix .

# 未使用コード削除
deadnix --edit
```

## 🔄 自動実行

### Pre-commitフック（ローカル）

開発シェル（`nix develop`）に入ると、自動的にpre-commitフックが設定されます。

```bash
git commit
```

コミット時に自動で以下が実行されます：
- ✅ Nixファイルのフォーマットチェック
- ✅ リンティング
- ✅ 未使用コード検出
- ✅ その他のコードチェック

### GitHub Actions（CI）

プッシュ時に自動で実行されます：

```yaml
on:
  push:
    branches: [main, master]
  pull_request:
```

**実行内容**:
1. **lint-format ジョブ**: 最初に実行（高速）
   - alejandraによるフォーマットチェック
   - statixによるリンティング
   - deadnixによる未使用コード検出
2. 他のビルド・テストジョブは並行実行

## 📝 設定のカスタマイズ

### pre-commitフックの設定

`flake.nix`の`checks`セクション:

```nix
checks = forAllSystems (system: {
  pre-commit-check = pre-commit-hooks.lib.${system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
      statix.enable = true;
      deadnix.enable = true;
      # 他のフックを追加可能
    };
  };
});
```

### 特定のファイルを除外

`.pre-commit-config.yaml`を作成（オプション）:

```yaml
exclude: ^(result/|\.direnv/)
```

## 🔧 トラブルシューティング

### Pre-commitフックが動作しない

```bash
# 開発シェルに再度入る
exit
nix develop

# または手動でインストール
pre-commit install
```

### フォーマットエラーの修正

```bash
# 自動修正
alejandra .

# 確認
git diff
```

### リンティングエラーの修正

```bash
# statixの提案を確認
statix check .

# 自動修正（一部）
statix fix .
```

### 未使用コードの削除

```bash
# 検出
deadnix .

# 自動削除
deadnix --edit
```

## 📚 参考リンク

- [alejandra](https://github.com/kamadorueda/alejandra)
- [statix](https://github.com/nerdypepper/statix)
- [deadnix](https://github.com/astro/deadnix)
- [pre-commit-hooks.nix](https://github.com/cachix/pre-commit-hooks.nix)

## 💡 ベストプラクティス

1. **コミット前にチェック**: pre-commitフックが自動で実行
2. **定期的にフォーマット**: 大きな変更前に`alejandra .`
3. **リンターの提案を確認**: `statix check .`で改善点を発見
4. **未使用コードの削除**: 定期的に`deadnix`を実行

## 🎯 CI/CDとの連携

GitHub Actionsで自動チェック：
- ✅ Push時に自動実行
- ✅ Pull Request時にもチェック
- ✅ マージ前に品質保証

エラーがあるとコミット/プッシュがブロックされるため、常にクリーンなコードが保たれます。
