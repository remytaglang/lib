require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))
DB.results_as_hash = true

get "/" do
  @artists = DB.execute("SELECT * FROM artists")
  erb :home
end

get "/artists/:id" do
  @artist = DB.execute("SELECT * FROM artists WHERE artists.id = #{params[:id]}")
  @albums = DB.execute("SELECT * FROM albums WHERE artist_id = #{params[:id]}")

  @count_by_genre = DB.execute("
  SELECT count(tracks.id) AS count, genres.name
  FROM tracks
  JOIN genres ON genres.id = tracks.genre_id
  JOIN albums ON albums.id = tracks.album_id
  WHERE albums.artist_id = #{params[:id]}
  GROUP BY genres.name
  ORDER BY count DESC")
  erb :artist
end

get "/albums/:id" do
  @album = DB.execute("SELECT title FROM albums WHERE id=#{params[:id]}").first
  @tracks = DB.execute("SELECT * FROM tracks WHERE album_id=#{params[:id]}")

  erb :album
  # Will render views/home.erb file (embedded in layout.erb)
end

get "/albums/:id" do
  @album = DB.execute("SELECT title FROM albums WHERE id=#{params[:id]}").first
  @tracks = DB.execute("SELECT * FROM tracks WHERE album_id=#{params[:id]}")

  erb :album
  # Will render views/home.erb file (embedded in layout.erb)
end



# Then:
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page, and embed a Youtube video (you might need to hit Youtube API)
#

