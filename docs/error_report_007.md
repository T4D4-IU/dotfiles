# エラーレポート：Sudo実行時のHOMEディレクトリ所有権警告

## 1. エラー（警告）内容とその意味

**エラー文:**
```
warning: $HOME ('/Users/t4d4') is not owned by you, falling back to the one defined in the 'passwd' file ('/var/root')
```

**意味:**
これは致命的なエラーではなく、Nixの仕様による**警告（warning）**です。
`nix run .` の実行スクリプト内で macOS のシステム設定を適用するため `sudo nix run path:...` を実行していますが、`sudo` を使って root 権限で Nix を実行した際、環境変数 `$HOME` がログインユーザー（`/Users/t4d4`）のまま引き継がれることがあります。
Nixは「現在の実行ユーザーは root なのに、`$HOME` が t4d4 のディレクトリを指している（所有者が違う）」ことを検知し、安全のために自動で root の本来のホームディレクトリ（`/var/root`）にフォールバック（切り替え）したよ、という通知を出しています。
動作自体に実害はありませんが、実行のたびに警告が出るため目障りになります。

## 2. 修正計画（何を・何故・どのように）

**何を:**
適用スクリプト（`flake.nix` 内の `applyScript`）における `sudo` の呼び出し方法を修正します。

**何故:**
実行時の警告表示を消し、クリーンな出力を保つためです。

**どのように:**
`flake.nix` 内の macOS 用適用コマンドについて、`sudo` に `-H` オプション（または明示的な `$HOME` のリセット）を追加します。
`-H` オプションは「対象ユーザー（この場合は root）のホームディレクトリを `$HOME` にセットする」よう sudo に指示するため、Nix 実行時に所有権の不一致が起こらなくなり、警告が消えます。

変更箇所 (`flake.nix`):
```diff
- sudo nix run path:${inputs.darwin} -- switch --flake .#$HOSTNAME
+ sudo -H nix run path:${inputs.darwin} -- switch --flake .#$HOSTNAME
```

## 3. DoD (Definition of Done: 完了定義)

- `flake.nix` 内の `sudo` コマンドに `-H` オプションが追加されていること。
- 次回以降 `nix run . --mac` を実行した際、冒頭に `warning: $HOME ('/Users/t4d4') is not owned by you...` の警告メッセージが表示されないこと。

---
上記の内容で修正を進めてよろしいでしょうか？承認をお願いいたします。
