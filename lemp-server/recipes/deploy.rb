deploy 'git_repo' do
  repo '#{deploy[:scm][:repository]}'
  user 'root'
  deploy_to '/srv/www'
  ssh_wrapper '#{deploy]['elpinerowp'][:scm][:ssh_key]'
  action :deploy
end