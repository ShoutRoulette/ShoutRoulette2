class AddUpdatecolToSessions < ActiveRecord::Migration
  def change
  	add_column :sessions, :last_update, :datetime
  end
end
