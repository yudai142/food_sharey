FactoryBot.define do
  factory :eatdate do
    date { Faker::Date.in_date_period }
    timezone { Faker::Number.between(from: 1, to: 6) }
    eattime { Faker::Time.between(from: DateTime.now - 1,to: DateTime.now).strftime("%H:%M:%S") }
    comment { Faker::Internet.username(max_length: 200) }
    user_id { 1 }
  end
end
