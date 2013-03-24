FactoryGirl.define do
  factory :search_result do
    tweets { FactoryGirl.build_list :tweet, 10 }
    next_max_id { FactoryGirl.generate :status_id }

    factory :search_result_for_group_by_time_test do
      tweets { [
        FactoryGirl.build(:tweet_5_mins_old),
        FactoryGirl.build(:tweet_8_mins_old),
        FactoryGirl.build(:tweet_10_mins_old),
        FactoryGirl.build(:tweet_15_mins_old),
        FactoryGirl.build(:tweet_45_mins_old),
        FactoryGirl.build(:tweet_1_hrs_old),
        FactoryGirl.build(:tweet_1_and_half_hrs_old),
        FactoryGirl.build(:tweet_2_hrs_old),
        FactoryGirl.build(:tweet_2_and_half_hrs_old)
      ] }
    end
  end
end