# coding: utf-8

spec = Gem::Specification.new do |s|
  s.name = 'rails_redis_cache'
  s.version = '0.1.0'

  s.author = 'Peter Schröder'
  s.description = 'Rails 3.1 cache store implementation using Redis.'
  s.email = 'phoetmail@googlemail.com'
  s.homepage = 'http://github.com/phoet/rails_redis_cache'
  s.rubyforge_project = 'http://github.com/phoet/rails_redis_cache'
  s.summary = 'Rails 3.1 cache store implementation using Redis. See http://github.com/phoet/rails_redis_cache for more information.'

  s.has_rdoc = true
  s.rdoc_options = ['-a', '--inline-source', '--charset=UTF-8']

  s.files = Dir.glob('lib/*.rb') + %w(README.rdoc CHANGELOG)
  s.test_files = Dir.glob('test/test_*.rb')

  s.add_dependency('activesupport', '~> 3.1.0.rc5')
  s.add_dependency('redis', '~> 2.0.0')

  s.add_development_dependency('rake', '~> 0.9.2')
end
