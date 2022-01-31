# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in enummer.gemspec.
gemspec

gem "pg"
gem "rubocop-rails"
gem "bundler-audit"
gem "standard"

group :test do
  gem "simplecov", require: false
  gem 'simplecov-cobertura', require: false
end
