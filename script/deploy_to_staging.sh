echo $(date  +"%T") 'snappea-staging - type in the branch name to be deployed:'
while read branch_to_deploy && [ -z "$branch_to_deploy" ]; do :; done
set -e

# echo $(date  +"%T") 'source code sanity check:'
# grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage  "TODO" .
# grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage "binding.pry" .

# read -p "Press [Enter] to continue."

echo $(date  +"%T") 'snappea-staging - production & staging database snapshot'
heroku pgbackups:capture --app snappea --expire
heroku pgbackups:capture --app snappea-staging --expire

echo $(date  +"%T") 'snappea-staging - Restoring production database to staging'
heroku maintenance:on --app snappea-staging
heroku pg:reset DATABASE_URL --app snappea-staging --confirm snappea-staging
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-staging --confirm snappea-staging

# read -p "Go purge the Braintree Sandbox. Press [Enter] to continue."

echo $(date  +"%T") 'snappea-staging - Reset braintree data in postgres.'
heroku run rake purge_braintree_accounts  --app snappea-staging 
heroku run rake create_braintree_accounts --app snappea-staging

echo $(date  +"%T") 'snappea-staging - deploy code'
git push --force snappea-staging $branch_to_deploy:master

echo $(date  +"%T") 'snappea-staging - migrate database'
heroku run rake db:migrate --app snappea-staging

echo $(date  +"%T") 'snappea-staging - force restart the lazy dynos'
heroku restart --app snappea-staging

echo $(date  +"%T") 'snappea-staging - cleanup'
heroku maintenance:off --app snappea-staging
heroku ps --app snappea-staging

echo $(date  +"%T") 'snappea-staging - complete'
