Gem::Specification.new do |s|
  s.name = 'rails_redis_cache'
  s.version = '0.0.1'
  s.rubyforge_project = 'none'

  s.author = 'Peter Schröder'
  s.description = 'Rails cache store implementation using Redis.'
  s.email = 'phoetmail@googlemail.com'
  s.homepage = 'http://github.com/phoet/rails_redis_cache'
  s.summary = 'Rails cache store implementation using Redis.'

  s.has_rdoc = true
  s.rdoc_options = ['-a', '--inline-source', '--charset=UTF-8']
  s.extra_rdoc_files = ['README.textile']
  s.files = [ 'README.rdoc', 'lib/rails_redis_cache.rb' ]
  s.test_files = [ 'test/test_rails_redis_cache.rb' ]
  
  s.add_dependency('activesupport', '>= 3.0.0')
  s.add_dependency('redis', '>= 2.0.0')
end