#!/bin/bash

# ssh root@185.25.164.82
# sh deploy.sh

echo Hello, which branch you would like to deply?
read branch_name

if [ -z "$branch_name" ]
then
  branch_name=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  echo Default branch is $branch_name
  echo "\$branch_name is empty"
else
  echo $branch_name
  echo "\$branch_name is NOT empty"
fi
