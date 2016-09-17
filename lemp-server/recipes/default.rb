#
# Cookbook Name:: lemp-server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# php5-curl, php5-mysql, php5-gd

app = search("aws_opsworks_app").first
Chef::Log.info("********** The app's short name is '#{app['app_source']['url']}' **********")
Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")


appdata = app.to_yaml

file '/home/ubuntu/.ssh/id_rsa' do
 	content "#{app['app_source']['ssh_key']}"
 	owner 'root'
 	group 'root'
 	mode '600'
end

file "/home/ubuntu/git_wrapper.sh" do
  owner "root"
  mode "0755"
  content "#!/bin/sh\nexec /usr/bin/ssh -i /home/ubuntu/.ssh/id_rsa \"$@\""
end

directory "#{node[:nginx_document_root]}" do
   owner "#{node[:nginx_user]}"
   group "#{node[:nginx_group]}"
   mode '0755'
   action :create
end

cookbook_file "#{node[:nginx_document_root]}index.php" do
 	source "index.php"
 	mode "0644"
 end

 deploy 'private_repo' do
  symlink_before_migrate.clear
  create_dirs_before_symlink.clear
  purge_before_symlink.clear
  symlinks.clear
  repo "#{app['app_source']['url']}"
  user 'root'
  deploy_to "#{node[:deployment_path]}"
  ssh_wrapper '/home/ubuntu/git_wrapper.sh'
  action :deploy
end

package 'nginx' do
	action 'install'
end


package "php5" do
  action 'install'
end

package ['php5-common'] do
	action :install
end

package ['php5-cli' ] do
	action :install
end

package ['php5-json'] do
  action :install
end

package ['php5-gd'] do
	action :install
end


package 'php5-fpm' do
	action :install
end


package ['php5-readline'] do
	action :install
end

package ['php5-mysql'] do
	action :install
end

package 'mysql-client' do
	action :install
end

file '/etc/nginx/sites-enabled/default' do 
  action 'delete'
end

file '/etc/nginx/sites-enabled/000-default' do 
  action 'delete'
end

package ['php5-mysql'] do
	action :install
end

template "/etc/nginx/sites-available/#{node[:nginx_host_name]}.conf" do
  source "serverblock2.erb"	
end

link "/etc/nginx/sites-enabled/#{node[:nginx_host_name]}.conf" do
  to "/etc/nginx/sites-available/#{node[:nginx_host_name]}.conf"
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