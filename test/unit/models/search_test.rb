require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  context 'initialization' do
    should 'create search object with given attributes' do
      search = Search.new("test query", :count => 15, :result_type => 'mixed')
      assert_equal "test query", search.query
      assert_equal 15, search.options[:count]
      assert_equal 'mixed', search.options[:result_type]
    end

    should 'have default value 100 for count option' do
      search = Search.new("test query")
      assert_equal 100, search.options[:count]
    end

    should 'have default value "recent" for result_type option' do
      search = Search.new("test query")
      assert_equal 'recent', search.options[:result_type]
    end

    should 'remove any option that has nil value' do
      search = Search.new("test query", :count => nil)
      assert !search.options.has_key?(:count)
    end
  end

  context 'execute search' do
    def setup
      @twitter_status = stub(
        :id => 315456913787736066,
        :text => "Sample status",
        :created_at => Time.now,
        :in_reply_to_status_id => 315456913787736099,
        :in_reply_to_user_id => 610153438,
        :retweet_count => 10,
        :favorite_count => 4,
        :user => stub(
          :id => 610153434,
          :name => "John Smith",
          :screen_name => "john"
        )
      )
      Search.any_instance.stubs(:get_next_max_id).returns("11111111111")
    end

    should 'make api call via Twitter gem' do
      result = stub(:statuses => [@twitter_status])
      Twitter.expects(:search).once.returns(result)
      search = Search.new("test query")
      search.execute
    end

    should 'raise SearchError if search via Twitter gem fails' do
      Twitter.expects(:search).once.raises
      assert_raise(SearchError) { Search.new("test query").execute }
    end

    should 'raise InvalidQuery if query string is blank' do
      search = Search.new("")
      assert_raise(InvalidQuery) { search.execute }
    end

    should 'return results grouped by time as a Hash' do
      grouped_result = { "15_mins" => [], "1_hr" => [] }
      SearchResult.any_instance.stubs(:group_by_time).returns(grouped_result)
      result = Search.new("test query").execute
      assert_kind_of Hash, result
      assert result.has_key?("15_mins")
      assert result.has_key?("1_hr")
    end

    should 'hold original ungrouped results of the search' do
      result = FactoryGirl.build(:search_result)
      SearchResult.expects(:new).returns(result)
      search = Search.new("test query")
      search.execute
      assert_kind_of SearchResult, search.result
      assert_equal result, search.result
    end
  end
end