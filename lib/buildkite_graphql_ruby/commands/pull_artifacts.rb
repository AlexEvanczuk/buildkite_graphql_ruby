module BuildkiteGraphqlRuby
  module Commands
    require 'rainbow'
    require "buildkite_graphql_ruby/results_parsers/build"
    require "buildkite_graphql_ruby/results_parsers/rspec_results"

    class PullArtifacts
      def run!(options:)
        query = BuildkiteGraphqlRuby::QueryBuilder.new.artifacts_for_build_slug(slug: options.slug)
        query_runner = BuildkiteGraphqlRuby::QueryRunner.new.run_query(query: query, options: options)
      end

      def report_result(result:, options:)
        build = ResultsParsers::Build.from_response(result['data']['build'])
        all_jobs = build.jobs
        all_artifacts = []
        all_jobs.each do |job|
          all_artifacts += job.artifacts.select{|a| a.path == options.artifact_to_pull}
        end

        all_artifacts.each_with_index do |artifact, index|
          filename = "tmp/#{index} #{options.output_artifact}"
          puts "Writing file: #{filename}"
          File.open(filename, 'w') { |f| f.write(artifact.download) }
        end
      end
    end
  end
end