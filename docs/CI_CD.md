# CI/CD 設定ガイド

このドキュメントでは、GitHub ActionsによるCI/CD設定について説明します。

## 🎯 CI/CDの目的

1. **品質保証**: コード変更が既存の設定を壊さないことを確認
2. **早期発見**: 構文エラーや設定ミスを即座に検出
3. **ドキュメント**: どの設定が動作するかを明示
4. **自動化**: 手動チェックの負担を軽減

## 📋 ワークフロー構成

### nix-check.yml（メインワークフロー）

複数のジョブで段階的にチェック：

#### 1. flake-info
- Flakeメタデータの表示
- Flake出力の確認
- **実行時間**: ~30秒

#### 2. packages (並列実行)
- カスタムパッケージのビルド
- `dfx`と`haystack-editor`を個別にテスト
- **実行時間**: ~3-5分（キャッシュあり）

#### 3. nixos-config
- NixOS設定の評価とドライビルド
- システムレベルの設定の妥当性確認
- **実行時間**: ~2-3分

#### 4. home-manager-configs (並列実行)
- 複数ホストのHome Manager設定をビルド
- `nixos`と`wsl`の両方をテスト
- **実行時間**: ~5-10分（キャッシュあり）

#### 5. module-check (並列実行)
- 個別モジュールの構文チェック
- `common`と`linux`モジュールを検証
- **実行時間**: ~1分

#### 6. full-check
- すべてのチェックが成功した後に実行
- `nix flake check`で包括的検証
- **実行時間**: ~10-15分
- ※エラーが出ても失敗扱いにしない（`continue-on-error: true`）

#### 7. summary
- 全体の結果をサマリー表示
- **実行時間**: ~10秒

### macos-check.yml（macOS用）

- Darwin固有モジュールの構文チェック
- 将来のmacOS対応時に有効化
- 現在は構文チェックのみ

## 🚀 実行タイミング

### 自動実行
```yaml
on:
  push:
    branches: [main, master]  # mainまたはmasterへのpush
  pull_request:                # すべてのPR
```

### 手動実行
GitHub Actionsタブから手動で実行可能（`workflow_dispatch`）

## ⚡ パフォーマンス最適化

### 1. Cachixの活用
```yaml
- uses: cachix/cachix-action@v15
  with:
    name: nix-community
    authToken: '${{ secrets.CACHIX_AUTH_TOKEN }}'
```

**メリット**:
- ビルド済みバイナリを再利用
- ビルド時間を大幅短縮（初回: 15分 → 2回目以降: 3分）

### 2. 並列実行
```yaml
strategy:
  matrix:
    host: [nixos, wsl]
```

複数の設定を同時にテスト。

### 3. 段階的実行
軽量なチェック（構文確認）から重いビルドへ順次実行。

## 🔧 Cachixのセットアップ（オプション）

自分のプロジェクト用にCachixを設定する場合：

### 1. Cachixアカウント作成
[Cachix](https://cachix.org) でサインアップ

### 2. キャッシュの作成
```bash
cachix create your-project-name
```

### 3. 認証トークンの取得
```bash
cachix authtoken
```

### 4. GitHubシークレットに追加
1. GitHubリポジトリの Settings → Secrets and variables → Actions
2. `CACHIX_AUTH_TOKEN`という名前で追加

### 5. ワークフローを更新
```yaml
- uses: cachix/cachix-action@v15
  with:
    name: your-project-name  # 作成したキャッシュ名
    authToken: '${{ secrets.CACHIX_AUTH_TOKEN }}'
```

## 📊 CI/CDの読み方

### 成功時
```text
✅ All checks completed!
  ✅ Flake metadata
  ✅ Custom packages (dfx, haystack-editor)
  ✅ NixOS configuration
  ✅ Home Manager configurations (nixos, wsl)
  ✅ Module syntax checks
```

### 失敗時の調査方法

1. **失敗したジョブを確認**
   - GitHub Actionsタブで赤いマークのジョブをクリック

2. **ログを確認**
   - 失敗したステップを展開
   - エラーメッセージを確認

3. **ローカルで再現**
   ```bash
   # 同じコマンドをローカルで実行
   nix build .#packages.x86_64-linux.dfx --print-build-logs
   ```

4. **修正後の検証**
   ```bash
   # 修正後、ローカルでクイックチェック
   nix flake check
   ```

## 🎯 CI/CDのベストプラクティス

### 1. PRごとにCIを実行
すべてのプルリクエストでCIが自動実行されることを確認。

### 2. マージ前にチェック
CI成功を確認してからmainにマージ。

### 3. 定期的な依存関係更新
```bash
# 月1回程度
nix flake update
git add flake.lock
git commit -m "chore: update dependencies"
```

### 4. キャッシュの活用
Cachixやnix-community cachixを活用してビルド時間を短縮。

### 5. ローカルテスト
CIに投げる前にローカルで`nix flake check`を実行。

## 🔗 関連リンク

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [cachix/install-nix-action](https://github.com/cachix/install-nix-action)
- [cachix/cachix-action](https://github.com/cachix/cachix-action)
- [Cachix Documentation](https://docs.cachix.org/)

## 💡 トラブルシューティング

### ビルドがタイムアウトする

**原因**: ビルドに時間がかかりすぎる（60分制限）

**解決策**:
1. Cachixを設定
2. 重いパッケージを別ジョブに分離
3. `--max-jobs`や`--cores`を調整

### ディスク容量不足

**原因**: GitHub Actionsランナーのディスク容量制限

**解決策**:
```yaml
- name: Free disk space
  run: |
    sudo rm -rf /usr/local/lib/android
    sudo rm -rf /opt/hostedtoolcache
```

### Cachixが機能しない

**原因**: 認証トークンが設定されていない

**解決策**:
1. `CACHIX_AUTH_TOKEN`シークレットが設定されているか確認
2. トークンの有効期限を確認
3. `skipPush: true`を使用してプッシュをスキップ（読み取りのみ）

## 🎉 まとめ

このCI/CD設定により：
- ✅ 複数環境（NixOS, WSL）の設定を自動テスト
- ✅ コード品質を保証
- ✅ 安心してコードを変更できる
- ✅ チーム開発でも一貫性を保持
