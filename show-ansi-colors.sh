#!/usr/bin/env sh

#original: https://gist.github.com/eliranmal/b373abbe1c21e991b394bdffb0c8a6cf

usage() {
    echo "show-ansi-colors <n>"
    exit 0
}

(( $# < 1 )) && usage

show_ansi_colors() {
    local colors=$1
    echo "showing $colors ansi colors:"
    for (( n=-0; n < $colors; n++ )) do
        printf " [%d]\t$(tput setab $n)%s$(tput sgr0)\n" $n "        "
    done
    echo
}

show_ansi_colors "$@"
