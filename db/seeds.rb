require 'factory_bot_rails'

puts "Starting seed..."

# Create login user
if !User.exists?(username: 'testuser')
  User.create!(username: 'testuser', password: '1Password!')
end
puts "Login user created, username: 'testuser', password: '1Password!'"

puts "Creating tweets..."
# Create tweets
FactoryBot.create(:tweet)

for i in 0..25
  sel = [0, 1, 2].sample

  if sel == 1
    # create tweet
    FactoryBot.create(:tweet)
  elsif sel == 2
    # create retweet
    retweet_parent = Tweet.find(Tweet.pluck(:id).sample)
    FactoryBot.create(:tweet, retweet_parent: retweet_parent)
  else
    # create thread
    FactoryBot.create(:tweet_thread)
  end
end

puts "Done."