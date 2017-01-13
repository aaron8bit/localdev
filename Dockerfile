FROM ubuntu:16.04
MAINTAINER Aaron Albert <aaron8bit@gmail.com>

# Use bash to avoid unexpected problems related to sh
SHELL ["/bin/bash", "-c"]

# Update and install basic ubuntu things
RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get upgrade -y
RUN apt-get install -y git git-flow
RUN apt-get install -y curl tmux sudo vim unzip
RUN useradd -u 1000 -g 100 -G 27 -c Aaron -d /home/aja -s /bin/bash -m aja
RUN echo "aja ALL=NOPASSWD:ALL" >> /etc/sudoers

# Install pip
RUN apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip && \
pip install --upgrade virtualenv

# Install powerline
RUN pip install powerline-status && \
git clone https://github.com/powerline/fonts.git && \
fonts/install.sh && \
rm -rf fonts

# Set up powerline for root user
RUN echo "" >> ~/.bashrc && \
echo "# Start powerline" >> ~/.bashrc && \
echo ". /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh" >> ~/.bashrc

# Install maven
RUN apt-get install -y maven

# Everything else should be non-root
USER aja

# Set up powerline for non-root user
RUN echo "" >> ~/.bashrc && \
echo "# Start powerline" >> ~/.bashrc && \
echo ". /usr/local/lib/python2.7/dist-packages/powerline/bindings/bash/powerline.sh" >> ~/.bashrc

# Having trouble with oh-my-git fonts
# FIGURE THIS OUT LATER
#RUN apt-get install -y console-setup
#RUN git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && echo source ~/.oh-my-git/prompt.sh >> ~aja/.bashrc

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN echo "# Source rvm" >> ~aja/.bashrc && \
echo "source /home/aja/.rvm/scripts/rvm" >> ~aja/.bashrc

# Install and configure ruby-2.3.1
RUN source /home/aja/.rvm/scripts/rvm && \
      rvm install ruby-2.3.1 && \
      rvm --default use ruby-2.3.1 && \
      gem install bundler pry rspec guard rubocop
#RUN rvm get stable --auto-dotfiles

# Install gradle
# This should check the download, md5 or something
RUN curl -L https://services.gradle.org/distributions/gradle-3.3-all.zip -o /tmp/gradle-3.2.1-all.zip
RUN unzip /tmp/gradle-3.2.1-all.zip -d /home/aja/ && \
echo "# Gradle config" >> ~aja/.bashrc && \
echo "export GRADLE_HOME=~aja/gradle-3.2.1" >> ~aja/.bashrc && \
echo "export PATH=$PATH:$GRADLE_HOME/bin" >> ~aja/.bashrc

