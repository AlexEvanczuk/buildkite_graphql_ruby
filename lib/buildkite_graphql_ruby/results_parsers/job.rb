module BuildkiteGraphqlRuby
  module ResultsParsers
    class Job
      require "buildkite_graphql_ruby/results_parsers/artifact"

      def self.from_response(response)
        node = response['node']

        # node.keys: ["agent", "passed", "label", "artifacts", "command", "url"]
        artifacts = node['artifacts']["edges"].map{|build_response| ResultsParsers::Artifact.from_response(build_response) }

        new(
          agent: node['agent'],
          passed: node['passed'],
          label: node['label'],
          command: node['command'],
          url: node['url'],
          artifacts: artifacts,
        )
      end

      private_class_method :new

      attr_reader :agent, :passed, :label,:command, :url, :artifacts

      def initialize(
        agent:,
        passed:,
        label:,
        command:,
        url:,
        artifacts:
      )
        @agent = agent
        @passed = passed
        @label = label
        @command = command
        @url = url
        @artifacts = artifacts
      end
    end
  end
end