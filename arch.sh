#! /bin/bash

set -e -o pipefail

if [ "$(whoami)" != root ]; then
	echo "Error:: Super user privileges are required"
	exit 1
fi
if [ "$(logname)" == root ]; then
	echo "Error:: The 'root' user is not allowed, use 'sudo' with your user"
	exit 1
fi

sublimeMerge() {
	curl -O https://download.sublimetext.com/sublimehq-pub.gpg &&
		sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A &&
		rm sublimehq-pub.gpg

	echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" |
		sudo tee -a /etc/pacman.conf

	pacman -Syu sublime-merge --noconfirm
}

docker() {
	pacman -Syu docker docker-compose --noconfirm

	# May require machine to be rebooted before the service will
	# start if the kernel was updated since boot.
	systemctl start docker.service
	systemctl enable docker.service

	# really need to see if this exists first
	# groupadd docker
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
	git clone https://aur.archlinux.org/"$1".git
	cd "$1"

	makepkg -sic --noconfirm
}

googleChrome() {
	cd ~/aur
	git clone https://aur.archlinux.org/google-chrome.git
	cd google-chrome

	makepkg -sic --noconfirm
}

vsCode() {
	cd ~/aur
	git clone https://aur.archlinux.org/visual-studio-code-bin.git
	cd visual-studio-code-bin

	makepkg -sic --noconfirm
}

datagrip() {
	cd ~/aur
	git clone https://aur.archlinux.org/datagrip.git
	cd datagrip

	makepkg -sic --noconfirm
}

postman() {
	cd ~/aur
	git clone https://aur.archlinux.org/postman-bin.git
	cd postman-bin

	makepkg -sic --noconfirm
}

installAurs() {
	if [ "$(whoami)" == root ]; then
		echo "Error:: AURs must not be built as root"
		exit 1
	fi

	# testing this
	aur google-chrome
	aur visual-studio-code-bin
	aur datagrip
	aur postman-bin

	# googleChrome
	# vsCode
	# datagrip
	# postman
}

installPackages() {
	pacman -Syu binutils \
		make \
		gcc \
		fakeroot \
		expac \
		yajl \
		git \
		xorg-server \
		xorg-xinit \
		alacritty \
		neovim \
		redis \
		htop \
		rofi \
		aws-cli \
		zsh \
		python-pip \
		postgresql-libs --noconfirm

	sublimeMerge
	docker
	rust
	nodeVersionManager
	windowManager

	sudo -u "$(logname)" installAurs
}

configureDotfiles() {
	cd ~
	git init .
	git remote add origin https://github.com/johndrega/dotfiles.git
	git fetch
	git reset --hard origin/master
}

installPackages
# configureDotfiles

echo "Reboot machine for changes to be finalised"
echo "You will have to install a version of nodejs using the chosen node version manager"

# These super work specific tasks should be added to a work specific script
# I have had to edit the hosts file
# npm ci for the packages
# needed to add my aws credentials `aws configure`
# I needed to log into ecr with docker in order to pull the images
# ts-node needed to be install globally to run the copy-db-script
# Ran the copy db script so that the migrations were no longer an issue
# The work stack should now stand-up
