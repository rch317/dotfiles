#!/bin/bash

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,aliases,functions,path,extra,exports,credentials}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		# shellcheck source=/dev/null
		source "$file"
	fi
done
unset file

### Delete our aws_token_file if more than 12hrs old.
find ${HOME}/.vars -type f -name aws_token_file -mmin +3600 -exec rm {} \;

### Load various environment vars
myVars="${HOME}/.vars"
for file in $(ls ${myVars}/)
  do
    file="${myVars}/${file}"

    if [[ -r "${file}" ]] && [[ -f "${file}" ]]; then
      source "${file}"
    fi
  done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

## Add some git to our tmux session - kind of pointless if in shell prompt?
if [[ $TMUX ]]; then source ~/.tmux-git/tmux-git.sh; fi

# Add tab completion for SSH hostnames based on ~/.ssh/config
# ignoring wildcards
[[ -e "$HOME/.ssh/config" ]] && complete -o "default" \
	-o "nospace" \
	-W "$(grep "^Host" ~/.ssh/config | \
	grep -v "[?*]" | cut -d " " -f2 | \
	tr ' ' '\n')" scp sftp ssh

[[ -e "$HOME/.ssh/known_hosts" ]]
  complete -F _complete_ssh_hosts ssh

[[ -e "/usr/local/bin/aws_completer" ]]
  complete -C '/usr/local/bin/aws_completer' aws
