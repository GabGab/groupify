class CreateOwnerships < ActiveRecord::Migration[5.0]
  def change
    create_table :ownerships do |t|
      t.references :user
      t.references :playlist

      t.timestamps
    end

    add_foreign_key :ownerships, :users
    add_foreign_key :ownerships, :playlists
  end
end
