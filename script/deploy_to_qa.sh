echo $(date  +"%T") 'snappea-qa - select deployment branch.'
read branch_to_deploy
set -e

echo $(date  +"%T") 'snappea-qa - production & staging database snapshot'
heroku pgbackups:capture --app snappea --expire
heroku pgbackups:capture --app snappea-qa --expire

echo $(date  +"%T") 'snappea-qa - Restoring production database to staging'
heroku maintenance:on --app snappea-qa
heroku pg:reset DATABASE_URL --app snappea-qa --confirm snappea-qa
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-qa --confirm snappea-qa

read -p "Go purge the Braintree Sandbox. Press [Enter] to continue."

echo $(date  +"%T") 'snappea-qa - Reset braintree data in postgres.'
heroku run rake purge_braintree_accounts  --app snappea-qa 
heroku run rake create_braintree_accounts --app snappea-qa

echo $(date  +"%T") 'snappea-qa - deploy code'
git push --force snappea-qa $branch_to_deploy:master

echo $(date  +"%T") 'snappea-qa - migrate database'
heroku run rake db:migrate --app snappea-qa

echo $(date  +"%T") 'snappea-qa - force restart the lazy dynos'
heroku restart --app snappea-qa

echo $(date  +"%T") 'snappea-qa - cleanup'
heroku maintenance:off --app snappea-qa
heroku ps --app snappea-qa

echo $(date  +"%T") 'snappea-qa - complete'
