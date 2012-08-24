desc "Clean vkusers"
task :clean_vkusers => :environment do
    puts "Cleaning vkusers..."
    Vkuser.clean
    puts "done."
    #clean dmp_admin_dmp_request_vkusers
end