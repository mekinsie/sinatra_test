require 'rspec'
require 'album'
require 'spec_helper'

describe '#Album' do

  # before(:each) do

  # end

  describe('#save') do
    it("saves an album") do
      album = Album.new({name: "Giant Steps"})
      album.save()
      album2 = Album.new({name: "Blue"})
      album2.save()
      expect(Album.all).to(eq([album, album2]))
    end
  end

  describe('.all') do
    it("returns an empty array when there are no albums") do
      expect(Album.all).to(eq([]))
    end
  end

  describe('.clear') do
    it("clears all albums") do
      album = Album.new({name: "Giant Steps"})
      album.save()
      album2 = Album.new({name: "Blue"})
      album2.save()
      Album.clear()
      expect(Album.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same album if it has the same attributes as another album") do
      album = Album.new({name: "Blue"})
      album2 = Album.new({name: "Blue"})
      expect(album).to(eq(album2))
    end
  end

  describe('.find') do
    it("finds an album by id") do
      album = Album.new({name: "Giant Steps"})
      album.save()
      album2 = Album.new({name: "Blue"})
      album2.save()
      expect(Album.find(album.id)).to(eq(album))
    end
  end

  describe('#update') do
    it("updates an album by id") do
      album = Album.new({name: "Giant Steps"})
      album.save()
      album.update("A Love Supreme")
      expect(album.name).to(eq("A Love Supreme"))
    end
  end

  describe('#delete') do
    it("deletes an album by id") do
      album = Album.new({name: "Giant Steps"})
      album.save()
      album2 = Album.new({name: "Blue"})
      album2.save()
      album.delete()
      expect(Album.all).to(eq([album2]))
    end
  end

#   describe('.search') do 
#     it('searches through the albums and returns name matches') do
#       album = Album.new("Giant Steps", nil, nil, nil, nil)
#       album.save()
#       album2 = Album.new("Blue", nil, nil, nil, nil)
#       album2.save()
#       expect(Album.search("Blue")).to(eq([album2]))
#     end
#   end

#   describe('#songs') do
#     it("returns an album's songs") do
#       album = Album.new("Giant Steps", nil, nil, nil, nil)
#       album.save()
#       song = Song.new("Naima", album.id, nil, nil, nil)
#       song.save()
#       song2 = Song.new("Cousin Mary", album.id, nil, nil, nil)
#       song2.save()
#       expect(album.songs).to(eq([song, song2]))
#     end
#   end
end