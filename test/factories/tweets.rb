FactoryGirl.define do
  sequence :status_id do |n|
    "31545691378773606#{n}".to_i
  end

  sequence :user_id do |n|
    "61015343#{n}".to_i
  end

  factory :tweet do
    id FactoryGirl.generate :status_id
    text "Sample text for tweet to be used in the Twisearcher tests"
    created_at { Time.now }
    user_id { FactoryGirl.generate :user_id }
    user_name "Vignesh"
    user_screen_name "vignesh"
    in_reply_to_status_id { FactoryGirl.generate :status_id }
    in_reply_to_user_id { FactoryGirl.generate :user_id }
    retweet_count { rand(10) }
    favorite_count { rand(10) }

    factory :tweet_5_mins_old do
      created_at { 5.minutes.ago }
    end

    factory :tweet_8_mins_old do
      created_at { 8.minutes.ago }
    end

    factory :tweet_10_mins_old do
      created_at { 10.minutes.ago }
    end

    factory :tweet_15_mins_old do
      created_at { 15.minutes.ago }
    end

    factory :tweet_45_mins_old do
      created_at { 45.minutes.ago }
    end

    factory :tweet_1_hrs_old do
      created_at { 1.hours.ago }
    end

    factory :tweet_1_and_half_hrs_old do
      created_at { 1.5.hours.ago }
    end

    factory :tweet_2_hrs_old do
      created_at { 2.hours.ago }
    end

    factory :tweet_2_and_half_hrs_old do
      created_at { 2.5.hours.ago }
    end

  end

end