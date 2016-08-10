#
# Cookbook Name:: lemp-server
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


application '/srv/myapp' do
  git 'git@github.com:example/myapp.git'
  	deploy_key chef_vault_item('deploy', 'elpinerowp')[:scm][:ssh_key]
  end
end