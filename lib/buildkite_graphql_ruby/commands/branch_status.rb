module BuildkiteGraphqlRuby
  module Commands
    class BranchStatus
      def self.run!(options:)
        query = BuildkiteGraphqlRuby::QueryBuilder.new.branch_status(branch: options.branch)
        query_runner = BuildkiteGraphqlRuby::QueryRunner.new.run_query(query: query, options: options)
      end
    end
  end
end