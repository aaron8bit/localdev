FROM ubuntu:16.04
MAINTAINER Aaron Albert <aaron8bit@gmail.com>

# Update and install basic ubuntu things
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get upgrade -y
# Not sure I like this idea
#RUN apt-get install -y apt-utils
RUN apt-get install -y git git-flow curl tmux sudo vim unzip zsh

# Use zsh while running commands to avoid unexpected problems related to sh
SHELL ["/bin/zsh", "-c"]

RUN useradd -u 1000 -g 100 -G 27 -c Aaron -d /home/aja -s /bin/zsh -m aja && \
  echo "aja ALL=NOPASSWD:ALL" >> /etc/sudoers

# Install pip
RUN apt-get install -y python-pip python-dev build-essential && \
  pip install --upgrade pip && \
  pip install --upgrade virtualenv

# Install maven
RUN apt-get install -y maven

# Everything else should be non-root
USER aja

# Copy a bunch of installation material for later use
COPY install_rvm.sh install_ohmyzsh.sh aaron8bit.zsh-theme gradle-3.3-all.zip /home/aja/

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# why does ruby hate zsh? bash works fine...
RUN cat /home/aja/install_rvm.sh | bash -s stable --ruby && \
  echo "# Source rvm" >> ~aja/.zshrc && \
  echo "source /home/aja/.rvm/scripts/rvm" >> ~aja/.zshrc && \
  rm /home/aja/install_rvm.sh

# Install and configure ruby-2.3.1
RUN source /home/aja/.rvm/scripts/rvm && \
  rvm install ruby-2.3.1 && \
  rvm --default use ruby-2.3.1 && \
  gem install bundler pry rspec guard rubocop && \
  rvm get stable --auto-dotfiles

# Install gradle
# This should check the download, md5 or something
RUN unzip /home/aja/gradle-3.2.1-all.zip -d /home/aja/ && \
  echo "# Gradle config" >> ~aja/.zshrc && \
  echo "export GRADLE_HOME=~aja/gradle-3.2.1" >> ~aja/.zshrc && \
  echo "export PATH=$PATH:$GRADLE_HOME/bin" >> ~aja/.zshrc && \
  rm /home/aja/gradle-3.2.1-all.zip

# the install exits with 1 but seems to work fine
RUN /home/aja/install_ohmyzsh.sh; \
  mv /home/aja/aaron8bit.zsh-theme ~/.oh-my-zsh/themes/ && \
  sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="aaron8bit"/g' ~/.zshrc && \
  sed -i 's/# CASE_SENSITIVE="true"/CASE_SENSITIVE="true"/g' ~/.zshrc && \
  rm /home/aja/install_ohmyzsh.sh

