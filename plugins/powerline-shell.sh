#!/bin/bash
powerline_shell="${SENF_PATH}/bin/powerline-go-darwin-amd64"

if test -f "${powerline_shell}"; then
	if [ -n "${ZSH_VERSION}" ]; then

		function powerline_precmd() {
			PS1="$(${powerline_shell} -error $? -shell zsh)"
		}

		function install_powerline_precmd() {
			for s in "${precmd_functions[@]}"; do
				if [ "$s" = "powerline_precmd" ]; then
				return
				fi
			done
			precmd_functions+=(powerline_precmd)
		}

		if [ "$TERM" != "linux" ]; then
			install_powerline_precmd
		fi

		addSenf "powerline-shell (zsh)"

	elif [ -n "$BASH_VERSION" ]; then

		function _update_ps1() {
			PS1="$(${powerline_shell} -error $?)"
		}

		if [ "$TERM" != "linux" ] && [ -f "${powerline_shell}" ]; then
			PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
		fi

		addSenf "powerline-shell (bash)"

	else
		senfError "Shell not supoorted ${SHELL}"
	fi
else
	senfInstallError "Missing powerline-shell install."
fi
