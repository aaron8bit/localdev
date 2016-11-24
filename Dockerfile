FROM ubuntu:16.04
MAINTAINER Aaron Albert <aaron8bit@gmail.com>

# Update and install basic ubuntu things
RUN apt-get update
RUN apt-get install -y git curl tmux

# Install pip
RUN apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv

# Install powerline
RUN pip install powerline-status
RUN git clone https://github.com/powerline/fonts.git
RUN fonts/install.sh
RUN echo "" >> ~/.bashrc
RUN echo "# Start powerline" >> ~/.bashrc
RUN echo ". /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh" >> ~/.bashrc

# Having trouble with oh-my-git fonts
#RUN apt-get install -y console-setup
#RUN git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~/.bashrc

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN echo "" >> ~/.bashrc
RUN echo "# Source rvm" >> ~/.bashrc
RUN echo "source /usr/local/rvm/scripts/rvm" >> ~/.bashrc
RUN source /usr/local/rvm/scripts/rvm
rvm install ruby-2.3.1
rvm --default use ruby-2.3.1
gem install bundler pry rspec guard rubocop

