
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('create an album path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    visit('/albums')
    click_on('Add a new album')
    fill_in('album_name', :with => 'Yellow Submarine')
    click_on('Go!')
    expect(page).to have_content('Yellow Submarine')
  end
end

describe('create a song path', {:type => :feature}) do
  it('creates an album and then goes to the album page') do
    album = Album.new("Yellow Submarine", nil, nil, nil, nil)
    album.save
    visit("/albums/#{album.id}")
    fill_in('song_name', :with => 'All You Need Is Love')
    click_on('Add song')
    expect(page).to have_content('All You Need Is Love')
  end
end

describe('create an edit song path', {:type => :feature}) do
  it('create an album, goes to album page, adds the song, then updates the song') do
    album = Album.new("Pork Soda", nil, nil, nil, nil)
    album.save
    visit("/albums/#{album.id}")
    fill_in('song_name', :with => 'DMV')
    click_on('Add song')
    click_on('DMV')
    fill_in('name', :with => 'My Name is Mud')
    fill_in('writer', :with => 'Les Claypool')
    fill_in('lyrics', :with => 'My name is mud')
    click_on('Update song')
    click_on('My Name is Mud')
    expect(page).to have_content('My Name is Mud')
  end
end
