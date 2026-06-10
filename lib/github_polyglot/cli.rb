# frozen_string_literal: true

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
      token = nil if token&.empty?
      @polyglot = GithubPolyglot.new(username: @username, token: token)
      output_format
    end

    private

    def output_format
      case format
      when :print then @polyglot.print
      when :json then puts @polyglot.json(pretty: false)
      when :'pretty-json' then puts @polyglot.json(pretty: true)
      when :svg then puts @polyglot.svg
      else
        throw NotImplementedError, "Unexpected format: #{format}"
      end
    end

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
