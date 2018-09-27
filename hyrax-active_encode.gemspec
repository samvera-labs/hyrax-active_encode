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

  s.add_dependency "hyrax", "~> 2.1"

  s.add_development_dependency 'bixby'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'engine_cart', '~> 2.0'
  s.add_development_dependency "rspec-rails", "~> 3.8"
end
