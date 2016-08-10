#
# Cookbook Name:: lemp-server
# Recipe:: deploy
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# deploy 'git_repo' do
#   repo '#{deploy[:scm][:repository]}'
#   user 'root'
#   deploy_to '/srv/www'
#   ssh_wrapper node[:deploy]["elpinerowp"][:scm][:ssh_key]
#   action :deploy
# end

application '/srv/www' do
  git '#{deploy[:scm][:repository]}' do
  	deploy_key chef_vault_item('deploy', 'elpinerowp')[:scm][:ssh_key]
  end
end