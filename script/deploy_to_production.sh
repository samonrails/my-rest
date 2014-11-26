echo $(date  +"%T") 'source code sanity check:'
grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage  "TODO" .
grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage  "binding.pry" .

read -p "Press [Enter] to continue."

# echo 'snappea - deploy form local branch master'
# heroku maintenance:on --app snappea

echo $(date  +"%T") 'snappea - database snapshot'
heroku pgbackups:capture -a snappea --expire

echo $(date  +"%T") 'snappea - deploy code'
git push --force snappea-production master

echo $(date  +"%T") 'snappea - migrate database'
heroku run rake db:migrate --app snappea

echo $(date  +"%T") 'snappea - force restart the lazy dynos'
heroku restart --app snappea

echo $(date  +"%T") 'snappea - cleanup'
# heroku maintenance:off --app snappea
heroku ps --app snappea

echo $(date  +"%T") 'snappea - complete'
