#!/bin/sh

###
# Environement
SENF_PATH="${HOME}/.senf"
SENF_BIN_PATH="${HOME}/.senf/bin"
mkdir -p "${SENF_BIN_PATH}/"

###
# Update Installation
git pull

###
# python, pip
python_cmd=$(which python)
${python_cmd} --version
${python_cmd} -m ensurepip --default-pip --upgrade --user
${python_cmd} -m pip install --upgrade pip setuptools wheel --user

python_bin_path="${HOME}/Library/Python/*/bin"
pip_cmd="${python_bin_path}/pip"
${pip_cmd} --version
${pip_cmd} install --upgrade pip --user

###
# powerline-shell
case $(uname | tr '[:upper:]' '[:lower:]') in
  linux*)
	powerline_cmd="powerline-go-linux-amd64"
    ;;
  darwin*)
	powerline_cmd="powerline-go-darwin-amd64"
    ;;
  msys*)
	powerline_cmd="powerline-go-windows-amd64"
    ;;
esac

if test -e "${powerline_cmd}"; then
	powerline_shell="${SENF_PATH}/bin/${powerline_cmd}"
	if test -e "${powerline_shell}"; then
		echo "✅ ${powerline_shell} already installed"
	else
		echo "⚙️  Installing powerline-shell"
		echo ${powerline_shell}
		curl "https://github.com/justjanne/powerline-go/releases/download/latest/${powerline_cmd}" > ${powerline_shell}
		chmod 755 ${powerline_shell}
	fi
fi

###
# powerline fonts
cd ~/Downloads
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
cd

###
# bash
bashrc="${HOME}/.bashrc"
senf_bashrc="\${HOME}/.senf/bashrc"

! test -e "${bashrc}" && touch "${bashrc}"

if test -e "${bashrc}"; then
	if grep -q "${senf_bashrc}" "${bashrc}"; then
		echo "✅ ${senf_bashrc} already sourced"
	else
		echo "⚙️  Sourcing ${senf_bashrc}"
		echo "" >>${bashrc}
		echo "# Including senf_bashrc" >>${bashrc}
		echo "test -e \"${senf_bashrc}\" && source \"${senf_bashrc}\"" >>${bashrc}
	fi
else
	echo "❌ ${senf_bashrc} does not exist"
fi

###
# zsh
zshrc=${HOME}/.zshrc
senf_zshrrc="\${HOME}/.senf/zshrc"

! test -e "${zshrc}" && touch "${zshrc}"

if test -e "${zshrc}"; then
	if grep -q "${senf_zshrrc}" "${zshrc}"; then
		echo "✅ ${senf_zshrrc} already sourced"
	else
		echo "⚙️  Sourcing ${senf_zshrrc}"
		echo "" >>${zshrc}
		echo "# Including env zshrc" >>${zshrc}
		echo "test -e \"${senf_zshrrc}\" && source \"${senf_zshrrc}\"" >>${zshrc}
	fi
else
	echo "❌ ${zshrc} does not exist"
fi

###
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
