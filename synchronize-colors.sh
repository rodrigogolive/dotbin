#!/bin/sh

ALACRITTY_PATH=$HOME/.config/alacritty
ROFI_PATH=$HOME/.config/rofi
XRESOURCES_PATH=$HOME


echo "Syncronizing colors based on $BASE16_THEME"

# set Xresources
(
    xresources="base16-$BASE16_THEME-256.Xresources"
    echo "  Setting Xresources ($xresources)"

    echo "#include \"./downloads/GIT/base16-xresources/xresources/$xresources\"" \
        > "$XRESOURCES_PATH"/.Xresources
    xrdb -load "$XRESOURCES_PATH"/.Xresources
)

# generate colors for alacritty and rofi based on template
(
    echo "  Generating colors for alacritty (color_template.yml -> colors.yml)"
    output=$(generate-colors.py "$ALACRITTY_PATH"/color_template.yml \
        "$ALACRITTY_PATH"/colors.yml)

    [ -n "$output" ] && echo "    $output"

    echo "  Generating colors for rofi (color_template.rasi -> colors.rasi)"
    output=$(generate-colors.py "$ROFI_PATH"/color_template.rasi \
        "$ROFI_PATH"/colors.rasi)

    [ -n "$output" ] && echo "    $output"
)

# reload i3, dunst and polybar
(
    echo "  Reloading i3"

    unset I3SOCK && \
        i3-msg reload > /dev/null && \
        i3-msg restart > /dev/null
)


# reload tmux
(
    current_session=$(tmux display-message -p '#S')
    echo "  Refreshing tmux sessions"

    temp_window="sync_color$(date "+%Y%m%d%H%M%S")"
    for session in $(tmux list-sessions | awk -F ":" '{print $1}' | \
        grep -v "$current_session")
    do
        echo "    $session... "

        tmux new-window -t "$session" -n "$temp_window"
        sleep 2
        tmux kill-window -t "$session:$temp_window"
    done
)


# reload nvim
(
    echo "  Refreshing nvim instances"

    eval "$(pyenv init -)"
    PYENV_VIRTUALENV_DISABLE_PROMPT=1 pyenv activate py3nvim

    for pid in $(pidof nvim)
    do
        socket=$(lsof -U -a -p "$pid" -w | grep tmp | awk '{print $9}')
        nvim_command=$(ps -o command= -p "$pid")
        echo "    $pid:$nvim_command ($socket)... "

        # source base16 colors and airline only (not need to source $MYVIMRC)
        # [0, 0, "nvim_command", ["source..."]]
        python3 -c "from pynvim import attach; \
            nvim = attach(\"socket\", path=\"$socket\"); \
            nvim.command(\"source $HOME/.vimrc_background | AirlineRefresh\")"
    done

    pyenv deactivate
)


# just some fanciness :)
(
    echo "  Listing new colors"
    printf "    "

    i=0
    while [ "$i" -lt 16 ]
    do
        printf "%s  %s" "$(tput setab $i)" "$(tput sgr0)"
        [ "$i" -eq 7 ] && echo && printf "    "

        i=$(( i + 1 ))
    done

    echo
)

echo "All done!"
