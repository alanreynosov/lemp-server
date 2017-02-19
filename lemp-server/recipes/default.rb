#
# Cookbook Name:: lemp-server
# Recipe:: default
# Author : Iconmedios 
# Copyright (c) 2016 The Authors, All Rights Reserved.
# php5-curl, php5-mysql, php5-gd

include_recipe 'apt'

if node.environment != "kitchen" 
  app = search("aws_opsworks_app").first
  Chef::Log.info("********** The app's short name is '#{app['app_source']['url']}' **********")
  Chef::Log.info("********** The app's URL is '#{app['app_source']['url']}' **********")

  file '/root/.ssh/id_rsa' do
  content "#{app['app_source']['ssh_key']}"
  mode '600'
  end

else

  package 'mysql-server'
  service 'mysql-server'  

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

appdata = app.to_yaml


package 'python-pip' 
package 'curl' 
package 'nginx'
package "php5" 
package 'php5-common' 
package 'php5-cli'
package 'php5-json'
package 'php5-gd'
package 'php5-curl'
package 'php5-memcached'
package 'memcached'
package 'php5-fpm'
package 'php5-readline'
package 'php5-mysql'
package 'mysql-client'
package 'vim'
package 'zip'

bash 'install_aws_cli' do
  code <<-EOH
    pip install awscli
    EOH
end

bash 'install_ngxtop' do
  code <<-EOH
    pip install ngxtop
    EOH
end

bash 'install_wp_cli' do
  cwd '/tmp'
  code <<-EOH
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
    chmod +x wp-cli.phar;
    mv wp-cli.phar /usr/local/bin/wp;
    EOH
    not_if { File.exist?("/srv/www/wp-cli.phar") }
end

bash 'install_wp_cli_supercache' do
  cwd '/tmp'
  code <<-EOH
  wp package install https://github.com/wp-cli/wp-super-cache-cli.git --allow-root
  EOH
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

template "/etc/nginx/nginx.conf" do
  source "nginx.conf" 
  atomic_update true
end

template "/etc/php5/fpm/php.ini" do
  source "php.ini" 
  atomic_update true
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

directory "#{node[:deployment_path]}" do
   owner "#{node[:nginx_user]}"
   group "#{node[:nginx_group]}"
   mode '0755'
   action :create
end



