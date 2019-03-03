module BuildkiteGraphqlRuby
  class QueryBuilder
    def artifacts_for_build_slug(slug:)
      query = <<~EOS
        {
          build(slug:"#{slug}") {
            jobs(last: 50) {
              edges {
                node {
                  ... on JobTypeCommand {
                    agent {
                      id
                    }
                    artifacts(first: 300) {
                      edges {
                        node {
                          id
                          path
                          downloadURL
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
                    jobs(last: 50) {
                      edges {
                        node {
                          \.\.\. on JobTypeCommand {
                            agent {
                              id
                            }
                            passed
                            label
                            artifacts(first: 300) {
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