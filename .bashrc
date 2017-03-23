# set readline library into vi mode
set -o vi

# configure vi mode to use C-l for screen clean up
bind -m vi-insert "\C-l":clear-screen

# make vim as default editor
export EDITOR=vim
export VISUAL=vim
