#
# Cookbook Name:: lemp-server
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.




if node.environment != "kitchen" 
  app = search("aws_opsworks_app").first
  Chef::Log.info("********** The app's short name is '#{app['app_source']['url']}' **********")
  Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")

  file '/root/.ssh/id_rsa' do
  content "#{app['app_source']['ssh_key']}"
  mode '600'
  end

else
  
  package 'git'

  directory '/root/.ssh/' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
  
  app = node["app"]

  template '/root/.ssh/id_rsa' do
    source "gitkey.erb"
    mode '600'
  end
end

log app[:environment][:AWS_ACCESS_KEY_ID]

newbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]}"
old_number = app[:environment][:build_number].to_i-1.to_i
oldbuild = "#{app[:environment][:build]}#{old_number}"

bash 'download_build' do
  code <<-EOH
    export AWS_ACCESS_KEY_ID=#{app[:environment][:AWS_ACCESS_KEY_ID]}; export AWS_SECRET_ACCESS_KEY=#{app[:environment][:AWS_SECRET_ACCESS_KEY]};
    aws s3 cp s3://#{app[:environment][:build_bucket]}/#{newbuild}.tar.gz /srv/www/
    EOH
    not_if { File.exist?("/srv/www/current/#{newbuild}.tar.gz") }
end

bash 'move_old_document_root' do
  code <<-EOH
    mv /srv/www/current /srv/www/#{oldbuild}
  EOH
  not_if { !File.exist?("/srv/www/current") }
end

bash 'unzip_build' do
  code <<-EOH
    tar -xvf /srv/www/#{newbuild}.tar.gz -C /srv/www/
    EOH
  notifies :run, 'execute[chown-data-www]', :immediately
end


execute "chown-data-www" do
  command "chown -R www-data:www-data /srv/www/current/wp-content"
  user "root"
  action :run
end

bash 'remove_old' do
  code <<-EOH
    rm -rf /srv/www/#{oldbuild}
  EOH
  not_if { !File.exist?("/srv/www/#{oldbuild}") }
end

bash 'remove_old' do
  code <<-EOH
    rm -rf /srv/www/current/wp-content/cache/wp-cache-*;
    rm -rf /srv/www/current/wp-content/cache/supercache/*;
  EOH
end

file "/srv/www/current/status.php" do
  content "ok"
end

template '/srv/www/current/wp-config.php' do
  source "wp-config.php.erb"
  variables config: app[:environment]
  atomic_update true
end

execute "chown-data-www" do
  command "chown -R www-data:www-data /srv/www/current/wp-content"
  user "root"
  action :run
end

service 'nginx' do
  action :restart
end

service 'php5-fpm' do
  action :stop
end
service 'php5-fpm' do
  action :start
end




