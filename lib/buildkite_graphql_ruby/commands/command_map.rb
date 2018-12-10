module BuildkiteGraphqlRuby
  module Commands
    class CommandMap
      require "buildkite_graphql_ruby/commands/branch_status"

      COMMAND_MAP = {
        'branch_status' => BranchStatus
      }

      def self.get_command(command_string:)
        COMMAND_MAP.fetch(command_string)
      end
    end
  end
end