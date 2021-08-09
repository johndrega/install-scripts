#!/bin/bash

set -e
cd ~

sudo apt update

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt update

sudo apt install --assume-yes \
	build-essential \
	software-properties-common \
	cmake \
	sublime-merge \
	python3 \
	python3-pip \
	git \
	htop \
	tmux \
	redis-tools \
	wget

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";
unzip awscliv2.zip
sudo ./aws/install
cd ~

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
sudo mv nvim.appimage /opt/
cd /opt
sudo chmod u+x nvim.appimage
cd ~

sudo apt install --assume-yes docker-ce docker-ce-cli containerd.io
sudo groupadd docker
sudo usermod -aG docker ${USER}

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# This is failing to build at the moment
# ~/.cargo/bin/cargo install alacritty

cd /tmp
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

curl https://github.com/TylerBrock/saw/releases/download/v0.2.2/saw_0.2.2_linux_amd64.deb --output saw_0.2.2_linux_amd64.deb
sudo dpkg -i saw_0.2.2_linux_amd64.deb

# This could be a function of its own
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install code

curl https://dl.pstmn.io/download/latest/linux64 --ouput postman-linux-x64.tar.gz
sudo tar -xzf postman-linux-x64.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman

curl https://download-cdn.jetbrains.com/datagrip/datagrip-2021.2.tar.gz --output datagrip-2021.2.tar.gz
sudo tar -xzf datagrip-2021.2.tar.gz -C /opt
cd ~

# Install fnm, can maybe use a prompt to choose a node version
#	global install typscript for ts-node
curl -fsSL https://fnm.vercel.app/install | bash

# The following should have option
# prompt to enter things like: keys, email, userame
# prompt for a dotfiles repo (what happens if there're conflicts)

# prompts for aws config

# prompts for git config

# Clone my dotfiles repo

# Setup project and work folders

