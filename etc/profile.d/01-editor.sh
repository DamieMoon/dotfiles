# WSL-PORT (Ubuntu): upstream har "export EDITOR=nvim" ovillkorligt.
# neovim är inte installerat här, och en icke-existerande EDITOR gör att
# git commit, git rebase -i, visudo och crontab -e alla dör med
# "nvim: command not found".
#
# /usr/bin/editor är Ubuntus update-alternatives-länk. Byt underliggande
# editor med `sudo update-alternatives --config editor` utan att röra dotfiles.
export EDITOR=/usr/bin/editor
export VISUAL="$EDITOR"
