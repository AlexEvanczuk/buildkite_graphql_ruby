module BuildkiteGraphqlRuby
  module Commands
    require 'rainbow'
    require "buildkite_graphql_ruby/results_parsers/build"
    require "buildkite_graphql_ruby/results_parsers/rspec_results"

    class BranchStatus
      def run!(options:)
        query = BuildkiteGraphqlRuby::QueryBuilder.new.branch_status(branch: options.branch)
        query_runner = BuildkiteGraphqlRuby::QueryRunner.new.run_query(query: query, options: options)
      end

      def report_result(result:, options:)
        builds_for_branch = result['data']['viewer']['user']['builds']
        total_builds = builds_for_branch['count']

        return if report_if_no_builds(total_builds, options)

        builds = builds_for_branch["edges"].map{|build_response| ResultsParsers::Build.from_response(build_response['node']) }
        
        return if report_if_no_finished_builds(builds, options)

        latest_build = builds.select(&:finished?).sort_by(&:finished_at).last

        return if report_if_latest_build_passed(latest_build, options)

        # For each failing job, print out the label of the job and its status
        puts border
        puts Rainbow("Branch #{options.branch.inspect} has a failing build").red
        puts Rainbow("URL: #{latest_build.url}").red
        puts ""

        failing_jobs = latest_build.jobs.reject(&:passed)
        failing_jobs.each do |failing_job|
          puts Rainbow("Failing Job: #{failing_job.label}").red
          # This only works if rspec is configured to upload a file called `tmp/rspec_json_results.json` for
          # rspec output.
          artifacts_with_results = failing_job.artifacts.select{|a| a.path == 'tmp/rspec_json_results.json'}

          artifacts_with_results.each do |artifact|
            rspec_result = ResultsParsers::RspecResults.from_response(artifact.download)
            puts rspec_result['summary_line']
            puts "Failing tests:"
            rspec_result.examples.reject(&:passed?).each do |e|
              puts e.file_path
            end
          end
        end

        puts border
      end

      private

      def border
        Rainbow("=" * 80).blue
      end

      def report_if_no_builds(total_builds, options)
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

      def report_if_no_finished_builds(builds, options)
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

      def report_if_latest_build_passed(latest_build, options)
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