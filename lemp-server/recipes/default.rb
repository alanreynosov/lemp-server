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

file '/tmp/dumpconf' do
  content appdata
end

package 'python-pip' 
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

file '/root/.ssh/config' do
  content "Host *
    StrictHostKeyChecking no
  "
  mode "0400"
end

file "/root/git_wrapper.sh" do
  mode "0755"
  content "#!/bin/sh\nexec /usr/bin/ssh -i /root/.ssh/id_rsa \"$@\""
end

directory "#{node[:deployment_path]}" do
   owner "#{node[:nginx_user]}"
   group "#{node[:nginx_group]}"
   mode '0755'
   action :create
end

#  deploy 'private_repo' do
#   symlink_before_migrate.clear
#   create_dirs_before_symlink.clear
#   purge_before_symlink.clear
#   symlinks.clear
#   repo "#{app['app_source']['url']}"
#   deploy_to "#{node[:deployment_path]}"
#   ssh_wrapper '/root/git_wrapper.sh'
#   action :deploy
#   user  'root'
#   branch "master"
#   notifies :run, 'execute[chown-data-www]', :immediately
#   notifies :run, 'bash[update_current_path]', :immediately
# end

if(node.environment == "kitchen")
    template '/srv/www/current/wp-config.php' do
      source "wp-config.php.erb"
      variables config: node["wp_conf"]
      atomic_update true
    end
end


# bash 'update_current_path' do
#   code <<-EOH
#     realpath="$(readlink /srv/www/current)";
#     currentpath="/srv/www/current";
#     sudo grep -rl $realpath $currentpath | xargs -r sudo sed -i "s~$realpath~$currentpath~g"    
#   EOH
#   action :run
# end


