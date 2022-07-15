class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps, {:id => false} do |t|
      t.string :token, primary_key: true
      t.text :name
      t.integer :chats_count

      t.timestamps
    end
  end
end
