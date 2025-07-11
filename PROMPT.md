「こんにちは、Gemini。この NixOS の dotfiles リポジトリを、複数のマシンで共有できるようにリファクタリングしてください。

現在の構成では `hardware-configuration.nix` がリポジトリのルートにあり、他のマシンでは利用できません。そこで、各マシンの設定を個別に管理できるようなディレクトリ構造に変更し、`flake.nix` から適切な設定を読み込めるようにしてください。

具体的な手順は以下の通りです。

1.  **ホスト設定用のディレクトリを作成:**
    *   リポジトリのルートに `hosts` という名前のディレクトリを作成してください。
    *   `hosts` ディレクトリの中に、現在のマシン用のディレクトリとして `default` を作成してください。（後でマシンのホスト名などに変更できます）

2.  **デバイス固有のファイルを移動:**
    *   ルートにある `hardware-configuration.nix` を `hosts/default/` ディレクトリに移動してください。

3.  **ホストごとの設定ファイルを作成:**
    *   `hosts/default/` ディレクトリに、`default.nix` という名前で新しいファイルを作成してください。このファイルが、このホスト固有の設定（`hardware-configuration.nix` のインポートなど）をまとめる中心ファイルになります。

4.  **`flake.nix` の修正:**
    *   `flake.nix` を開き、`nixosConfigurations` の部分を修正してください。
    *   現在直接 `configuration.nix` を参照している部分を、`hosts` ディレクトリ以下の設定を読み込むように変更します。例えば、`nixosConfigurations.default = nixpkgs.lib.nixosSystem { ... };` のように、`default` という名前のホスト設定を追加し、その中で共通モジュールと `hosts/default/default.nix` をインポートするようにしてください。

5.  **共通設定のインポートを修正:**
    *   `configuration.nix` を修正し、`hardware-configuration.nix` のインポート文を削除してください。この責務は各ホストの `default.nix` に移ります。

この変更により、新しいマシンを追加したい場合は `hosts` ディレクトリに新しいマシン名のディレクトリを追加するだけで対応できるようになります。よろしくお願いします。」
  