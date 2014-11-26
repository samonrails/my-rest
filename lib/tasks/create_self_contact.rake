
desc "Create self contact for the existing users"
task :create_self_contact => :environment do
  a = 0
  User.all.each do |user|
    unless user.self_contact?
      if user.name.present?
        user.create_self_contact 
        a += 1
      end
    end
  end
    puts "Contact created for #{a} users"
end