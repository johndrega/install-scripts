cd ~
git clone https://github.com/nvm-sh/nvm.git .nvm
git checkout v0.39.1
. ./nvm.sh

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install 12.22.1

npm i -g typescript
npm i -g ts-node
