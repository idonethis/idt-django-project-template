#!/bin/bash

set -e

main() {
    install_apt_packages
    config_postgres
    config_npm
    config_shell
    config_ssh
    config_apache_proxy
}

install_apt_packages() {
    apt-get update

    # this is to be able to manipulate apt repositories
    apt-get install -y software-properties-common python-software-properties

    # to get a recent nodejs, which bundles npm and nosejs-dev also
    add-apt-repository -y ppa:chris-lea/node.js

    apt-get update --fix-missing

    # bash syntax for arrays is a big strange, but that's all that's going on with the declare -a and ${packages[*]}
    declare -a packages=(
        # keep related things close to each other
        emacs23-nox vim-nox git zsh tree htop sqlite3 screen tmux lynx
        cachefilesd # for fast nfs
        apache2 libapache2-mod-wsgi
        postgresql-9.1 libpq-dev chkconfig

        python-dev python-psycopg2 python-imaging python-setuptools python-pip
        virtualenvwrapper
        libreadline6 libreadline6-dev ncurses-dev apt-file # without installing apt-file python's readline is unable to compile ???

        g++ make nodejs libfontconfig # the nodejs package includes npm and nodejs-dev, libfontconfig is a dependency of phantomjs
        ruby-compass libfssm-ruby
        rabbitmq-server libxml2-dev libxslt-dev
        ruby-json # for heroku toolbelt to not throw warnings about a more efficient json library
    )
    apt-get install -y ${packages[*]}
}

config_postgres() {
    # fix the default encoding, otherwise creating a db requires that we pass
    # template, locale, and encoding by hand and this can't be done easily for
    # tests.
    pg_dropcluster --stop 9.1 main
    pg_createcluster --start --encoding=UTF8 --locale=en_US.utf8 9.1 main
    sudo -u postgres createuser -drsw vagrant
    sudo -u vagrant createdb {{ project_name }}-dev
}

config_npm() { npm config set registry http://registry.npmjs.org/ --global; }

config_shell() { chsh -s `which zsh` vagrant; }

config_ssh() {
    # host_id_rsa.pub is put in place by a file provisioner in Vagrantfile
    cat /home/vagrant/.ssh/host_id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
}

config_apache_proxy() {
    a2enmod proxy_http
    cp /etc/apache2/sites-available/default{,.bk}
    cp /home/vagrant/{{ project_name }}/vagrant_conf/apache/proxy_site /etc/apache2/sites-available/default
    service apache2 restart
}

main
