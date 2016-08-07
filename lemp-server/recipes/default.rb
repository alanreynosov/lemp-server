#
# Cookbook Name:: lemp-server
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt'
include_recipe 'php'


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


package 'php5-fpm' do
	action :install
end


package ['php5-readline'] do
	action :install
end

package ['php5-mysql'] do
	action :install
end

service 'php5-fpm' do
	action [:enable,:start]
end


package 'mariadb-client' do
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
	action :reload
end