require 'test_helper'

class SearchResultTest < ActiveSupport::TestCase
  context 'initialization' do
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
    end

    should 'create search result object from given attributes' do
      result = SearchResult.new(
        :statuses => [@twitter_status],
        :next_max_id => FactoryGirl.generate(:status_id)
      )

      assert_equal result.tweets.count, 1
      assert_equal Tweet, result.tweets.first.class
      assert result.next_max_id.present?
    end

    should 'have empty tweets array if no statuses are provided' do
      result = SearchResult.new(
        :next_max_id => FactoryGirl.generate(:status_id)
      )
      assert_equal [], result.tweets
    end
  end

  context 'size' do
    should 'give the number of tweets in the result' do
      result = FactoryGirl.build(:search_result,
        :tweets => FactoryGirl.build_list(:tweet, 10))
      assert_equal 10, result.size
    end
  end

  context 'group_by_time' do
    should 'have only integers values in time slots' do
      SearchResult::TIME_SLOTS.each do |slot|
        assert slot.is_a? Numeric
      end
    end

    should 'have given time slots' do
      assert SearchResult::TIME_SLOTS.include?(15.minutes)
      assert SearchResult::TIME_SLOTS.include?(1.hour)
      assert SearchResult::TIME_SLOTS.include?(2.hours)
      assert SearchResult::TIME_SLOTS.include?(4.hours)
      assert SearchResult::TIME_SLOTS.include?(6.hours)
      assert SearchResult::TIME_SLOTS.include?(8.hours)
      assert SearchResult::TIME_SLOTS.include?(12.hours)
      assert SearchResult::TIME_SLOTS.include?(1.day)
      assert SearchResult::TIME_SLOTS.include?(2.days)
      assert SearchResult::TIME_SLOTS.include?(3.days)
      assert SearchResult::TIME_SLOTS.include?(4.days)
      assert SearchResult::TIME_SLOTS.include?(5.days)
      assert SearchResult::TIME_SLOTS.include?(1.week)

      assert_equal 13, SearchResult::TIME_SLOTS.count
    end

    should 'group tweets by given time slots' do
      result = FactoryGirl.build(:search_result_for_group_by_time_test)
      grouped_result = result.group_by_time
      assert_equal 3, grouped_result["15_mins"].count
      assert_equal 2, grouped_result["1_hr"].count
      assert_equal 2, grouped_result["2_hrs"].count
      assert_equal 2, grouped_result["4_hrs"].count
      assert_equal 0, grouped_result["6_hrs"].count
      assert_equal 0, grouped_result["8_hrs"].count
      assert_equal 0, grouped_result["12_hrs"].count
      assert_equal 0, grouped_result["1_day"].count
      assert_equal 0, grouped_result["2_days"].count
      assert_equal 0, grouped_result["3_days"].count
      assert_equal 0, grouped_result["4_days"].count
      assert_equal 0, grouped_result["5_days"].count
      assert_equal 0, grouped_result["1_week"].count
    end

    should 'not change the original tweets in the result' do
      tweets = FactoryGirl.build_list(:tweet, 5)
      result = FactoryGirl.build(:search_result, :tweets => tweets)
      assert_equal tweets, result.tweets
      grouped_result = result.group_by_time
      assert_kind_of Hash, grouped_result
      assert_kind_of Array, result.tweets
      assert_equal tweets, result.tweets
    end
  end
end