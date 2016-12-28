#
# Cookbook Name:: lemp-server
# Recipe:: rollback
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app = search("aws_opsworks_app").first

newbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]}"
oldbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]-1}"

batch 'rollback_to_old_buil' do
  code <<-EOH
    mv /srv/www/current /srv/www/#{newbuild}-rollbacked-$(date)
    mv /srv/www/#{oldbuild} /srv/www/current
    EOH
  notifies :restart , service "nginx" , :immediately 
  notifies :restart , service "php5-fpm" , :immediately 
end