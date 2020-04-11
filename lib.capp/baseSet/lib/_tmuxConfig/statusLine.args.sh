#!/bin/bash

case "$1" in
    l1* | l2* | l3* )
        echo "set -g status-position top"
        echo "set -g status-justify centre"

        echo 'set -g window-status-current-format "| #I:#W#{?window_flags,#{window_flags}, } |"'
        echo "set -g window-status-current-style fg=cyan,bg=black,bright,blink"

        echo "set -g pane-active-border-style fg=cyan"
        ;;
    l8* | l9*       )
        echo "set -g status-position bottom"
        echo "set -g status-justify left"

        echo "set -g pane-active-border-style fg=green"
        ;;
esac

case "$1" in
    l1* ) echo "set -g status-style fg=#37474F,bg=#B2DFDB" ;;
    l2* ) echo "set -g status-style fg=#37474F,bg=#80CBC4" ;;
    l3* ) echo "set -g status-style fg=#37474F,bg=#4DB6AC" ;;
    l8* ) echo "set -g status-style fg=#C5E1A5,bg=#00796B" ;;
    l9* ) echo "set -g status-style fg=#C5E1A5,bg=#1B5E20" ;;
esac

statusLeftFormat='[#(tmux show-options -g | grep "^prefix " | sed "s/^prefix //")'
statusLeftFormat+=":#S]   "
echo "set -g status-left-length 10"
echo "set -g status-left '${statusLeftFormat}'"

statusRightFormat='@#{host} %H:%M '
# statusRightFormat+='#(ps o %cpu= o %mem= #{client_pid} | sed -e "s/^ *\([0-9.]\+\) *\([0-9.]\+\) *$/cpu=\1, mem=\2/g")'
echo "set -g status-right '${statusRightFormat}'"
echo "set -g status-right-length 40"

