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
RAILS_ENV=production bundle exec rails assets:precompile
passenger-config restart-app .
# rvmsudo passenger-config restart-app
echo Deployment Completed! Successfully deployed $branch_name

# -----------------------------------------------------------------------------
# v2

#!/bin/bash
cd /var/www/talent/code

echo Hello, which branch you would like to deply?
read branch_name

if [ -n "$branch_name" ]; then
  echo Deploying $branch_name, please wait.....
else
  branch_name=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
  echo Deploying current branch $branch_name, please wait.....
fi

echo
git fetch origin
git checkout $branch_name
git pull origin $branch_name
RAILS_ENV=production bundle exec rails db:migrate
RAILS_ENV=production bundle exec rails assets:precompile
passenger-config restart-app .
echo Deployment Completed! Successfully deployed $branch_name
