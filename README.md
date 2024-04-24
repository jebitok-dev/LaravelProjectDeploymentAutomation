# ALTSchool Cloud Engineering Exam 

## Master: Bash Script
In this project we were writing a bash script to allow us to clone the Laravel official repository, install all necessary LAMP packages, configure Apache and MySQL, then successfully clone the repository. 

### How to execute the Bash Script 
````
$ chmod +x ./Bashscript/lampstack.sh 
$ ./Bashscript/lampstack.sh https://github.com/laravel/laravel
````

## Slave: Ansible Playbook

The Ansible playbook is meant to execute the bash script and automate everyday at 12 am. 