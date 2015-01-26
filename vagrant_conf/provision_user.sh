#!/bin/bash

set -e

main() {
    install_oh_my_zsh
    config_virtualenv
    config_heroku
    init_db
}

install_oh_my_zsh() {
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    ln -s /home/vagrant/{{project_name }}/vagrant_conf/user/ysrz.zsh-theme /home/vagrant/.oh-my-zsh/themes/ysrz.zsh-theme
    rm /home/vagrant/.zshrc
    ln -s /home/vagrant/{{project_name }}/vagrant_conf/user/dot.zshrc /home/vagrant/.zshrc
}

config_virtualenv() {
    source /etc/bash_completion.d/virtualenvwrapper
    mkvirtualenv {{ project_name}} && # not sure why this fails without the &&
    _pip=/home/vagrant/.virtualenvs/{{ project_name }}/bin/pip
    /home/vagrant/.virtualenvs/{{ project_name }}/bin/easy_install readline
    $_pip install --upgrade pip
    $_pip install -r {{ project_name }}/requirements.txt
}

config_heroku() {
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    # without these using foreman to run the webserver throws an error, seems like a bug on their side:
    sudo apt-get install -y ruby-rvm
    sudo gem install foreman
    # e.g. for re-deploying without pushing
    heroku plugins:install https://github.com/heroku/heroku-repo.git
    # for reading and writing heroku environment variables to / from an env file
    heroku plugins:install https://github.com/ddollar/heroku-config.git
    heroku plugins:install git://github.com/heroku/heroku-pg-extras.git
    cp env.default .env
}

init_db() {
    _python=/home/vagrant/.virtualenvs/{{ project_name }}/bin/python
    $_python /home/vagrant/{{ project_name }}/{{ project_name }}/manage.py migrate
}

main
