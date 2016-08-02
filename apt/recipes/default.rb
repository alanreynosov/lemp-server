#
# Cookbook Name:: apt
# Recipe:: default
#
# Copyright 2016, ICONMEDIOS
#
# All rights reserved - Do Not Redistribute
#


execute 'apt-get update' do
	command 'apt-get update'
end