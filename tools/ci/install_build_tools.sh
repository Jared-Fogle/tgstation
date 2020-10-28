#!/bin/bash
set -euo pipefail

source dependencies.sh

source ~/.nvm/nvm.sh
nvm install $NODE_VERSION
nvm use $NODE_VERSION
npm install --global yarn

pip3 install --user PyYaml
pip3 install --user beautifulsoup4

curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash
export PHPENV_ROOT="/home/runner/.phpenv"
export PATH="${PHPENV_ROOT}/bin:${PATH}"
eval "$(phpenv init -)"
phpenv global $PHP_VERSION
