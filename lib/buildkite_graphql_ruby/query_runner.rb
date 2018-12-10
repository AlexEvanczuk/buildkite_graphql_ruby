module BuildkiteGraphqlRuby
  class QueryRunner

    class ResponseError < StandardError; end

    require 'net/http'
    require 'uri'
    require 'json'

    def run_query(query:, options:)
      request_from_api(query, options)
    end

    private

    def request_from_api(query, options)
      payload = {
        query: query,
      }.to_json

      uri = URI.parse("https://graphql.buildkite.com/v1")
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      https.read_timeout = 500
      req = Net::HTTP::Post.new(uri.path, initheader = {'Authorization' =>"Bearer #{options.api_token}"})
      req.body = payload
      res = https.request(req)

      raise ResponseError, res.message if res.code_type != Net::HTTPOK

      JSON.parse(res.body)
    end
  end
end