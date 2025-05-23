# Home-manager

## TODO
- ファイル構造を整理する(継続的に)
- 日本語入力を良い感じにしたい
- ステータスバーを良い感じにしたい
- クリップボードを良い感じにしたい
- ロック画面を良い感じにしたい

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
- zulip
- slack
- [telegram-desktop](https://desktop.telegram.org/)
- spotify
- syncthing
- [rquickshare](https://github.com/Martichou/rquickshare)
- [act](https://github.com/nektos/act) # GitHub Actionsのローカル実行
- [pinact](https://github.com/suzuki-shunsuke/pinact) # Pin GitHub Actions versions
- [gobuster](https://github.com/OJ/gobuster) # Tool used to brute-force URIs and DNS subdomains.
- [sniffnet](https://github.com/gyulyvgc/sniffnet) # Cross-platform application to monitor your network traffic with ease
- [atuin](https://github.com/atuinsh/atuin) #Replacement for a shell history which records additional commanads
- [charm-freeze](https://github.com/charmbracelet/freeze) # Tool to generate images of code and terminal output
- [actionlint](https://rhysd.github.io/actionlint/) # Static checker for GitHub Actions workflow files
- clive # Automates terminal operations
- [genact](https://github.com/svenstaro/genact) # Nonsense activity generator
- [vhs](https://github.com/charmbracelet/vhs) # Tool for generating terminal GIFs with code
- [xh](https://github.com/ducaale/xh) # Friendly and fast tool for sending HTTP requests
- [wireshark](https://www.wireshark.org/) # Powerful network protocol analyzer
- [waybar](https://github.com/alexays/waybar) # Highly customizable Wayland bar for Sway and Wlroots based compositors
- [grimblast](https://github.com/hyprwm/contrib/tree/main/grimblast) # Helper for screenshots within Hyprland, based on grimshot
- [hyprpaper](https://github.com/hyprwm/hyprpaper) # Blazing fast wayland wallpaper utility
- [dunst](https://dunst-project.org/) # Lightweight and customizable notification daemon
- [wlogout](https://github.com/ArtsyMacaw/wlogout) # Wayland based logout menu
- cliphist # Wayland clipboard manager
- hyprlock # Hypland's GPU-accelerated screen locking utility
- zenity
- networkmanagerapplet # network manager gui
- brightnessctl # screen brightness
- [metasploit](https://docs.metasploit.com/) # Metasploit Framework - a collection of exploits
- [armitage](https://github.com/r00t0v3rr1d3/armitage) # Graphical cyber attack management tool for Metasploit
- [blueberry](https://github.com/linuxmint/blueberry) # Bluetooth configuration tool

#### GitHub CLI extensions
- markdown-preview
- copilot
- [dash](https://github.com/dlvhdr/gh-dash)
- [poi](https://github.com/seachicken/gh-poi)
- [actions-cache](https://github.com/actions/gh-actions-cache)
- skyline
- [eco](https://github.com/coloradocolby/gh-eco)

#### 分割したファイルの詳細
- [direnv.nix](./direnv.nix) #direnvの設定
- [development.nix](./development.nix) #開発環境の設定
- [zed.nix](./zed.nix) #zedの設定
- [zsh.nix](./zsh.nix) #zshの設定

#### Ghosttyの設定
- [オプションリファレンス](https://ghostty.org/docs/config/reference#macos-icon-screen-color)
- [非公式のGUIから設定できるサイト](https://ghostty.zerebos.com/settings/application)
- [公式の配布しているレポジトリ内のCOnfigファイル](https://github.com/ghostty-org/ghostty/blob/main/src/config/Config.zig)
- [設定を参考にしたYukiさんのブログ](https://blog-dry.com/entry/2024/12/27/162410)

#### Hyprlandの設定
- 参考リンク
  - https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
  - https://wiki.hyprland.org/Nix/Plugins/
  - https://qiita.com/furyu_penguin/items/1cb71b64b36f4a9410a1
- プラグイン
  - [hy3](https://github.com/outfoxxed/hy3)
  - https://github.com/hyprwm/hyprland-plugins
    - hyprbars
    - hyprwinwrap
    - borders-plus-plus

#### お借りした設定
- [elythh/nixvim](https://neovimcraft.com/plugin/elythh/nixvim/)
