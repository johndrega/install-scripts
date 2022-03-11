#! /bin/bash

set -e -o pipefail

if [ "$(whoami)" != root ]; then
	echo "Error:: Super user privileges are required"
	exit 1
fi
if [ "$(logname)" == root ]; then
	echo "Error:: Use 'sudo' with your user instead of 'root'"
	exit 1
fi

sublimeMerge() {
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg &&
		pacman-key --add sublimehq-pub.gpg && pacman-key --lsign-key 8A8F901A &&
		rm sublimehq-pub.gpg

	# TODO: If this is already in the pacman conf, then don't add it again
	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" |
		tee -a /etc/pacman.conf

	pacman -Syu sublime-merge --noconfirm
}

docker() {
	pacman -Syu docker docker-compose --noconfirm

	# May require machine to be rebooted before the service will
	# start if the kernel was updated since boot.
	systemctl start docker.service
	systemctl enable docker.service

	if ! grep docker /etc/group; then
		groupadd docker
	fi
	gpasswd -a john docker
}

rust() {
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash
}

nodeVersionManager() {
	curl -fsSL https://fnm.vercel.app/install | bash
}

# Consider moving to awesome, xmonad requires the haskell compiler which is
# a pretty large dependency
windowManager() {
	pacman -Syu xmonad xmobar xmonad-contrib feh --noconfirm
}

aur() {
	cd ~/aur
	sudo -u "$(logname)" git clone https://aur.archlinux.org/"$1".git
	cd "$1"

	sudo -u "$(logname)" makepkg -sic --noconfirm
}

installAurs() {
	sudo -u "$(logname)" mkdir /home/"$(logname)"/aur

	aur google-chrome
	aur visual-studio-code-bin
	aur datagrip
	aur postman-bin
}

installPackages() {
	pacman -Syu base-devl \
		alacritty \
		aws-cli \
		expac \
		git \
		htop \
		neovim \
		postgresql-libs \
		python-pip \
		redis \
		rofi \
		xorg-server \
		xorg-xinit \
		yajl \
		zsh --noconfirm

	sublimeMerge
	docker
	rust
	nodeVersionManager
	windowManager

	installAurs
}

pullDotfiles() {
	cd ~
	git init .
	git remote add origin https://github.com/johndrega/dotfiles.git
	git fetch
	git reset --hard origin/master
}

installPackages
# pullDotfiles

echo "You'll need to reboot for certain changes to take effect"

# These super work specific tasks should be added to a work specific script
# I have had to edit the hosts file
# npm ci for the packages
# needed to add my aws credentials `aws configure`
# I needed to log into ecr with docker in order to pull the images
# ts-node needed to be install globally to run the copy-db-script
# Ran the copy db script so that the migrations were no longer an issue
# The work stack should now stand-up
