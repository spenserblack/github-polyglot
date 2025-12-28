require 'dotenv'
require 'optparse'

class GithubPolyglot
  # Class for the command-line interface
  class CLI
    FORMAT_OPTIONS = %i[print json pretty-json svg].freeze

    def initialize
      parser.parse!
    end

    # Runs the CLI
    def run
      Dotenv.load

      token = ENV.fetch(GithubPolyglot::TOKEN_ENV_VAR, nil)
      polyglot = GithubPolyglot.new(username: @username, token: token)

      if format == :print
        polyglot.print
      elsif format == :json
        puts polyglot.json(pretty: false)
      elsif format == :'pretty-json'
        puts polyglot.json(pretty: true)
      elsif format == :svg
        puts polyglot.svg
      else
        throw NotImplementedError, "Unexpected format: #{format}"
      end
    end

    private

    def parser
      parser = OptionParser.new
      parser.on('-u USERNAME', '-l', '--username', '--login', 'The username/login of the GitHub user') do |value|
        @username = value
      end
      parser.on('-F FORMAT', '--format', FORMAT_OPTIONS,
                "The format to output in (#{FORMAT_OPTIONS.join('/')})") do |value|
        @format = value
      end

      parser
    end

    def format
      @format ||= :print
    end
  end
end
