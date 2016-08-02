
normal_unless[:database][:root_password] = 'test'
normal_unless[:database][:admin_password] = 'test'
default[:nginx_user] = 'www-data'
default[:nginx_group] = 'www-data'
default[:nginx_document_root] = '/srv/www/'
default[:nginx_host_name] = 'elpinerodelacuenca.com.dev'
default['firewall']['allow_ssh'] = true
default['awesome_customers_ubuntu']['open_ports'] = 80