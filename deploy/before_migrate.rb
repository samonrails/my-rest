rails_env = new_resource.environment["RAILS_ENV"]

Chef::Log.info("Precompiling assets for RAILS_ENV=#{rails_env}...")

execute "rake assets:precompile" do
  cwd release_path
  environment "RAILS_ENV" => rails_env
  command "bundle exec rake assets:precompile"
end

if rails_env == "experimental"
  execute "staging dump" do
    staging_db = node['deploy']['snappea']['staging_db']
    environment('PGPASSWORD' => staging_db['password'])
    Chef::Log.info("DB Dumping Staging.")
    cwd "#{release_path}/db"
    command "pg_dump -Fp --no-acl --no-owner -h #{staging_db['host']} -U #{staging_db['username']} #{staging_db['database']} > staging.sql"
  end
  execute "staging data load" do
    local_db = node['deploy']['snappea']['database']
    environment('PGPASSWORD' => local_db['password'])
    Chef::Log.info("Restoring staging DB to local copy")
    cwd "#{release_path}/db"
    command "psql -h #{local_db['host']} -U #{local_db['username']} -d #{local_db['database']} -f staging.sql"
  end
end
