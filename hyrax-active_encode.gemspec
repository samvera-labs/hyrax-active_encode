# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "hyrax/active_encode/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hyrax-active_encode"
  s.version     = Hyrax::ActiveEncode::VERSION
  s.authors     = ["Chris Colvard", "Brian Keese", "Ying Feng", "Phuong Dinh", "Carrick Rogers"]
  s.email       = ["cjcolvar@indiana.edu", "bkeese@indiana.edu", "yingfeng@iu.edu", "phuongdh@gmail.com", "carrickr@umich.edu"]
  s.summary     = "Hyrax plugin to enable audiovisual derivative generation through active_encode"
  s.description = "Hyrax plugin to enable audiovisual derivative generation through active_encode"
  s.license     = 'Apache-2.0'

  s.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.required_ruby_version = '>= 2.4'

  s.add_dependency "rails", "~> 5.0"

  s.add_dependency "active_encode", "~> 0.5"
  s.add_dependency "hyrax", "~> 2.1"

  s.add_development_dependency 'bixby'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'engine_cart', '~> 2.2'
  s.add_development_dependency 'fcrepo_wrapper'
  s.add_development_dependency "rspec-rails", "~> 3.8"
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'solr_wrapper'
  s.add_development_dependency 'webmock'
end
