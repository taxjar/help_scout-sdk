# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'helpscout/version'

Gem::Specification.new do |spec|
  spec.name          = 'helpscout-api'
  spec.version       = Helpscout::VERSION
  spec.authors       = ['Andre LeBlanc']
  spec.email         = ['andre@taxjar.com']

  spec.summary       = 'Ruby Wrapper for the Helpscout API'
  spec.description   = 'Ruby Wrapper for the Helpscout API'
  spec.homepage      = 'https://github.com/andremleblanc/helpscout-api'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
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
  spec.add_dependency 'faraday', '~> 0.10'
  spec.add_dependency 'faraday_middleware', '>= 0.10.1', '< 1.0' # TODO: Needed?
  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'awesome_print', '~> 1.8'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'bundler-audit', '~> 0.6'
  spec.add_development_dependency 'dotenv', '~> 2.2'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.70'
  spec.add_development_dependency 'vcr', '~> 4.0'
  spec.add_development_dependency 'webmock', '~> 3.3'
end
