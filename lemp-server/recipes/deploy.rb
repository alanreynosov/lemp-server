#
# Cookbook Name:: lemp-server
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


app = search("aws_opsworks_app").first

newbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]}"
old_number = app[:environment][:build_number].to_i-1.to_i
oldbuild = "#{app[:environment][:build]}#{old_number}"

bash 'download_build' do
  code <<-EOH
    export AWS_ACCESS_KEY_ID=#{app[:environment][:AWS_ACCESS_KEY_ID]}; export AWS_SECRET_ACCESS_KEY=#{app[:environment][:AWS_SECRET_ACCESS_KEY]};
    aws s3 cp s3://#{app[:environment][:build_bucket]}/#{newbuild}.tar.gz /srv/www/
    EOH
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

bash 'update_assets' do
  code <<-EOH
    export AWS_ACCESS_KEY_ID=#{app[:environment][:AWS_ACCESS_KEY_ID]}; export AWS_SECRET_ACCESS_KEY=#{app[:environment][:AWS_SECRET_ACCESS_KEY]};
    aws s3 sync s3://#{app[:environment][:assets_bucket ]}/* /srv/www/#{newbuild} --exclude="*.php" --exclude="*.html" --exclude="*.gz" --exclude=".git/*" --exclude=".htaccess" --exclude="*.txt" --exclude=".gitignore"
  EOH
end

# execute "fix-mod" do
#   command "sudo chmod 755 current "
#   user "root"
#   action :run
# end


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

bash 'flush_cache' do
  cwd "#{node[:deployment_path]}/current"
  user "www-data"
  code <<-EOH
    wp super-cache flush;
    wp super-cache preload;
    EOH
    not_if { File.exist?("/srv/www/wp-cli.phar") }
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