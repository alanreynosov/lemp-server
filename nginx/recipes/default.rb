#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2016, ICONMEDIOS
#
# All rights reserved - Do Not Redistribute
#

package 'nginx' do
	action :install
end

service 'nginx' do
	action [:enable,:start]
end
