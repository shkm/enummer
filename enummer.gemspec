# frozen_string_literal: true

require_relative "lib/enummer/version"

Gem::Specification.new do |spec|
  spec.name = "enummer"
  spec.version = Enummer::VERSION
  spec.authors = ["Jamie Schembri"]
  spec.email = ["jamie@schembri.me"]
  spec.homepage = "https://github.com/shkm/enummer"
  spec.summary = "Multi-value enums for Rails"
  spec.description = "Enummer implements multi-value enums with PostgreSQL bitstrings."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shkm/enummer"
  spec.metadata["changelog_uri"] = "https://github.com/shkm/enummer/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"
end
