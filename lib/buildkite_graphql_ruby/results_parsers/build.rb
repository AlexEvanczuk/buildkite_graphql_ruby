module BuildkiteGraphqlRuby
  module ResultsParsers
    class Build < OpenStruct
      require "buildkite_graphql_ruby/results_parsers/job"

      # Potential build states (from graphQL docs)
      # SKIPPED
      # The build was skipped

      # SCHEDULED
      # The build has yet to start running jobs

      # RUNNING
      # The build is currently running jobs

      # PASSED
      # The build passed

      # FAILED
      # The build failed

      # CANCELING
      # The build is currently being canceled

      # CANCELED
      # The build was canceled

      # BLOCKED
      # The build is blocked

      # NOT_RUN
      # The build wasn't run

      def self.from_response(response)
        node = response['node']

        jobs = node['jobs']["edges"].select{|j| j['node'].keys.count > 0 }.map{|build_response| ResultsParsers::Job.from_response(build_response) }
 
        new(
          branch: node['branch'],
          state: node['state'],
          url: node['url'],
          started_at: node['startedAt'] && Time.parse(node['startedAt']),
          finished_at: node['finishedAt'] && Time.parse(node['finishedAt']),
          pull_request: node['pullRequest'],
          jobs: jobs,
        )
      end

      private_class_method :new

      def finished?
        !self.finished_at.nil?
      end

      def passed?
        self.state == 'PASSED'
      end
    end
  end
end