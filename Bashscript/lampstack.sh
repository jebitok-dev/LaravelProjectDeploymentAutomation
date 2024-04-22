#!/bin/bash

git_url=${1}
homedir=/home/osboxes/git
project_dir='$(basename https://github.com/laravel/laravel)'

if [ -z "$1" ]; then 
    echo 'Error: Please provide a git repository URL. Usage: $0 <git_url>'
fi 

check_git_installation() {
    if command -v git &> /dev/null; then 
        echo 'Git is installed'
    else 
        echo 'Installing git' && sudo apt install git -y
    fi
}

install_lamp_packages() {
    echo 'Installing necesary Apache, MySQL and PHP packages'
    sudo apt update 
    sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql -y
}

configure_apache() {
    echo 'Configuring Apache Web Server'
    sudo systemctl start apache2
    sudo cp '${homedir}${project_dir}/000-default.conf' /etc/apache2/sites-available/000-default.conf
}

configure_mysql() {
    echo 'Configuring MySQL Server'
    sudo systemctl start mysql
    sudo mysql_secure_installation
}

create_dir() {
    if [[ -d $homedir ]]; then
        cd $homedir
        echo 'directory exists'
    else 
        mkdir $homedir && cd $homedir
        echo 'directory created'
    fi
}

clone_repository() {
    create_dir
    cd $homedir
    $project_dir
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

find_files() {
    fileCount=$(find '${homedir}${project_dir}' )
}

clone_repository ${git_url}

# ./deploy_script.sh https://github.com/yourusername/yourrepository.git
