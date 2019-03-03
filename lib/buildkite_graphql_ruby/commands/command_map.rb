module BuildkiteGraphqlRuby
  module Commands
    class CommandMap
      require "buildkite_graphql_ruby/commands/branch_status"
      require "buildkite_graphql_ruby/commands/pull_artifacts"

      COMMAND_MAP = {
        'branch_status' => BranchStatus,
        'pull_artifacts' => PullArtifacts
      }

      def self.get_command(command_string:)
        COMMAND_MAP.fetch(command_string).new
      end
    end
  end
end