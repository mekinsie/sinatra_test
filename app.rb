require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
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
  @albums = Album.album_sort.all
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

# get('/albums') do
# end