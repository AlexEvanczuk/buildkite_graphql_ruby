module BuildkiteGraphqlRuby
  class CLI
    require 'optparse'
    require 'optparse/time'
    require 'ostruct'
    require 'pp'

    #
    # Return a structure describing the options.
    #
    def self.parse(args:)
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      options.branch = `git rev-parse --abbrev-ref HEAD`.chomp # TODO: move this into git helper
      options.command =  'branch_status'

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: buildkite_graphql_ruby [options]"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-b", "--branch BRANCH",
                "Git branch to get stats on (default: current)") do |branch|
          options.branch = branch.chomp
        end

        opts.on("-C", "--command COMMAND",
                "What type of query to run (default and only option: branch_status") do |command|
          # TODO: Error on unaccepted query types
          options.command = command
        end

        opts.on("-a", "--api-token API TOKEN",
                "Git branch to get stats on (default: current)") do |api_token|
          options.api_token = api_token.chomp
        end

        # # Boolean switch.
        # opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        #   options.verbose = v
        # end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Show version") do
          puts ::Version.join('.')
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end