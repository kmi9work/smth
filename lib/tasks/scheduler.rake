desc "Clean vkusers"
task :clean_vkusers => :environment do
    puts "Cleaning vkusers..."
    Vkuser.clean
    puts "done."
end