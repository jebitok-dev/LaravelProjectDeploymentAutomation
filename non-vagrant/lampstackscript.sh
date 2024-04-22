#!/bin/bash

git_url=${1}
homedir=$HOME/git
project_dir=$(basename https://github.com/laravel/laravel)

if [ -z "$1" ]; then 
    echo 'Error: Please provide a git repository URL. Usage: $0 <git_url>'
    exit 1
fi 

check_git_installation() {
    if command -v git &> /dev/null; then 
        echo 'Git is installed'
    else 
        echo 'Installing git' && brew install git
    fi
}

install_lamp_packages() {
    echo 'Installing necessary Apache, MySQL and PHP packages'
    brew update
    brew install apache2 mysql php
    # macOS comes with Apache installed, so you may not need to start it manually
}

configure_apache() {
    echo 'Configuring Apache Web Server'
    sudo cp "${homedir}/${project_dir}/000-default.conf" /etc/apache2/sites-available/000-default.conf
    # You may need to adjust Apache configuration files as per macOS directory structure
}

configure_mysql() {
    echo 'Configuring MySQL Server'
    sudo brew services start mysql
    sudo mysql_secure_installation
}

create_dir() {
    if [[ -d $homedir ]]; then
        cd $homedir
        echo 'Directory exists'
    else 
        mkdir $homedir && cd $homedir
        echo 'Directory created'
    fi
}

clone_repository() {
    create_dir
    cd $homedir
    check_git_repository
    if [[ -d $project_dir ]]; then 
        echo 'Directory exists, updating repository'
        cd $project_dir
        git pull origin main
    else
        echo 'Cloning repository'
        git clone $git_url
    fi
}

deploy_script() {
    check_git_installation
    install_lamp_packages
    configure_apache
    configure_mysql
    clone_repository
}

deploy_script