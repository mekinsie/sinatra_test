require 'rspec'
require 'album'
require 'song'
require 'pry'
require 'pg'

DB = PG.connect({:dbname => 'record_store_test', :user=>'postgres', :password => 'Epidorkus@11'})
RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM albums *;")
    DB.exec("DELETE FROM songs *;")
  end
end