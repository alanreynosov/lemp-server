#
# Cookbook Name:: nginx-cookbook
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'apt::default'
include_recipe 'php'
include_recipe 'nginx'
include_recipe 'mariadb::server'
include_recipe 'nginx-cookbook::firewall'


# directory "#{node[:nginx_document_root]}" do
#   owner "#{node[:nginx_user]}"
#   group "#{node[:nginx_group]}"
#   mode '0755'
#   action :create
# end

package ['php7.0-fpm'] do
  action :install
end

file '/etc/nginx/sites-enabled/default' do 
  action 'delete'
end

file '/etc/nginx/sites-enabled/000-default' do 
  action 'delete'
end

package ['php7.0-mysql'] do
	action :install
end

ifconfig "192.168.10.2" do
  device "enp0s8"
end

# cookbook_file "#{node[:nginx_document_root]}index.php" do
# 	source "index.php"
# 	mode "0644"
# end


template "/etc/nginx/sites-available/#{node[:nginx_host_name]}.conf" do
  source "serverblock.erb"	
end

link "/etc/nginx/sites-enabled/#{node[:nginx_host_name]}.conf" do
  to "/etc/nginx/sites-available/#{node[:nginx_host_name]}.conf"
end

service 'nginx' do
	action :restart
end

service 'php7.0-fpm' do
	action :reload
end
