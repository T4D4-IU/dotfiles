
# Sops-Nix Setup Guide

このドキュメントでは、`sops-nix` を使用して、公開リポジトリ（dotfiles）と切り離したプライベートリポジトリで秘密情報を安全に管理する方法について説明します。

## 概要

- **公開リポジトリ**: `~/dotfiles`（設定ファイル、公開しても問題ない内容）
- **プライベートリポジトリ**: `~/dotfiles/secrets`（GithubのPrivateリポジトリ、`.gitignore`で除外、暗号化された秘密情報を格納）

`sops` は `age` を使用して秘密情報を暗号化し、NixOSのビルド時に `sops-nix` モジュールを通じて復号化されたファイルを `/run/secrets` などに配置します。

## 前提条件

- `gh` CLI（GitHub CLI）が認証済みであること
- `sops` および `age`、`ssh-to-age` がインストールされていること（`nix develop` で提供されます）
- 管理対象のマシン（ホスト）のSSHホスト鍵（`/etc/ssh/ssh_host_ed25519_key`）

## セットアップ手順（初回のみ）

このリポジトリのセットアップは完了していますが、参考として手順を記載します。

1. **プライベートリポジトリの作成**:
   GitHub上に `dotfiles-secrets` というPrivateリポジトリを作成し、`~/dotfiles/secrets` にクローンします。

2. **鍵の設定**:
   `.sops.yaml` を `secrets/` ディレクトリに作成し、暗号化に使用する公開鍵（ユーザーのAge鍵、ホストのSSHホスト鍵）を記述します。

   ```yaml
   keys:
     - &my_host age1... # ホストのAge公開鍵
   creation_rules:
     - path_regex: secrets.yaml$
       key_groups:
       - age:
         - *my_host
   ```

   ホストのSSH公開鍵からAge鍵への変換:
   ```bash
   nix run nixpkgs#ssh-to-age <<< "ssh-ed25519 AAAA..."
   ```

3. **Flakeの設定**:
   `flake.nix` に `sops-nix` と `my-secrets`（プライベートリポジトリ）を入力として追加します。

4. **モジュールの有効化**:
   `modules/secrets.nix` で `sops-nix` モジュールをインポートし、デフォルトの秘密情報ファイルを指定します。

## 秘密情報の管理方法

### 開発環境に入る
```bash
nix develop
# 必要なツール（sops, age, ssh-to-age）が利用可能になります
```

### 秘密情報の編集
```bash
sops secrets/secrets.yaml
```
エディタが開き、復号化された状態で編集できます。保存して閉じると自動的に再暗号化されます。

### 新しいホストの追加
1. 新しいホストのSSH公開鍵（`/etc/ssh/ssh_host_ed25519_key.pub`）を取得します。
2. その公開鍵をAge形式に変換します。
   ```bash
   nix run nixpkgs#ssh-to-age <<< "ssh-ed25519 AAAA..."
   ```
3. `secrets/.sops.yaml` の `keys` セクションに追加し、`creation_rules` にも含めます。
4. 鍵情報を更新します。
   ```bash
   sops updatekeys secrets/secrets.yaml
   ```
5. `secrets/` ディレクトリで変更をコミットし、プッシュします。

### 変更の反映
1. プライベートリポジトリ（`secrets/`）の変更をプッシュします。
   ```bash
   cd secrets
   git add .
   git commit -m "Update secrets"
   git push
   cd ..
   ```
2. `flake.lock` を更新して新しいコミットハッシュを取り込みます。
   ```bash
   nix flake update
   ```
3. NixOSを適用します。
   ```bash
   nixos-rebuild switch --flake .#nixos
   ```

## Nixでの利用方法

`modules/secrets.nix` などで以下のように定義します。

```nix
sops.secrets.my_secret_key = {
  # オプション: 所有者を指定（デフォルトはroot）
  # owner = "user";
};
```

プログラム内での参照:
```nix
config.sops.secrets.my_secret_key.path
```
このパスは `/run/secrets/my_secret_key` を指します。

## トラブルシューティング

- **復号化失敗**: ホスト鍵が正しく `.sops.yaml` に登録されているか、ホスト側に秘密鍵（`/etc/ssh/ssh_host_ed25519_key`）が存在するか確認してください。
- **Gitエラー**: `secrets/` ディレクトリは `.gitignore` されているため、`dotfiles` リポジトリのGit操作には影響しませんが、`secrets/` 内部でのGit操作が必要です。
