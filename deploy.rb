# _your_login_ - Поменять на ваш логин в панели управления
# _your_project_ - Поменять на имя вашего проекта
# _your_server_ - Поменять на имя вашего сервера (Указано на вкладке "FTP и SSH" вашей панели управления)
# set :repository - Установить расположение вашего репозитория
# У вас должна быть настроена авторизация ssh по сертификатам

set :application, "aaa"
set :repository,  "ssh://hosting_your_login_@_your_server_.locum.ru/home/hosting_your_login_/_your_project_.git"

dpath = "/home/hosting_your_login/projects/_your_project_"

set :user, "hosting_your_login"
set :use_sudo, false
set :deploy_to, dpath

set :scm, :git

role :web, "_your_server_.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "_your_server_.locum.ru"                          # This may be the same as your `Web` server
role :db,  "_your_server_.locum.ru", :primary => true # This is where Rails migrations will run

after "deploy:update_code", :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
set :unicorn_conf, "/etc/unicorn/_your_project_._your_login_.rb"
set :unicorn_pid, "/var/run/unicorn/_your_project_._your_login_.pid"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "#{unicorn_rails} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_rails} -Dc #{unicorn_conf}"
  end
end
