require 'test_helper'
require 'rails_redis_cache'
require 'logger'

class TestRailsRedisCache < Test::Unit::TestCase
  
  def setup
    ActiveSupport::Cache::RailsRedisCache.logger = Logger.new(STDOUT)
    @cache = ActiveSupport::Cache::RailsRedisCache.new(:url => ENV['RAILS_REDIS_CACHE_URL'])
    @cache.redis.flushdb
    @value = "entry"
    @key = "key"
    @options = {:option => 'any'}
  end

  def test_delete_no_error
    @cache.delete(@key, @options)
  end
  
  def test_write_no_error
    @cache.write(@key, @value, @options)
  end
  
  def test_read_no_error
    @cache.read(@key, @options)
  end  
  
  def test_read_write
    @cache.delete(@key, @options)
    assert_nil(@cache.read(@key, @options))
    @cache.write(@key, @value, @options)
    assert_equal(@value, @cache.read(@key, @options))
  end
  
  def test_expires_in
    @cache.write(@key, @value, :expires_in=>2.seconds)
    assert_equal(@value, @cache.read(@key, @options))
    sleep(3)
    assert_nil(@cache.read(@key, @options))
  end

  def test_fetch
    count = 0
    @cache.fetch(@key, :expires_in=>3.seconds) {count += 1}
    @cache.fetch(@key) {count += 1}
    @cache.fetch(@key) {count += 1}
    assert_equal(count, 1)
    @cache.delete(@key)
    @cache.fetch(@key, :expires_in=>0.seconds) {count += 1}
    assert_equal(count, 2)
  end
  
  def test_with_proc
    @cache.fetch(@key, @options, &lambda{@value})
  end
  
  def test_delete_matched
    @cache.write('aaaa', @value, @options)
    @cache.write('aaa', @value, @options)
    @cache.write('aa', @value, @options)
    assert_equal(3, @cache.delete_matched(/aa+/, @options))
    assert_nil(@cache.read('aaaa', @options))
    assert_nil(@cache.read('aaa', @options))
    assert_nil(@cache.read('aa', @options))
  end
  
  def test_create_exist?
    @cache.write(@key, @value, @options)
    assert_equal(true, @cache.exist?(@key, @options))
  end

  def test_delete_exists
    @cache.write(@key, @value, @options)
    @cache.delete(@key, @options)
    assert_equal(false, @cache.exist?(@key, @options))
  end
  
  def test_increment
    @cache.write(@key, 1)
    assert_equal(1, @cache.read(@key).to_i)
    @cache.increment(@key)
    assert_equal(2, @cache.read(@key).to_i)
  end
  
  def test_decrement
    @cache.write(@key, 1)
    assert_equal(1, @cache.read(@key).to_i)
    @cache.decrement(@key)
    assert_equal(0, @cache.read(@key).to_i)
  end
  
  def test_cleanup
    @cache.write(@key, @value)
    @cache.cleanup
    assert_equal(0, @cache.redis.dbsize)
  end

end