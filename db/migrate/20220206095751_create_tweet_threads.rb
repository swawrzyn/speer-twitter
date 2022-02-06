class CreateTweetThreads < ActiveRecord::Migration[7.0]
  def change
    create_table :tweet_threads do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
