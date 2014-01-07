require 'aws/ops_works'

module Capistrano
  module OpsWorks
    class Connection

      attr_reader :client

      def initialize aws={}
        access_key_id = aws.fetch(:access_key_id)
        secret_access_key = aws.fetch(:secret_access_key)

        @client = AWS::OpsWorks.new(\
          :access_key_id => access_key_id,
          :secret_access_key => secret_access_key).client

        self
      end

      def deploy args={}
        deploy_id = create_deployment(args)
        verify deploy_id
      end

      def check args={}
        stack_apps = describe args
        app_id = args.fetch(:app_id)

        stack_apps.data[:apps].collect { |a| a[:app_id] }.include? app_id
      end

      def history app_id
        describe_deployments :app_id => app_id
      end

      def verify deploy_id
        complete = false

        until complete
          finished_deploy = check_completion deploy_id
          if finished_deploy
            puts " [ #{Time.now} ] [ #{finished_deploy[:status]} ] #{finished_deploy[:deployment_id]} "
            complete = true
          else
            sleep 15
          end
        end

      end

      private

      def check_completion deploy_id
        puts "verifying ..."

        d = describe_deployments(:deployment_ids => [deploy_id])
        the_deploy = d.first

        return the_deploy if the_deploy.fetch(:completed_at, nil)
      end

      def describe_deployments args={}
        client.describe_deployments(args).data[:deployments]
      end

      def describe args={}
        client.describe_apps(\
          :stack_id => args.fetch(:stack_id)
        )
      end

      def create_deployment args={}
        stack_id    = args.fetch(:stack_id)
        app_id      = args.fetch(:app_id)
        command     = args.fetch(:command)
        comment     = args.fetch(:comment, "")
        custom_json = args.fetch(:custom_json, "")

        client.create_deployment(\
          :stack_id => stack_id,
          :app_id => app_id,
          :command => {
            :name => command[:name],
            :args => command[:args]
          },
          :comment => comment,
          :custom_json => custom_json
        ).data[:deployment_id]
      end

    end
  end
end