#! /bin/bash
set -e -o pipefail

if [ "$(whoami)" != root ]; then
	echo "Error: Super user privileges are required"
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

	systemctl start docker.service
	systemctl enable docker.service

	# really need to see if this exists first
	groupadd docker
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

# Still need these to be done:

# vs code - aur
# datagrip - aur
# postman - aur
# google chrome - aur
# tylerbrock/saw - aur
# nvm - aur

# These super work specific tasks should be added to a work specific script
# I have had to edit the hosts file
# npm ci for the packages
# needed to add my aws credentials `aws configure`
# I needed to log into ecr with docker in order to pull the images
# ts-node needed to be install globally to run the copy-db-script
# Ran the copy db script so that the migrations were no longer an issue
# The work stack should now stand-up
