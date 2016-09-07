if ENV['RACK_ENV'] == 'development'
  require 'dotenv'
  Dotenv.load
end

require 'sequel'

class DbConfig

  def self.connect
    Sequel::Model.plugin :timestamps
    Sequel::Model.plugin :validation_helpers

  if ENV['RACK_ENV'] == 'development'
      database = {
                   adapter: ENV['ADAPTER'],
                   host: 'localhost',
                   port: ENV['PORT'],
                   database: ENV['DATABASE'],
                   username: ENV['USERNAME'],
                   password: ENV['PASSWORD'],
                   encoding: 'utf8'
                 }
  else
    database = ENV['DATABASE_URL']
  end

    Sequel::Model.db = Sequel.connect(database)
  end
end
