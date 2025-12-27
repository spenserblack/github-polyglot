# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = 'github-polyglot'
  spec.version                = '0.1.0'
  spec.summary                = 'Language stats for the GitHub user'
  spec.description            = 'Fetches and aggregates language usage statistics for a GitHub user'
  spec.authors                = 'Spenser Black'

  spec.homepage               = 'https://github.com/spenserblack/github-polyglot'
  spec.license                = 'MIT'

  spec.require_paths          = ['lib']

  spec.required_ruby_version  = Gem::Requirement.new('>= 2.7.0')

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'github_repo' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'dotenv', '~> 3.2'

  # NOTE: For octokit
  spec.add_dependency 'faraday-retry', '~> 2.4'

  spec.add_dependency 'octokit', '~> 10.0'
end
