require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ActiveSupport::Cache::RailsRedisCacheStore do
  before(:each) do
    ActiveSupport::Cache::RailsRedisCacheStore.logger = Logger.new(STDOUT)
    @cache = ActiveSupport::Cache::RailsRedisCacheStore.new(:url => ENV['RAILS_REDIS_CACHE_URL'])
    @cache.redis.flushdb
    @value = "entry"
    @key = "key"
    @options = {:option => 'any'}
  end

  it "test_delete_no_error" do
    @cache.delete(@key, @options)
  end

  it "test_write_no_error" do
    @cache.write(@key, @value, @options)
  end

  it "test_read_no_error" do
    @cache.read(@key, @options)
  end

  it "test_read_write" do
    @cache.delete(@key, @options)
    @cache.read(@key, @options).should be_nil
    @cache.write(@key, @value, @options)
    @cache.read(@key, @options).should eql(@value)
  end

  it "test_expires_in" do
    @cache.write(@key, @value, :expires_in=>2.seconds)
    @cache.read(@key, @options).should eql(@value)
    sleep(3)
    @cache.read(@key, @options).should be_nil
  end

  it "test_fetch" do
    count = 0
    @cache.fetch(@key, :expires_in=>3.seconds) {count += 1}
    @cache.fetch(@key) {count += 1}
    @cache.fetch(@key) {count += 1}
    count.should be(1)
    @cache.delete(@key)
    @cache.fetch(@key, :expires_in=>0.seconds) {count += 1}
    count.should be(2)
  end

  it "test_fetch_with_proc" do
    @cache.fetch(@key, @options, &lambda{@value})
  end

  it "test_fetch_with_array" do
    @cache.fetch(@key, @options){[@value]}
    @cache.fetch(@key, @options).should eql([@value])
  end

  it "test_delete_matched" do
    @cache.write('aaaa', @value, @options)
    @cache.write('aaa', @value, @options)
    @cache.write('aa', @value, @options)
    @cache.delete_matched(/aa+/, @options).should be(3)
    @cache.read('aaaa', @options).should be_nil
    @cache.read('aaa', @options).should be_nil
    @cache.read('aa', @options).should be_nil
  end

  it "test_create_exist?" do
    @cache.write(@key, @value, @options)
    @cache.exist?(@key, @options).should be_true
  end

  it "test_delete_exists" do
    @cache.write(@key, @value, @options)
    @cache.delete(@key, @options)
    @cache.exist?(@key, @options).should be_false
  end

  it "test_increment" do
    @cache.write(@key, 1)
    @cache.read(@key).should eql(1)
    @cache.increment(@key)
    @cache.read(@key).should eql(2)
  end

  it "test_decrement" do
    @cache.write(@key, 1)
    @cache.read(@key).should be(1)
    @cache.decrement(@key)
    @cache.read(@key).should be(0)
  end

  it "test_cleanup" do
    @cache.write(@key, @value)
    @cache.cleanup
    @cache.redis.dbsize.should be(0)
  end

  it "test_edge_case_with_missing_time_key" do
    @cache.write(@key, @value)
    @cache.redis.del "#{ActiveSupport::Cache::RailsRedisCacheStore::TIME_PREF}_#{@key}"
    @cache.read(@key).should eql(@value)
  end
end
