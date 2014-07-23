# Capistrano::OpsWorks

A gem to help deploy rails applications to AWS OpsWorks, which hopefully works with capistrano 3

## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-ops_works'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-ops_works

## Usage

If you haven't installed [Capistrano](https://github.com/capistrano/capistrano), do that and make sure you 

    $ bundle exec cap install

Require the gem in your Capfile (example taken from default generated Capfile)

```ruby
###########
# Capfile #
###########

# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/ops_works'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails/tree/master/assets
#   https://github.com/capistrano/rails/tree/master/migrations
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
```

In the appropriate stage deploy file, add your OpsWorks details

```ruby
#############################
# /config/deploy/staging.rb #
#############################

set :stage, :staging

set :access_key_id, '<aws_access_key_id>'
set :secret_access_key, '<aws_secret_access_key>'
set :stack_id, '<opsworks_stack_id>'
set :app_id, '<opsworks_app_id>'
set :opsworks_custom_json, '<opsworks_custom_json>'
```

Check the task list using

    $ bundle exec cap -T

Check your app_id

    $ bundle exec cap staging opsworks:check

Deploy your app (you'll get a deployment_id back if it worked)

    $ bundle exec cap staging opsworks
    $ bundle exec cap staging opsworks:migrate

Check the history of your app deployments

    $ bundle exec cap staging opsworks:history

## FAQ

1. Why is the name so ugly?
  * [capistrano-opsworks](https://github.com/onemightyroar/capistrano-opsworks) was already taken, but unfortunately doesn't work with capistrano 3.
2. Why are the task names namespaced with opsworks instead of ops_works?
  * to make it less ugly, and easier to type

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
