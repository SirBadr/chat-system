class CreateApplications < ActiveRecord::Migration[5.0]
  def change
    create_table :applications, {:id => false} do |t|
      t.string :token, primary_key: true
      t.text :name
      t.string :chats_count

      t.timestamps
    end
  end
end
