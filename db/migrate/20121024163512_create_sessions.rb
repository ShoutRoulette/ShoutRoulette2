class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :topic
      t.string :user_ip
      t.string :user_session
      t.string :user_token
      t.string :room_session
      t.integer :position
      t.boolean :matched
      t.timestamps
    end
  end
end
