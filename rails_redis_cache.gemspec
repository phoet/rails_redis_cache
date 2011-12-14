# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rails_redis_cache/version"

Gem::Specification.new do |s|
  s.name        = "rails_redis_cache"
  s.version     = RailsRedisCache::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Peter Schröder']
  s.email       = ['phoetmail@googlemail.com']
  s.homepage    = 'http://github.com/phoet/rails_redis_cache'
  s.summary     = 'Simple interface to AWS Lookup, Search and Cart operations.'
  s.description = 'Rails 3.1 cache store implementation using Redis. See http://github.com/phoet/rails_redis_cache for more information.'

  s.rubyforge_project = "rails_redis_cache"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activesupport', '~> 3.1')
  s.add_dependency('i18n',          '~> 0.6')
  s.add_dependency('redis',         '~> 2.0')

  s.add_development_dependency('rake',  '~> 0.9')
  s.add_development_dependency('rspec', '~> 2.7')
  s.add_development_dependency('rspec', '~> 0.0.6')
end
