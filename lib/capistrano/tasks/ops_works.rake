require 'capistrano/ops_works'

namespace :opsworks do

  def opsworks
    Capistrano::OpsWorks::Connection.new(\
      :access_key_id => fetch(:access_key_id),
      :secret_access_key => fetch(:secret_access_key)
    )
  end

  def deployment_ids
    { 
      :stack_id => fetch(:stack_id),
      :app_id => fetch(:app_id)
    }
  end

  def start_deploy command_args={}
    ids = deployment_ids
    deploy_opts = {
      :command => {
        :name => 'deploy', 
        :args => command_args
      },
      :comment => 'Capistrano OpsWorks Deploy'
    }
    opts = ids.merge(deploy_opts)

    opsworks.deploy(opts)
  end

  task :default do
    puts start_deploy
  end

  desc "Add command arg migrate=true to deploy (Rails app specific?)"
  task :migrate do
    puts start_deploy({"migrate"=>["true"]})
  end
  task :migrations => :migrate

  desc "Checks your app_id for validity"
  task :check do
    puts "app_id #{fetch(:app_id)} is valid" if opsworks.check(deployment_ids)
  end

  task :history do
    puts opsworks.history(deployment_ids)
  end

end

desc "Deploy to opsworks"
task :opsworks => ["opsworks:default"]