echo 'What heroku app database would you like to sync to your local environment?'
echo '--------------------------------------------------------------------------------'
read app_name

echo 'What is your local db user?'
echo '--------------------------------------------------------------------------------'
read user_name


# Take a snappea snapshot and download it
heroku pgbackups:capture --expire --app $app_name
curl -o tmp/latest.dump `heroku pgbackups:url --app $app_name`

# Setup local db
rake db:drop
rake db:create

# Load databse into local db
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user_name -d snappea_development tmp/latest.dump

rake purge_braintree_accounts
rake create_braintree_accounts

# Clean up
rm -f tmp/latest.dump
