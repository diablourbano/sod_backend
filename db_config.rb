require 'sequel'
require 'dotenv'
Dotenv.load

class DbConfig

  def self.connect
    Sequel::Model.plugin :timestamps
    Sequel::Model.plugin :validation_helpers

    database = {
                 adapter: ENV['ADAPTER'],
                 host: ENV['HOST'],
                 port: ENV['PORT'],
                 database: ENV['DATABASE'],
                 username: ENV['USERNAME'],
                 password: ENV['PASSWORD'],
                 encoding: 'utf8'
               }

    Sequel::Model.db = Sequel.connect(database)
  end
end
