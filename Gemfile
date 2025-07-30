# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in enummer.gemspec.
gemspec

gem 'bundler-audit'
gem 'rails', '~> 7.1.0'
gem 'rubocop-rails'
gem 'standard'

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
end

group :postgres do
  gem 'pg'
end

group :mysql do
  gem 'mysql2'
end

group :sqlite do
  gem 'sqlite3', '~> 1.4'
end
