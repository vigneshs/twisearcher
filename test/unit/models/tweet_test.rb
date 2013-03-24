require 'test_helper'

class TweetTest < ActiveSupport::TestCase
  should 'initialize tweet object with given attributes' do
    attrs = {
      :id => 315456913787736066,
      :text => "Sample status",
      :created_at => Time.now,
      :user_id => 610153434,
      :user_name => "John Smith",
      :user_screen_name => "john",
      :in_reply_to_status_id => 315456913787736099,
      :in_reply_to_user_id => 610153438,
      :retweet_count => 10,
      :favorite_count => 4
    }
    FactoryGirl.build(:tweet)
    test_tweet = Tweet.new(attrs)
    assert_equal test_tweet.id, attrs[:id]
    assert_equal test_tweet.text, attrs[:text]
    assert_equal test_tweet.created_at, attrs[:created_at]
    assert_equal test_tweet.user_id, attrs[:user_id]
    assert_equal test_tweet.user_name, attrs[:user_name]
    assert_equal test_tweet.user_screen_name, attrs[:user_screen_name]
    assert_equal test_tweet.in_reply_to_status_id, attrs[:in_reply_to_status_id]
    assert_equal test_tweet.in_reply_to_user_id, attrs[:in_reply_to_user_id]
    assert_equal test_tweet.retweet_count, attrs[:retweet_count]
    assert_equal test_tweet.favorite_count, attrs[:favorite_count]
  end
end 