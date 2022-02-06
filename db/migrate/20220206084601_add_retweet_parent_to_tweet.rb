class AddRetweetParentToTweet < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :retweet_parent, references: :tweets, null: true
    add_column :tweets, :retweet_count, :integer, default: 0
  end
end
