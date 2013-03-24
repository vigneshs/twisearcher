class SearchResult
  attr_accessor :tweets, :next_max_id

  TIME_SLOTS = [
    15.minutes,
    1.hour,
    2.hours,
    4.hours,
    6.hours,
    8.hours,
    12.hours,
    1.day,
    2.days,
    3.days,
    4.days,
    5.days,
    1.week
  ]

  def initialize(attrs = {})
    attrs.reverse_merge!(:statuses => [])
    @tweets = attrs[:statuses].map { |status| initialize_tweet(status) }
    @next_max_id = attrs[:next_max_id]
  end

  def size
    @tweets.length
  end

  def group_by_time
    tweets = @tweets.dup
    grouped_tweets = {}
    TIME_SLOTS.each do |duration|
      key = Tools.seconds_to_time(duration)
      grouped_tweets[key] = extract_tweets_in_slot(duration, tweets)
    end
    grouped_tweets
  end

  private

  def extract_tweets_in_slot(duration, tweets)
    selected_tweets = []
    tweets.delete_if { |tweet| selected_tweets << tweet if tweet.created_at > duration.ago }
    selected_tweets
  end

  def initialize_tweet(status)
    tweet = Tweet.new(
      :id => (status.id if status.id),
      :text => (status.text if status.text),
      :created_at => (status.created_at if status.created_at),
      :in_reply_to_status_id => 
        (status.in_reply_to_status_id if status.in_reply_to_status_id),
      :in_reply_to_user_id => 
        (status.in_reply_to_user_id if status.in_reply_to_user_id),
      :retweet_count => (status.retweet_count if status.retweet_count),
      :favorite_count => (status.favorite_count if status.favorite_count)
    )
    if status.user
      tweet.user_id = status.user.id if status.user.id
      tweet.user_name = status.user.name
      tweet.user_screen_name = status.user.screen_name
    end
    tweet
  end
end