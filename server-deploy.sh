#!/bin/bash
# Ask the user for their name

echo Hello, which branch you would like to deply?
read branch_name

branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo $branch

cd /var/www/talent/code
git fetch origin
echo Deploying $branch_name, please wait.....
git checkout $branch_name
git pull origin $branch_name
RAILS_ENV=production bundle exec rails db:migrate
rvmsudo passenger-config restart-app
echo Deployment Completed! Successfully deployed $branch_name
