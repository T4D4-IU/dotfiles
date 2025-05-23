{pkgs, ...}: {
    programs.starship = {
    };
    home.file."./.config/starship.toml".text = ''
    format = """
    [](#9A348E)\
    $username\
    [](bg:#DA627D fg:#9A348E)\
    $directory\
    [](fg:#DA627D bg:#FCA17D)\
    $git_branch\
    $git_status\
    [](fg:#FCA17D bg:#06969A)\
    $time\
    [ ](fg:#06969A)\
    $cmd_duration \
    $status\
    $line_break\
    $character\
    """

    [username]
    show_always = true
    style_user = "bg:#9A348E"
    style_root = "bg:#9A348E"
    format = '[$user ]($style)'

    [directory]
    style = "bg:#DA627D"
    format = "[ $path ]($style)"
    truncate_to_repo = false
    truncation_length = 3
    truncation_symbol = "…/"

    [git_branch]
    symbol = ""
    style = "bg:#FCA17D"
    format = '[ $symbol $branch ]($style)'

    [git_status]
    style = "bg:#FCA17D"
    format = '[$all_status$ahead_behind ]($style)'
    deleted = '󰅖'

    [status]
    disabled = false
    symbol = ' '

    [cmd_duration]
    min_time = 1
    format = '$duration '

    [time]
    disabled = false
    time_format = "%T"
    style = "bg:#06969A"
    format = '[ 󰅐 $time]($style)'
    '';
}