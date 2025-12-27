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

  private

  # Gets the username for the authenticated token.
  # @return [String, Nil] The authenticated user.
  def token_username
    return nil if @token.nil?

    @client.user.login
  end
end
