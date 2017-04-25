class CreatePlaylists < ActiveRecord::Migration[5.0]
  def change
    create_table :playlists do |t|
      t.text :songs

      t.timestamps
    end
  end
end
