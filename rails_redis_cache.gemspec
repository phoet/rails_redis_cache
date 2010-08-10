# coding: utf-8

spec = Gem::Specification.new do |s|
  s.name = 'rails_redis_cache'
  s.version = '0.0.2'

  s.author = 'Peter Schröder'
  s.description = 'Rails cache store implementation using Redis.'
  s.email = 'phoetmail@googlemail.com'
  s.homepage = 'http://github.com/phoet/rails_redis_cache'
  s.summary = 'Rails cache store implementation using Redis.'

  s.has_rdoc = true
  s.rdoc_options = ['-a', '--inline-source', '--charset=UTF-8']
  
  s.files = Dir.glob('lib/*.rb') + %w(README.rdoc)
  s.test_files = Dir.glob('test/test_*.rb')
  
  s.add_dependency('activesupport', '>= 3.0.0.beta')
  s.add_dependency('redis', '>= 2.0.0')
end

