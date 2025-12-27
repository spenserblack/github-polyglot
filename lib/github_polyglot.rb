# frozen_string_literal: true

require 'octokit'

# Gets language usage stats for a GitHub user.
class GithubPolyglot
  TOKEN_ENV_VAR = 'GITHUB_TOKEN'

  # @param [String, Nil] username The username to look up.
  # @param [String, Nil] token The GitHub token to use in requests.
  def initialize(username: nil, token: nil)
    @username = username
    @token = token
    @client = Octokit::Client.new(access_token: token)
  end

  # Gets the username to use.
  def username
    return @username unless @username.nil?

    @username = token_username
    @username
  end

  # Gets language stats for the user.
  def languages
    compiled = {}
    each_repo do |repo|
      next if repo[:fork]

      languages = repo_languages(repo.name)
      languages.to_h.each_pair do |language, size|
        compiled[language] = size
      end
    end
    compiled
  end

  private

  # Gets the language stats for a single repository from the GitHub API.
  #
  # @param [String] repository The name of the owner's repository.
  def repo_languages(repository_name)
    @client.languages(repo_qualifier(repository_name))
  end

  # Returns the repository path (`owner/repository`) using the username as the owner.
  def repo_qualifier(repository_name)
    "#{username}/#{repository_name}"
  end

  # Yields each repository
  def each_repo(&block)
    repos = @client.repos(username)
    while repos
      repos.each(&block)
      next_query = @client.last_response.rels[:next]
      break unless next_query

      repos = @client.get(next_query.href)
    end
  end

  # Gets the username for the authenticated token.
  # @return [String, Nil] The authenticated user.
  def token_username
    return nil if @token.nil?

    @client.user.login
  end
end
