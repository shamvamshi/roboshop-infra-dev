#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/shamvamshi/ansible-roboshop-roles.git -e component=$1 main.yaml # URL
