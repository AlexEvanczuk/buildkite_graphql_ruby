module BuildkiteGraphqlRuby
  module ResultsParsers
    class Artifact < OpenStruct
      def self.from_response(response)
        node = response['node']
        # node.keys ["id", "path", "state", "downloadURL"]
        
        new(
          id: node['id'],
          path: node['path'],
          state: node['state'],
          download_url: node['downloadURL'],
        )
      end

      private_class_method :new

      def download
        require 'open-uri'
        file_contents = open(self.download_url) { |f| f.read }
        file_contents
      end
    end
  end
end