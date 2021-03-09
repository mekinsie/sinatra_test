require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
require('./lib/song')
require('./lib/artist')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => 'record_store',  :user=>'postgres', :password => 'Epidorkus@11'})

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
  album = Album.new({name: name, artist: artist, year: year, genre: genre})
  album.save()
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
  @album.update({name: params[:name], artist: params[:artist_name], year: params[:year], genre: params[:genre]})
  @artists = @album.artists
  erb(:album)
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
  song = Song.new({name: params[:song_name], album_id: @album.id})
  song.save()
  erb(:album)
end

# Edit a song and then route back to the album view.
patch('/albums/:id/songs/:song_id') do
  @album = Album.find(params[:id].to_i())
  song = Song.find(params[:song_id].to_i())
  song.update(params[:name], @album.id)
  erb(:album)
end

# Delete a song and then route back to the album view.
delete('/albums/:id/songs/:song_id') do
  song = Song.find(params[:song_id].to_i())
  song.delete
  @album = Album.find(params[:id].to_i())
  erb(:album)
end

#Get a list of all artists
get('/artists') do
  @artists = Artist.all
  erb(:artists)
end

#Look at the detail page for a single artist
get('/artists/:id') do
  @artist = Artist.find((params[:id].to_i()))
  erb(:artist)
end

#Update a single artist
patch('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  @artist.update({name: params[:artist_name]})
  erb(:artist)
end

post('/artists/:id') do
  @artist = Artist.find(params[:id].to_i())
  album = Album.new({name: (params[:album_name]), artist: @artist.name})
  album.save()
  @artist.update({album_name: album.name})
  @albums = Album.all
  erb(:artist)
end

#Add a new artist to the list of artists
post('/artists') do
  artist = Artist.new({name: params[:artist_name]})
  artist.save()
  @artists = Artist.all
  erb(:artists)
end

#Delete an artist from the list
delete('/artists/:id') do
  artist = Artist.find(params[:id].to_i)
  artist.delete
  @artists = Artist.all
  erb(:artists)
end

# get('/albums') do
# end