module BuildkiteGraphqlRuby
  module ResultsParsers
    class Artifact
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
      
      attr_reader :id, :path, :state, :download_url

      def initialize(
        id:,
        path:,
        state:,
        download_url:
      )
        @id = id
        @path = path
        @state = state
        @download_url = download_url
      end

      def download
        require 'open-uri'
        file_contents = open(artifact.download_url) { |f| f.read }
        file_contents
      end
    end
  end
end