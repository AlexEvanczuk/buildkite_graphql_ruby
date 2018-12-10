module BuildkiteGraphqlRuby
  class QueryBuilder
    def branch_status(branch:)
      query = <<~EOS
        {
          viewer {
            user {
              name
              builds(branch:"#{branch}") {
                count
                edges {
                  node{
                    branch
                    state
                    url
                    uuid
                    scheduledAt
                    startedAt
                    finishedAt
                    pullRequest {
                      id
                    }
                    jobs(first: 100) {
                      edges {
                        node {
                          \.\.\. on JobTypeCommand {
                            agent {
                              id
                            }
                            passed
                            label
                            artifacts(first: 100) {
                              edges {
                                node {
                                  id
                                  path
                                  
                                  state
                                  downloadURL
                                }
                              }
                            }
                            command
                            url
                          }
                        }
                      }
                    }
                  } 
                }
              }
            }
          }
        }
        EOS
    end
  end
end