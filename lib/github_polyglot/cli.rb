require 'dotenv'
require 'optparse'

class GithubPolyglot
  # Class for the command-line interface
  class CLI
    def initialize
      parser.parse!
    end

    # Runs the CLI
    def run
      Dotenv.load
      token = ENV.fetch(GithubPolyglot::TOKEN_ENV_VAR, nil)
      polyglot = GithubPolyglot.new(username: @username, token: token)
      puts "username: #{polyglot.username}"
    end

    private

    def parser
      parser = OptionParser.new
      parser.on('-u', '-l', '--username', '--login', 'The username/login of the GitHub user') do |value|
        @username = value
      end

      parser
    end
  end
end
