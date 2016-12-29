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

bash 'unzip_build' do
  code <<-EOH
    tar -xvf /srv/www/#{newbuild}.tar.gz
    EOH
end

bash 'unzip_build' do
  code <<-EOH
    export AWS_ACCESS_KEY_ID=#{app[:environment][:AWS_ACCESS_KEY_ID]}; export AWS_SECRET_ACCESS_KEY=#{app[:environment][:AWS_SECRET_ACCESS_KEY]};
    aws s3 sync s3://assets.elpinerodelacuenca.com.mx/* /srv/www/#{newbuild} --exclude="*.php" --exclude="*.html" --exclude="*.gz" --exclude=".git/*" --exclude=".htaccess" --exclude="*.txt" --exclude=".gitignore"
    EOH
end

bash 'rename_document_root' do
  code <<-EOH
    mv /srv/www/current /srv/www/#{oldbuild}
    mv /srv/www/#{newbuild} /srv/www/current
  EOH
  notifies :run, 'execute[chown-data-www]', :immediately
end

execute "chown-data-www" do
  command "chown -R www-data:www-data /srv/www/current/wp-content"
  user "root"
  action :run
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