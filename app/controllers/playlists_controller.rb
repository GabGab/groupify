class PlaylistsController < ApplicationController

  before_action :fetch_playlist, only: %w(edit update)

  def new
    @playlist = Playlist.create
  end

  def edit
  end

  def create
    @playlist = Playlist.new(playlist_params)

    if @playlist.save
    else
    end
  end

  def update
    if @playlist.update(playlist_params)
    else
    end
  end

  private

  def playlist_params
    params.require(:playlist).permit(:songs)
  end

  def fetch_playlist
    @playlist = Playlist.find(params[:id])
  end
end