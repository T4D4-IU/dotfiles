# ヘルパーライブラリ

このディレクトリには、Flake設定を簡素化するためのヘルパー関数とホスト定義が含まれています。

## 📂 ファイル構成

```
lib/
├── default.nix     # ライブラリのエントリーポイント
├── helpers.nix     # 設定生成ヘルパー関数
└── hosts.nix       # ホスト定義
```

## 📚 helpers.nix

### mkHomeConfiguration

Home Manager設定を生成するヘルパー関数。

**使用例**:
```nix
helpers.mkHomeConfiguration {
  inherit inputs;
  system = "x86_64-linux";
  username = "t4d4";
  homeDirectory = "/home/t4d4";
  modules = [
    ./hosts/nixos/home.nix
  ];
}
```

**パラメータ**:
- `inputs`: Flakeのinputs
- `system`: システムアーキテクチャ（例: `x86_64-linux`, `aarch64-darwin`）
- `username`: ユーザー名
- `homeDirectory`: ホームディレクトリのパス
- `modules`: インポートする追加モジュールのリスト

**機能**:
- nixpkgsを自動インポート
- unfreeパッケージを有効化
- rust-overlayを自動適用
- 基本的なHome Manager設定を自動生成

### mkNixosConfiguration

NixOS設定を生成するヘルパー関数。

**使用例**:
```nix
helpers.mkNixosConfiguration {
  inherit inputs;
  system = "x86_64-linux";
  hostname = "nixos";
  modules = [
    ./hosts/nixos
  ];
}
```

**パラメータ**:
- `inputs`: Flakeのinputs
- `system`: システムアーキテクチャ
- `hostname`: ホスト名
- `modules`: インポートするモジュールのリスト

### OS判定ヘルパー

システムのOSを判定する関数群。

```nix
# Linux判定
helpers.isLinux "x86_64-linux"  # => true
helpers.isLinux "aarch64-darwin"  # => false

# macOS判定
helpers.isDarwin "aarch64-darwin"  # => true
helpers.isDarwin "x86_64-linux"  # => false

# アーキテクチャ判定
helpers.isx86_64 "x86_64-linux"  # => true
helpers.isAarch64 "aarch64-darwin"  # => true

# OS種別を取得
helpers.systemType "x86_64-linux"  # => "linux"
helpers.systemType "aarch64-darwin"  # => "darwin"
```

## 🏠 hosts.nix

ホスト情報を構造化して定義するファイル。

### ホスト定義のフォーマット

```nix
{
  <hostname> = {
    system = "<アーキテクチャ>";
    hostname = "<ホスト名>";
    username = "<ユーザー名>";
    homeDirectory = "<ホームディレクトリ>";
    
    features = {
      gui = <true/false>;
      development = <true/false>;
    };
    
    nixosModules = [
      # NixOS設定モジュール（NixOSの場合のみ）
    ];
    
    homeModules = [
      # Home Manager設定モジュール
    ];
  };
}
```

### 現在定義されているホスト

#### nixos
```nix
nixos = {
  system = "x86_64-linux";
  hostname = "nixos";
  username = "t4d4";
  homeDirectory = "/home/t4d4";
  
  features = {
    gui = true;
    development = true;
  };
  
  nixosModules = [ ../hosts/nixos ];
  homeModules = [ ../hosts/nixos/home.nix ];
}
```

## 🔧 使用方法

### flake.nix での使用

```nix
outputs = { self, nixpkgs, ... }@inputs: 
  let
    lib = nixpkgs.lib;
    myLib = import ./lib { inherit lib; };
    helpers = myLib.helpers;
    hosts = myLib.hosts;
  in
  {
    # NixOS設定
    nixosConfigurations = {
      nixos = helpers.mkNixosConfiguration {
        inherit inputs;
        system = hosts.nixos.system;
        hostname = hosts.nixos.hostname;
        modules = hosts.nixos.nixosModules;
      };
    };

    # Home Manager設定
    homeConfigurations = {
      "t4d4@nixos" = helpers.mkHomeConfiguration {
        inherit inputs;
        system = hosts.nixos.system;
        username = hosts.nixos.username;
        homeDirectory = hosts.nixos.homeDirectory;
        modules = hosts.nixos.homeModules;
      };
    };
  };
```

## ➕ 新しいホストの追加

### 1. hosts.nixに定義を追加

```nix
{
  nixos = { ... };  # 既存
  
  # 新しいホスト
  macbook = {
    system = "aarch64-darwin";
    hostname = "macbook";
    username = "t4d4";
    homeDirectory = "/Users/t4d4";
    
    features = {
      gui = true;
      development = true;
    };
    
    homeModules = [
      ../hosts/macbook/home.nix
    ];
  };
}
```

### 2. ホスト設定を作成

```bash
mkdir -p hosts/macbook
# hosts/macbook/home.nix を作成
```

### 3. flake.nixに追加

```nix
homeConfigurations = {
  "t4d4@nixos" = helpers.mkHomeConfiguration { ... };
  
  # 新規追加
  "t4d4@macbook" = helpers.mkHomeConfiguration {
    inherit inputs;
    system = hosts.macbook.system;
    username = hosts.macbook.username;
    homeDirectory = hosts.macbook.homeDirectory;
    modules = hosts.macbook.homeModules;
  };
};
```

## 💡 ベストプラクティス

1. **ホスト情報の一元管理**: すべてのホスト定義は `hosts.nix` に集約
2. **ヘルパー関数の活用**: 重複コードを避ける
3. **features フィールドの活用**: 将来的な条件分岐に使用可能
4. **命名規則の統一**: `username@hostname` 形式を維持

## 🔮 将来の拡張

- featuresに基づく自動モジュール選択
- ホストグループの定義（例: desktop, server, laptop）
- 環境変数やsecretsの管理機能
- テンプレート機能（新規ホスト作成の自動化）

## 🔗 参考

- [Nix Language Basics](https://nixos.org/manual/nix/stable/language/)
- [Flakes](https://nixos.wiki/wiki/Flakes)
