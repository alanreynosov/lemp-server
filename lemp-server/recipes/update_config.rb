#
# Cookbook Name:: lemp-server
# Recipe:: update_config
#
# Copyright (c) 2017 The Authors, All Rights Reserved.

template "/etc/nginx/sites-available/#{node[:nginx_host_name]}.conf" do
  source "serverblock2.erb"	
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