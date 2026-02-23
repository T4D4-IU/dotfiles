---
description: Smart Submit with Jujutsu
---

## Steps
1. **Status Check**:
   - `jj status` と `jj diff` を実行して、現在のリビジョン（@）の変更内容を確認する。
2. **Describe (Commit 相当)**:
   - 変更内容を分析し、Conventional Commits 形式でメッセージを作成して `jj describe -m "<メッセージ>"` を実行する。
3. **Bookmark & Push**:
   - 現在のリビジョンに対して新しいブックマークを設定する（例: `jj bookmark create fix/update-xxx -r @`）。
   - リモートへPushする（例: `jj git push --bookmark fix/update-xxx`）。
4. **Create PR**:
   - ghコマンドを使用してプルリクエストを作成する。
   - PRのタイトルと説明には、変更内容の要約を記載する。
