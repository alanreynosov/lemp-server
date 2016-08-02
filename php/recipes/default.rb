#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


package ['php7.0','php-common', 'php7.0-cli', 'php7.0-common', 'php7.0-fpm', 'php7.0-json', 'php7.0-opcache', 'php7.0-readline'] do
	action :install
end

package ['php-common'] do
	action :install
end

package ['php7.0-cli' ] do
	action :install
end

package ['php7.0-json'] do
	action :install
end

package ['php7.0-opcache'] do
	action :install
end

package ['php7.0-readline'] do
	action :install
end

package ['php7.0-mysql'] do
	action :install
end

service 'php7.0-fpm' do
	action [:enable,:start]
end

