if [ -f `brew --prefix`/etc/autojump ]; then
    . `brew --prefix`/etc/autojump
elif [ -f `brew --prefix`/etc/autojump.zsh ]; then
    . `brew --prefix`/etc/autojump.zsh
elif [ -f `brew --prefix`/etc/autojump.sh ]; then
    . `brew --prefix`/etc/autojump.sh
fi
