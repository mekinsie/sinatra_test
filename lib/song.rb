class Song
  attr_reader :id
  attr_accessor :name, :album_id, :writer, :lyrics


  def initialize(attrs)
    @name = attrs[:name]
    @album_id = attrs[:album_id]
    @writer = attrs[:writer]
    @lyrics = attrs[:lyrics]
    @id = attrs[:id]
  end

  def ==(song_to_compare)
    (self.name() == song_to_compare.name()) && (self.album_id() == song_to_compare.album_id())
  end

  def self.all
    returned_songs = DB.exec("SELECT * FROM songs;")
    songs = []
    returned_songs.each() do |song|
      name = song.fetch("name")
      id = song.fetch("id")
      album_id = song.fetch("album_id").to_i
      songs << (Song.new({:name => name, :id => id, :album_id => album_id}))
    end
    songs
  end

  def save
    result = DB.exec("INSERT INTO songs (name, album_id) VALUES ('#{@name}', #{@album_id}) RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def self.find(id)
    song = DB.exec("SELECT * FROM songs WHERE id = #{id};").first
    name = song.fetch("name")
    album_id = song.fetch("album_id").to_i
    id = song.fetch("id").to_i
    Song.new({:name => name, :album_id => album_id,:id => id})
  end

  def update(name, album_id)
    @name = name
    @album_id = album_id
    DB.exec("UPDATE songs SET name = '#{@name}', album_id = #{@album_id} WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM songs WHERE id = #{id};")
  end

  # def self.clear
  #   @@songs = {}
  # end

  # def self.find_by_album(alb_id)
  #   songs = []
  #   @@songs.values.each do |song|
  #     if song.album_id == alb_id
  #       songs.push(song)
  #     end
  #   end
  #   songs
  # end

  # def album
  #   Album.find(self.album_id)
  # end
end