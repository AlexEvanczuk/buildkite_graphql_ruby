module BuildkiteGraphqlRuby
  module Commands
    require 'rainbow'
    require "buildkite_graphql_ruby/results_parsers/build"

    class BranchStatus
      def run!(options:)
        query = BuildkiteGraphqlRuby::QueryBuilder.new.branch_status(branch: options.branch)
        query_runner = BuildkiteGraphqlRuby::QueryRunner.new.run_query(query: query, options: options)
      end

      # TODO:
      # This method needs to be cleaned up
      def report_result(result:, options:)
        builds_for_branch = result['data']['viewer']['user']['builds']
        total_builds = builds_for_branch['count']
        return if report_if_no_builds(total_builds)

        builds = builds_for_branch["edges"].map{|build_response| ResultsParsers::Build.from_response(build_response) }
        
        return if report_if_no_finished_builds(builds)

        latest_build = builds.select(&:finished?).sort_by(&:finished_at).last

        return if report_if_latest_build_passed(latest_build)

        # For each failing job, print out the label of the job and its status
        puts border
        puts Rainbow("Branch #{options.branch.inspect} has a failing build").red
        puts Rainbow("URL: #{latest_build.url}").red
        puts ""
        latest_build.jobs.reject(&:passed).each do |failing_job|
          puts Rainbow("Failing Job: #{failing_job.label}").red
        end

        puts border
      end

      private

      def border
        Rainbow("=" * 80).blue
      end

      def report_if_no_builds(total_builds)
        if total_builds == 0
          report = [
            border,
            Rainbow("There are no builds for the branch #{options.branch.inspect}").lightblue,
            border
          ]

          puts report
          true
        else
          false
        end
      end

      def report_if_no_finished_builds(builds)
        if builds.select(&:finished?).none?
          report = [
            border,
            Rainbow("None of the  builds for branch #{options.branch.inspect} have finished").lightblue,
            border,
          ]

          puts report
          true
        else
          false
        end
      end

      def report_if_latest_build_passed(latest_build)
        if latest_build.passed?
          report = [
            border,
            Rainbow("Branch #{options.branch.inspect} has a passing build").green,
            Rainbow("URL: #{latest_build.url}").green,
            border,
          ]

          puts report
          true
        else
          false
        end
      end
    end
  end
end