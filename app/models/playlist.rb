class Playlist < ApplicationRecord
  has_many :users, through: :ownerships

  serialize :songs, Array
end
