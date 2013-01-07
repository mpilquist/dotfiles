# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion=/usr/local/share/git-core/contrib/completion/git-completion.zsh
bash_completion=/usr/local/etc/bash_completion.d/git-completion.bash

if test -f $completion
then
  zstyle ':completion:*:*:git:*' script $bash_completion
else
  if test -f $bash_completion
  then
    source $bash_completion
  fi
fi
