module BuildkiteGraphqlRuby
  module ResultsParsers
    class RspecResults < OpenStruct

      class Example < OpenStruct
        def self.from_response(response)
          keys = ["id", "description", "full_description", "status", "file_path", "line_number", "run_time", "pending_message", "screenshot", "exception"]
          example_data = keys.map do |key|
            [key, response[key]]
          end
          
          new(example_data.to_h)
        end

        private_class_method :new

        def passed?
          self.status == 'passed'
        end
      end

      def self.from_response(raw_response)
        response = JSON.parse(raw_response)
        examples = response['examples'].map{|e| Example.from_response(e)}

        new(
          summary: response['summary'],
          summary_line: response['summary_line'],
          examples: examples,
        )
      end

      private_class_method :new
    end
  end
end