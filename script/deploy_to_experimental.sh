echo $(date  +"%T") 'snappea-experimental($envbets) - deploy to what phonetic:'
while read env && [ -z "$env" ]; do :; done

echo $(date  +"%T") 'snappea-experimental-'env' type in the branch name to be deployed:'
while read branch_to_deploy && [ -z "$branch_to_deploy" ]; do :; done
set -ex

heroku pgbackups:capture --app snappea-experimental-$env --expire

heroku maintenance:on --app snappea-experimental-$env
heroku pg:reset DATABASE_URL --app snappea-experimental-$env --confirm snappea-experimental-$env
heroku pgbackups:restore DATABASE `heroku pgbackups:url --app snappea` --app snappea-experimental-$env --confirm snappea-experimental-$env

heroku run rake purge_braintree_accounts  --app snappea-experimental-$env 
heroku run rake create_braintree_accounts --app snappea-experimental-$env

git push --force snappea-experimental-$env $branch_to_deploy:master

heroku run rake db:migrate --app snappea-experimental-$env

heroku restart --app snappea-experimental-$env

heroku maintenance:off --app snappea-experimental-$env
heroku ps --app snappea-experimental-$env
