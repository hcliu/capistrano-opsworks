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
        create_deployment args
      end

      def check args={}
        stack_apps = describe args
        app_id = args.fetch(:app_id)

        stack_apps.data[:apps].collect { |a| a[:app_id] }.include? app_id
      end

      def history args={}
        describe_deployments args
      end

      private

      def describe_deployments args={}
        client.describe_deployments(:app_id => args.fetch(:app_id))
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
        )
      end

    end
  end
end