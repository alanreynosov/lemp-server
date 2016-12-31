#
# Cookbook Name:: lemp-server
# Recipe:: update_assets_cdn
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

app = search("aws_opsworks_app").first

bash 'update_assets' do
  code <<-EOH
    export AWS_ACCESS_KEY_ID=#{app[:environment][:AWS_ACCESS_KEY_ID]}; export AWS_SECRET_ACCESS_KEY=#{app[:environment][:AWS_SECRET_ACCESS_KEY]};
    aws s3 sync /srv/www/#{newbuild} s3://#{app[:environment][:assets_bucket ]}/ --exclude="*.php" --exclude="*.html" --exclude="*.gz" --exclude=".git/*" --exclude=".htaccess" --exclude="*.txt" --exclude=".gitignore"
  EOH
end