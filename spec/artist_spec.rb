require 'spec_helper'

describe('#update') do
  it("adds an album to an artist") do
    artist = Artist.new({name: "John Coltrane"})
    artist.save()
    album = Album.new({name: "A Love Supreme"})
    album.save()
    artist.update({album_name: "A Love Supreme"})
    expect(artist.albums).to(eq([album]))
  end
end