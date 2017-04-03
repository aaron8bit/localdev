#!/bin/bash

if [[ ! -f install_rvm.sh ]]; then
  echo "Pulling rvm install script"
  curl -fsSL https://get.rvm.io -o install_rvm.sh
fi
chmod 755 install_rvm.sh

if [[ ! -f gradle-3.3-all.zip ]]; then
  echo "Pulling gradle binaries"
  curl -fsSL https://services.gradle.org/distributions/gradle-3.3-all.zip -o gradle-3.3-all.zip
fi

if [[ ! -f install_ohmyzsh.sh ]]; then
  echo "Pulling oh-my-zsh install script"
  curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -o install_ohmyzsh.sh
fi
chmod 755 install_ohmyzsh.sh

