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

      def self.from_response(build_response)
        jobs = build_response['jobs']["edges"].select{|j| j['node'].keys.count > 0 }.map{|build_response| ResultsParsers::Job.from_response(build_response) }
 
        new(
          branch: build_response['branch'],
          state: build_response['state'],
          url: build_response['url'],
          started_at: build_response['startedAt'] && Time.parse(build_response['startedAt']),
          finished_at: build_response['finishedAt'] && Time.parse(build_response['finishedAt']),
          pull_request: build_response['pullRequest'],
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