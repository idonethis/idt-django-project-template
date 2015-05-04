#!/bin/bash

set -e

main() {
    install_oh_my_zsh
    config_virtualenv
    install_heroku_toolbelt
    init_db
    compile_sass
}

install_oh_my_zsh() {
    if [ ! -d ~/.oh-my-zsh ]; then
        git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    else
        git -C ~/.oh-my-zsh pull
    fi
    ln -sf /home/vagrant/idonethis/vagrant_conf/user/ysrz.zsh-theme /home/vagrant/.oh-my-zsh/themes/ysrz.zsh-theme
    ln -sf /home/vagrant/idonethis/vagrant_conf/user/dot.zshrc /home/vagrant/.zshrc
}

config_virtualenv() {
    source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
	[ ! -d /home/vagrant/.virtualenvs/idonethis ] && mkvirtualenv idonethis &&
    _pip=/home/vagrant/.virtualenvs/idonethis/bin/pip
    $_pip install -r idonethis/deploy/requirements.txt
}

init_db() {
    cd ~/idonethis
    _python=/home/vagrant/.virtualenvs/idonethis/bin/python
    foreman run $_python manage.py migrate
    foreman run $_python manage.py dump_team_data --database=readonly witc
    foreman run $_python manage.py loaddata witc_team_data.json
    rm witc_team_data.json
}

install_heroku_toolbelt() {
    wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh
    # without these using foreman to run the webserver throws an error, seems like a bug on their side:
    sudo gem install foreman
    # e.g. for re-deploying without pushing
    heroku plugins:install https://github.com/heroku/heroku-repo.git
    # for reading and writing heroku environment variables to / from an env file
    heroku plugins:install https://github.com/ddollar/heroku-config.git
    heroku plugins:install git://github.com/heroku/heroku-pg-extras.git
}

compile_sass(){
    cd ~/idonethis
    compass compile
}

# sourcing this script as "source vagrant_conf/provision_user.sh --source-only" will
# make all functions available to the caller and avoid execution
if [ "${1}" != "--source-only" ]; then
    main
fi
