# frozen_string_literal: true

require 'bundler/audit/task'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

Bundler::Audit::Task.new
RSpec::Core::RakeTask.new(:spec) { |t| t.exclude_pattern = '**/integration/*_spec.rb' }
RuboCop::RakeTask.new

desc 'Run CI'
task :ci do
  Rake::Task['bundle:audit'].invoke
  Rake::Task['rubocop'].invoke
  Rake::Task['spec'].invoke
end

task default: :ci
