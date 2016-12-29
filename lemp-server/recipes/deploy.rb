#
# Cookbook Name:: lemp-server
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app = search("aws_opsworks_app").first

newbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]}"
oldbuild = "#{app[:environment][:build]}#{app[:environment][:build_number]-1}"

s3_file "/srv/www/#{newbuild}.tar.gz" do
    remote_path "#{newbuild}.tar.gz"
    bucket "#{app[:environment][:build_bucket]}"
    aws_access_key_id "#{app[:environment][:AWS_ACCESS_KEY_ID]}"
    aws_secret_access_key "#{app[:environment][:AWS_SECRET_ACCESS_KEY]}"
    s3_url "https://s3.amazonaws.com/#{app[:environment][:build_bucket]}"
    owner "root"
    group "root"
    mode "0644"
    action :create
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