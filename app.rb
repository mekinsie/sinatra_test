require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
require('./lib/song')
also_reload('lib/**/*.rb')

get('/') do
  @albums = Album.all
  erb(:albums)
end

get('/albums') do
  @albums = Album.all
  erb(:albums)
end

get('/albums/new') do
  erb(:new_album)
end

get('/albums/search') do
  @albums = Album.all
  erb(:search_albums)
end

post('/albums/search') do
  search_term = params[:search_term]
  @albums = Album.search(search_term)
  erb(:search_albums)
end

post('/albums') do
  name = params[:album_name]
  artist = params[:album_artist]
  year = params[:album_year]
  genre = params[:album_genre]
  album = Album.new(name, artist, year, genre, nil)
  album.save()
  @albums = Album.album_sort
  @albums = Album.all
  erb(:albums)
end

get('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

get('/albums/:id/edit') do
  @album = Album.find(params[:id].to_i())
  erb(:edit_album)
end

patch('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.update(params[:name], params[:artist], params[:year], params[:genre])
  @albums = Album.all
  erb(:albums)
end

delete('/albums/:id') do
  @album = Album.find(params[:id].to_i())
  @album.delete()
  @albums = Album.all
  erb(:albums)
end

# Get the detail for a specific song such as lyrics and songwriters.
get('/albums/:id/songs/:song_id') do
  @song = Song.find(params[:song_id].to_i())
  erb(:song)
end

# Post a new song. After the song is added, Sinatra will route to the view for the album the song belongs to.
post('/albums/:id/songs') do
  @album = Album.find(params[:id].to_i())
  song = Song.new(params[:song_name], @album.id, nil, nil, nil)
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id , params[:writer], params[:lyrics])
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

# get('/albums') do
# end