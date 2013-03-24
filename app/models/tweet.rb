class Tweet
  attr_accessor :id, :text, :created_at, :in_reply_to_status_id, :in_reply_to_user_id,
    :user_id, :user_name, :user_screen_name, :retweet_count, :favorite_count

  def initialize(attrs = {})
    @id = attrs[:id]
    @text = attrs[:text]
    @created_at = attrs[:created_at]
    @in_reply_to_status_id = attrs[:in_reply_to_status_id]
    @in_reply_to_user_id = attrs[:in_reply_to_user_id]
    @user_id = attrs[:user_id]
    @user_name = attrs[:user_name]
    @user_screen_name = attrs[:user_screen_name]
    @retweet_count = attrs[:retweet_count]
    @favorite_count = attrs[:favorite_count]
  end
end