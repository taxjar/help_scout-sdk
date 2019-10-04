# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'help_scout/version'

Gem::Specification.new do |spec|
  spec.name          = 'help_scout-sdk'
  spec.version       = HelpScout::VERSION
  spec.authors       = ['TaxJar']
  spec.email         = ['support@taxjar.com']

  spec.summary       = 'Ruby Help Scout SDK'
  spec.description   = 'Ruby Help Scout (aka HelpScout) SDK, using Mailbox API v2.0'
  spec.homepage      = 'https://github.com/taxjar/help_scout-sdk'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['source_code_uri'] = 'https://github.com/taxjar/help_scout-sdk'
    spec.metadata['bug_tracker_uri'] = 'https://github.com/taxjar/help_scout-sdk/issues'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday', '~> 0.9'
  spec.add_dependency 'faraday_middleware', '>= 0.10.1', '< 1.0'
  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'bundler-audit', '~> 0.6'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'dotenv', '~> 2.2'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.70'
  spec.add_development_dependency 'vcr', '~> 5.0'
  spec.add_development_dependency 'webmock', '~> 3.3'
end
