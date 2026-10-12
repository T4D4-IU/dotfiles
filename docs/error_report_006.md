# エラーレポート: error_report_006

## エラー文
```
Homebrew bundle...
==> Auto-updating Homebrew...
...
Error: Calling the `--cleanup` switch is disabled! There is no replacement.
```

## エラーの意味
Homebrew のアップデートにより、`brew bundle` コマンドにおける `--cleanup` オプションスイッチが廃止（disabled）されました。
現在使用している nix-darwin が、Homebrew連携の有効化時（`onActivation`）に内部で古い形式の `brew bundle --cleanup` コマンドを実行しようとしているため、Homebrew側で拒否されてエラーが発生しています。

## 修正計画（何を、何故、どのように修正するか）

* **何を**:
  `hosts/macbook/default.nix` の `homebrew.onActivation.cleanup` 設定を修正します。

* **何故**:
  nix-darwin が廃止された `--cleanup` フラグを呼び出さないようにするためです。`cleanup = "none";` に変更することで、Homebrew bundle 実行時のクリーンアップ処理の呼び出しを回避し、エラーなく `android-platform-tools` を含むパッケージのインストール処理を進めることができます。

* **どのように**:
  `hosts/macbook/default.nix` の 40 行目を以下のように修正します。

  ```diff
    homebrew = {
      enable = true;
      onActivation.autoUpdate = true;
  -   onActivation.cleanup = "uninstall"; # Use standard cleanup to avoid aggressively zapping unmanaged packages
  +   onActivation.cleanup = "none";
  ```

  修正後、再度 `nix run . -- macbook` を実行いただくことで、正常に設定が適用されます。
