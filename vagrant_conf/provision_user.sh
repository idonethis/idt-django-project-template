#!/bin/bash

set -e

main() {
    install_oh_my_zsh
    config_virtualenv
    config_heroku
    init_db
    compile_sass
}

install_oh_my_zsh() {
    if [ ! -d ~/.oh-my-zsh ]; then
        git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    else
        git -C ~/.oh-my-zsh pull
    fi
    ln -sf /home/vagrant/{{ project_name }}/vagrant_conf/user/ysrz.zsh-theme /home/vagrant/.oh-my-zsh/themes/ysrz.zsh-theme
    ln -sf /home/vagrant/{{ project_name }}/vagrant_conf/user/dot.zshrc /home/vagrant/.zshrc
}

config_virtualenv() {
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
	[ ! -d /home/vagrant/.virtualenvs/{{ project_name }} ] && mkvirtualenv {{ project_name }} &&
    _pip=/home/vagrant/.virtualenvs/{{ project_name }}/bin/pip
    $_pip install -r {{ project_name }}/requirements.txt
}

init_db() {
    cd ~/{{ project_name }}
    _python=/home/vagrant/.virtualenvs/{{ project_name }}/bin/python
    foreman run $_python {{ project_name }}/manage.py migrate
}

config_heroku() {
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    # without these using foreman to run the webserver throws an error, seems like a bug on their side:
    sudo gem install foreman
    # e.g. for re-deploying without pushing
    heroku plugins:install https://github.com/heroku/heroku-repo.git
    # for reading and writing heroku environment variables to / from an env file
    heroku plugins:install https://github.com/ddollar/heroku-config.git
    heroku plugins:install git://github.com/heroku/heroku-pg-extras.git
}

# sourcing this script as "source vagrant_conf/provision_user.sh --source-only" will
# make all functions available to the caller and avoid execution
if [ "${1}" != "--source-only" ]; then
    main
fi
