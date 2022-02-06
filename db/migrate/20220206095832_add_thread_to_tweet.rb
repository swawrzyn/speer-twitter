class AddThreadToTweet < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :thread, references: :tweet_threads, null: true
  end
end
