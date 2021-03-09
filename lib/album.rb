class Album
  attr_reader :id
  attr_accessor :name, :year, :genre

  def initialize(attrs)
    @name = attrs[:name]
    # @artist = attrs[:artist]
    @year = attrs[:year]
    @genre = attrs[:genre]
    @id = attrs[:id]
  end

  def self.all
    returned_albums = DB.exec('SELECT * FROM albums;')
    albums = []
    returned_albums.each() do |album|
      name = album.fetch("name")
      id = album.fetch("id").to_i
      albums.push(Album.new({:name => name, :id => id}))
    end
    albums
  end

  def save
    result = DB.exec("INSERT INTO albums (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    DB.exec("DELETE FROM albums * ;")
  end

  def self.find(id)
    album = DB.exec("SELECT * FROM albums WHERE id = #{id};").first
    name = album.fetch("name")    
    id = album.fetch("id")
    genre = album.fetch("genre")
    year = album.fetch("year")
    Album.new({:name => name, :id => id, :year => year, :genre => genre})
  end

  def update(attributes)  
    if (attributes.has_key?(:name)) && (attributes.fetch(:name) != nil)
      name = attributes.fetch(:name)
      DB.exec("UPDATE albums SET name = '#{@name}' WHERE id = #{@id};")
    end
    if (attributes.has_key?(:year)) && (attributes.fetch(:year) != nil)
      @year = attributes.fetch(:year)
      DB.exec("UPDATE albums SET year = '#{@year}' WHERE id = #{@id};")
    end
    if (attributes.has_key?(:genre)) && (attributes.fetch(:genre) != nil)
      @genre = attributes.fetch(:genre)
      DB.exec("UPDATE albums SET genre = '#{@genre}' WHERE id = #{@id};")
    end
    if(attributes.has_key?(:artist_name)) && (attributes.fetch(:artist_name) != nil)
      artist_name = attributes.fetch(:artist_name)
      artist = DB.exec("SELECT * FROM artists WHERE lower(name)='#{artist_name.downcase}';").first
      if artist != nil
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{artist['id'].to_i}, #{@id});")
      else
        artist = Artist.new(name: artist_name)
        artist.save() 
        DB.exec("INSERT INTO albums_artists (album_id, artist_id) VALUES (#{artist['id'].to_i}, #{@id});")
      end
    end
  end


  def delete()
    DB.exec("DELETE FROM albums WHERE id = #{@id};")
    DB.exec("DELETE FROM songs WHERE album_id = #{@id};")

  end

#   def self.search(search_term)
#     @@albums.values.select { |album| album.name == search_term }
#   end

  def songs
    Song.find_by_album(self.id)
  end

#   def self.album_sort()
#     @@albums.values.sort_by { |album| [album.name] }
#   end

def artists
  artists = []
  results = DB.exec("SELECT artist_id FROM albums_artists WHERE album_id = #{@id};")
  results.each() do |result|
    artist_id = result.fetch("artist_id").to_i()
    artist = DB.exec("SELECT * FROM artists WHERE id = #{artist_id};")
    name = artist.first().fetch("name")
    artists.push(Artist.new({:name => name, :id => artist_id}))
    end
    artists
  end
end