#!/bin/bash

# ssh root@185.25.164.82
# sh deploy.sh

echo Hello, which branch you would like to deply?
read branch_name

if [ -n "$branch_name" ]; then
  echo ""
else
  cd /var/www/talent/code
  branch_name=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
fi

echo Branch is $branch_name
