---
description: Smart Submit with Jujutsu
---

# jj GitHub PR Workflow

このワークフローは、Jujutsu を使用して現在の作業（リビジョン）を整理し、GitHub にプルリクエストを作成するための手順です。

## Steps

1. **Context Analysis (状況確認)**:
   - AI が現在のリビジョン `@` の位置と変更内容を正確に把握するために実行します。
   - `jj log -r 'ancestors(@, 3) | @' --stat` : 最近の履歴と現在の変更ファイルの統計を表示。
   - `jj diff` : 実際の変更詳細を確認。

2. **Describe (メッセージ作成)**:
   - 変更内容を分析し、Conventional Commits 形式でメッセージを設定します。
   - `jj describe -m "<type>(<scope>): <subject>"`

3. **Bookmark Management (ブックマーク設定)**:
   - PR 用のブックマークを作成、または既存のものを現在の位置に移動します。
   - `jj bookmark set <branch-name> -r @`
   - ※ `create` ではなく `set` を使うことで、修正時の再 push にも対応します。

4. **Push to Remote (リモート送信)**:
   - ブックマークをリモート（通常は `origin`）に Push します。
   - `jj git push --bookmark <branch-name>`

5. **Create Pull Request (PR作成)**:
   - `gh` コマンドを使用して PR を作成します。
   - `gh pr create --fill`
   - ※ もし Git リポジトリが検出されないエラーが出る場合は、環境変数 `GIT_DIR=.jj/repo/store/git` を付与して実行してください。

6. **Cleanup & Next Task (迷走防止)**:
   - PR 作成後はPRの作成が完了したコトを作成したPRのリンクを添えて報告し待機してください。
