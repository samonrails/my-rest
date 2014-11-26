echo $(date  +"%T") 'source code sanity check:'
grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage  "TODO" .
grep -ir --exclude-dir=log --exclude-dir=tmp --exclude-dir=script --exclude-dir=.git  --exclude-dir=coverage  "binding.pry" .

read -p "Press [Enter] to continue."

echo $(date  +"%T") 'snappea-demo - database snapshot'
heroku pgbackups:capture -a snappea-demo --expire

echo $(date  +"%T") 'snappea-demo - deploy code'
git push --force snappea-demo master

echo $(date  +"%T") 'snappea-demo - migrate database'
heroku run rake db:migrate --app snappea-demo

echo $(date  +"%T") 'snappea-demo - force restart the lazy dynos'
heroku restart --app snappea-demo

echo $(date  +"%T") 'snappea-demo - cleanup'
heroku ps --app snappea-demo

echo $(date  +"%T") 'snappea-demo - complete'
