#!/bin/bash

git_url=${1}
homedir=$HOME/git
project_dir=$(basename $git_url | cut -d '/' -f -4 | cut '/' -f 5)

if [ -z "$1" ]; then 
    echo 'Error: Please provide a git repository URL. Usage: $0 <git_url>'
    exit 1
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

    # Check for JAVA_INSTALLED environment variable
    if [[ ! -z "${JAVA_INSTALLED}" ]]; then
        echo 'Java is assumed to be pre-installed (based on JAVA_INSTALLED environment variable)'
    else
        echo 'Installing Java (adjust version as needed)'
        sudo apt install default-jdk -y
    fi

    sudo apt install apache2 mysql-server php libapache2-mod-php php-mysql -y
}

configure_apache() {
    echo 'Configuring Apache Web Server'
    sudo /etc/init.d/apache2 start
    sudo cp `${homedir}${project_dir}/000-default.conf` /etc/apache2/sites-available/000-default.conf
}

configure_mysql() {
    echo 'Configuring MySQL Server'
    sudo /etc/init.d/mysql start
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
    if [[ -d $project_dir && -n $(ls -A $project_dir) ]]; then 
        echo 'Directory exists and is not empty. Skipping cloning process'
    elif [[ -d $project_dir ]]; then
        echo "Directory '$project_dir' exists, but it's empty. Updating repository"
        cd $project_dir
        git pull origin main
    else
        echo 'Cloning repository...'
        git clone $git_url
    fi
}

deploy_lampstack() {
    check_git_installation
    install_lamp_packages
    configure_apache
    configure_mysql
    clone_repository
}

deploy_lampstack