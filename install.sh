#! /bin/bash

set -e
cd ~

sudo apt update
sudo apt-get install --assume-yes \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    build-essential \
    software-properties-common \
    cmake \
    python3 \
    python3-pip \
    git \
    htop \
    tmux \
    rofi \
    redis-tools \
    wget

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#sudo apt-cache policy docker-ce
sudo apt update
sudo apt install --assume-yes docker-ce docker-ce-cli containerd.io docker-compose
sudo usermod -aG docker ${USER}

sudo apt install --assume-yes \
    sublime-merge \

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

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cd /tmp
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output google-chrome-stable_current_amd64.deb
sudo apt install --assume-yes ./google-chrome-stable_current_amd64.deb

curl -LO https://github.com/TylerBrock/saw/releases/download/v0.2.2/saw_0.2.2_linux_amd64.deb
sudo dpkg -i saw_0.2.2_linux_amd64.deb

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
sudo apt update
sudo apt install --assume-yes code

curl https://dl.pstmn.io/download/latest/linux64 --output postman-linux-x64.tar.gz
sudo tar -xzf postman-linux-x64.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman

curl https://download-cdn.jetbrains.com/datagrip/datagrip-2021.2.tar.gz --output datagrip-2021.2.tar.gz
sudo tar -xzf datagrip-2021.2.tar.gz -C /opt
cd ~

curl -fsSL https://fnm.vercel.app/install | bash

# Install zsh and oh-my-zsh
sudo apt-get install --assume-yes zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# This is failing to build at the moment
#~/.cargo/bin/cargo install alacritty

sudo apt-get install --assume-yes xmonad xmobar libghc-xmonad-contrib-dev feh

# Ensure that this is run in the home directory
git init .
git remote add origin https://github.com/johndrega/dotfiles.git
git fetch
git reset --hard origin/master

# Below here needs to be done from within zsh
# make a second script
#source ~/.zshrc

#fnm install 15.12.0
#fnm use 15.12.0

#npm i -g typescript
#npm i -g ts-node

#echo "All done"
