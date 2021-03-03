class Album
  attr_reader :id
  attr_accessor :name, :year, :genre, :artist
  @@albums = {}
  @@total_rows = 0

  def initialize(name, artist, year, genre, id)
    @name = name
    @artist = artist
    @year = year
    @genre = genre
    @id = id || @@total_rows += 1
  end

  def self.all
    @@albums.values()
  end

  def save
    @@albums[self.id] = Album.new(self.name, self.artist, self.year, self.genre, self.id)
  end

  def ==(album_to_compare)
    self.name() == album_to_compare.name()
  end

  def self.clear
    @@albums = {}
    @@total_rows = 0
  end

  def self.find(id)
    @@albums[id]
  end

  def update(name, artist, year, genre, id)
    self.name = name
    self.artist = artist
    self.year = year
    self.genre = genre
    @@albums[self.id] = Album.new(self.name, self.artist, self.year, self.genre, self.id)
  end

  def delete()
    @@albums.delete(self.id)
  end

  def self.search(search_term)
    @@albums.values.select { |album| album.name == search_term }
  end

  def songs
    Song.find_by_album(self.id)
  end

  def self.album_sort()
    @@albums.values.sort_by { |album| [self.name] }
  end
end
