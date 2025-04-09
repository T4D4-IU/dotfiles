# Home-manager
### memo
- パッケージは[Nixpkgs](https://search.nixos.org/packages?query=)から探す。
- 入れ方は[home.nix](./home.nix)のhome.packagesに追加する。
- パッケージのオプションの有無は[Home Manager Option Search](https://home-manager-options.extranix.com/?query=&release=release-24.05)から探すことができる。
- パッケージのオプションはprogramsを利用して設定する。
- 更新後 `home-manager switch`を実行して適用する。
- nix言語の文法に問題があるかは`nix-instantiate --parse <filename>`で確認できる。
- aliasを設定する場合、aliasの設定とhome.packagesへの追加は同じファイル内じゃないといけなさそう（?）

### 参考リンク
- https://zenn.dev/asa1984/articles/nixos-is-the-best#home.file
- https://zenn.dev/kuu/articles/20250204_introduce-home-manager
- https://wonderwall.hatenablog.com/entry/rust-command-line-tools
- https://yiskw713.hatenablog.com/entry/2022/01/16/010000#%E4%BD%BF%E3%81%84%E6%96%B9

### インストール済みパッケージリスト
- brave
- [fastfetch](https://github.com/fastfetch-cli/fastfetch) # fetch system information
- discord
- [omekasy](https://github.com/ikanago/omekasy) # generate dressed up text
- [teip](https://github.com/greymd/teip) # modern pipeline
- [marp-cli](https://github.com/marp-team/marp-cli)
- textlint
- [eza](https://github.com/eza-community/eza) # modern ls command
- [zoxide](https://github.com/ajeetdsouza/zoxide) # smarter cd command
- [wthrr](https://github.com/ttytm/wthrr-the-weathercrab) # weather command
- [zizmor](https://woodruffw.github.io/zizmor/) # static analysis tool for GitHub Actions
- [dust](https://github.com/bootandy/dust) # du alternative written in Rust
- [bat](https://github.com/sharkdp/bat) # cat command with syntax highlighting
- [fd](https://github.com/sharkdp/fd) # find command with syntax highlighting
- [duf](https://github.com/muesli/duf) # disk usage/ free Utility
- [procs](https://github.com/dalance/procs) # modern replacement for ps written in Rust
- [bottom](https://github.com/ClementTsang/bottom) # graphical process/system monitor written in Rust
  - `btm`で呼び出す
- [ripgrep](https://github.com/BurntSushi/ripgrep) # Utility that combines the usability of The Silver Searcher with the raw speed of grep
  - `rg`で呼び出す
- [navi](https://github.com/denisidoro/navi) # interactive cheatsheet tool for the command-line
- [delta](https://github.com/dandavison/delta) # syntax-highlighter for git and diff output
- [hyperfine](https://github.com/sharkdp/hyperfine) # command-line benchmarking tool
- [broot](https://github.com/Canop/broot) # interactive tree view
- [tokei](https://github.com/XAMPPRocky/tokei) # Program that allows you to count your code, quickly
- [grex](https://github.com/pemistahl/grex) # generate regular expression
- [silicon](https://github.com/Aloxaf/silicon) # create beautiful image of source code
- [fzf](https://github.com/junegunn/fzf) # A command-line fuzzy finder
- [zenn-cli](https://github.com/zenn-dev/zenn-editor/tree/canary/packages/zenn-cli) # CLI tool for Zenn
- [wakatime-cli](https://wakatime.com/dashboard) # CLI tool for Wakatime
- [ghq](https://github.com/x-motemen/ghq) # Remote repository management made easy
- [lazygit](https://github.com/jesseduffield/lazygit) # simple terminal UI for git commands
- [gibo](https://github.com/simonwhitaker/gibo) # create .gitignore file
- [yazi](https://github.com/sxyazi/yazi) # 💥 Blazing fast terminal file manager written in Rust, based on async I/O.
- [tmux](https://github.com/tmux/tmux) # terminal multiplexer
- [ncspot](https://github.com/hrkfdn/ncspot) # Cross-platform ncurses Spotify client written in Rust
- [valgrind](https://valgrind.org/) # memory debugging and profiling tool
- [ctop](https://ctop.sh/) #Top-like interface for container metrics
- [oha](https://github.com/hatoo/oha) # HTTP load generator inspired by rakyll/hey with tui animation
- [lolcat](https://github.com/busyloop/lolcat) # Rainbow version of cat
- [termdown](https://github.com/trehn/termdown) # Starts a countdown to or from TIMESPEC
- [neo-cowsay](https://github.com/Code-Hex/Neo-cowsay) # Cowsay reborn, written in Go
- [gping](https://github.com/orf/gping) # ping, but with a graph
- [sl](http://www.tkl.iis.u-tokyo.ac.jp/~toyoda/index_e.html) # Steam Locomotive runs across your terminal when you type 'sl'
- obsidian
- anki
- notion-app-enhanced # #Notion Desktop build with Notion Enhancer for windows, macOS and Linux
- zulip
- slack
- telegram-desktop
- spotify
- syncthing
- rquickshare
- act # GitHub Actionsのローカル実行
- pinact # Pin GitHub Actions versions
- gobuster # Tool used to brute-force URIs and DNS subdomains.
- sniffnet # Cross-platform application to monitor your network traffic with ease
- atuin #Replacement for a shell history which records additional commanads
- charm-freeze # Tool to generate images of code and terminal output
- actionlint # Static checker for GitHub Actions workflow files
- clive # Automates terminal operations
- genact # Nonsense activity generator
- vhs # Tool for generating terminal GIFs with code
- xh # Friendly and fast tool for sending HTTP requests

#### GitHub CLI extensions
- markdown-preview
- copilot
- [dash](https://github.com/dlvhdr/gh-dash)
- [poi](https://github.com/seachicken/gh-poi)
- actions-cache
- skyline
- eco

#### 分割したファイルの詳細
- [direnv.nix](./direnv.nix) #direnvの設定
- [development.nix](./development.nix) #開発環境の設定

#### Ghosttyの設定
- [オプションリファレンス](https://ghostty.org/docs/config/reference#macos-icon-screen-color)
- [非公式のGUIから設定できるサイト](https://ghostty.zerebos.com/settings/application)
- [公式の配布しているレポジトリ内のCOnfigファイル](https://github.com/ghostty-org/ghostty/blob/main/src/config/Config.zig)
- [設定を参考にしたYukiさんのブログ](https://blog-dry.com/entry/2024/12/27/162410)

#### お借りした設定
- [elythh/nixvim](https://neovimcraft.com/plugin/elythh/nixvim/)
