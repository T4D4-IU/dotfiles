# エラーレポート 1

## エラー文
```
Fetching google-gemini
Error: No available formula with the name "google-gemini". Did you mean google-benchmark?
`brew bundle` failed! Failed to fetch google-gemini
```

## エラーの意味
Nix-DarwinがHomebrew経由で `google-gemini` をインストールしようとした際に、ローカルのHomebrewのパッケージリスト（インデックス）に `google-gemini` が見つからなかったために発生したエラーです。
`google-gemini` は最近追加された新しいCaskであるため、ローカルのHomebrewのインデックスが古いままだと認識されません。

## 修正計画

### 何を修正するか
ローカルのHomebrewのパッケージインデックスを最新の状態に更新します。

### 何故修正するか
Homebrewが最新のCask情報（今回追加した `google-gemini`）を認識できるようにするためです。

### どのように修正するか
以下のいずれかの方法で対応します。

**案1: ユーザーご自身で `brew update` を実行する（推奨）**
ターミナル上で手動で `brew update` を実行し、Homebrewを最新化した後、再度 `sudo darwin-rebuild switch --flake .#macbook` を実行します。

**案2: `default.nix` にHomebrewの自動更新設定を追加する**
`/Users/t4d4/dotfiles/hosts/macbook/default.nix` の `homebrew` の設定に、`onActivation.autoUpdate = true;` を追加し、Nix-Darwin実行時に自動で `brew update` が走るようにします。

今回は環境の一時的な状態によるエラーの可能性が高いため、まずは「案1」を手動で実行していただくのが確実かと思われますが、もし毎回自動更新させたい場合は「案2」で設定ファイルを変更します。

方針についてご承認またはご指示をいただけますでしょうか？
