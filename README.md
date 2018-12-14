# BuildkiteGraphqlRuby

Work in progress utility to display the current Buildkite build status of your current git branch.

Requires configuring rspec to run using the json formatter and output to a file named `tmp/rspec_json_results.json` which needs to be included as an artifact in your build.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'buildkite_graphql_ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install buildkite_graphql_ruby

## Usage

```
bin/buildkite_graphql_ruby --branch some_branch_one --api-token YOUR_API_TOKEN
================================================================================
Branch "some_branch_one" has a failing build
URL: https://buildkite.com/gusto/some_repository/builds/25247

Failing Job: :rspec: 6
150 examples, 1 failure
Failing tests:
./spec/request/some_request_spec.rb
Failing Job: :pipeline:
================================================================================

bin/buildkite_graphql_ruby --branch some_other_branch --api-token YOUR_API_TOKEN
================================================================================
Branch "some_other_branch" has a passing build
URL: https://buildkite.com/gusto/some_repository/builds/25241
================================================================================
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/buildkite_graphql_ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
