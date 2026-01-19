{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch # fetch system information
    omekasy # generate dressed up text
    teip # modern pipeline
    eza # modern ls command
    zoxide # smarter cd command
    wthrr # weather command
    dust # du command alternative
    bat # cat command alternative
    fd # find command alternative
    duf # df command alternative
    procs # ps command alternative
    bottom # top command alternative
    ripgrep # grep command alternative
    navi # cheat sheet
    delta # diff command alternative
    hyperfine # benchmarking tool
    broot # tree command alternative
    tokei # count code
    grex # generate regex
    silicon # code image generator
    fzf # commandline fuzzy finder
    lazygit # git terminal UI
    yazi # terminal file manager
    tmux # terminal multiplexer
    ncspot # Cross-platform ncurses Spotify client
    ctop # Top-like interface for container metrics
    oha # HTTP load generator inspired by rakyll/hey with tui animation
    lolcat # Rainbow version of cat
    termdown # Starts a countdown to or from TIMESPEC
    neo-cowsay # Cowsay reborn, written in Go
    gping # Ping, but with a graph
    sl # Steam Locomotive runs across your terminal when you type 'sl'
    atuin #Replacement for a shell history which records additional commanads
    charm-freeze # Tool to generate images of code and terminal output
    genact # Nonsense activity generator
    vhs # Tool for generating terminal GIFs with code
    xh # Friendly and fast tool for sending HTTP requests
    zellij # Terminal workspace with batteries included
    grimblast # Helper for screenshots within Hyprland, based on grimshot
    hyprpaper # Blazing fast wayland wallpaper utility
    cliphist # Wayland clipboard History
    wl-clipboard # Wayland clipboard manager
    brightnessctl # screen brightness
  ];
}
