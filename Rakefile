rack_env = ENV['RACK_ENV'] || 'dev'

if rack_env == 'dev'
  require 'dotenv'
  Dotenv.load
end

require 'sequel'

task default: ['db:migrations:apply', :test]

namespace :db do
  if rack_env == 'dev'
    DATABASE_CONNECTION =  {
                  adapter: ENV['ADAPTER'],
                  host: 'localhost',
                  port: ENV['PORT'],
                  database: ENV['DATABASE'],
                  username: ENV['USERNAME'],
                  password: ENV['PASSWORD'],
                  encoding: 'utf8'
                }

    DATABASE = ENV['DATABASE']
    puts ">> Running task on database #{ DATABASE }"

  else
    DATABASE_CONNECTION = ENV['DATABASE_URL']
  end

  namespace :migrations do
    desc 'Creates a new migration in db/migrations'
    task :new, :name do |t, args|
      name = ARGV.last
      migrations_dir = File.join("db", "migrations")
      version ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
      filename = "#{version}_#{name}.rb"

      FileUtils.mkdir_p(migrations_dir)

      open(File.join(migrations_dir, filename), 'w') do |f|
        f << (<<-EOS).gsub("      ", "")
Sequel.migration do
  change do
  end
end
        EOS
      end

      puts ">> Wrote #{ migrations_dir}/#{ filename }"
      task name.to_sym {}
    end

    desc 'Runs all migrations.'
    task :apply do
      Sequel.extension :migration
      db = Sequel.connect(DATABASE_CONNECTION)

      puts '>> Running migrations...'
      Sequel::Migrator.apply(db, 'db/migrations')
      puts '>> All done.'

      Rake::Task['db:schema'].invoke
    end
  end

  desc 'Dumps schema into db/schema.rb'
  task :schema do
    Sequel.extension :schema_dumper
    db = Sequel.connect(DATABASE_CONNECTION, :test => true)

    puts '>> Dumping schema...'
    `pg_dump -s #{DATABASE} > db/schema.sql`
    puts '>> All done.'
  end

  namespace :test do
    DATABASE_TEST_URL = ENV['DATABASE_TEST_URL']

    desc 'prepare test database'
    task :prepare do
      db = Sequel.connect(DATABASE_TEST_URL, :test => true)

      puts '>> preparing test db...'
      `psql #{DATABASE_TEST_URL} -c "DROP SCHEMA public cascade; CREATE SCHEMA public;"`
      `psql #{DATABASE_TEST_URL} < db/schema.sql`
      puts '>> All done.'
    end
  end

  desc 'Deletes the database, use with care'
  task :drop do
    db = Sequel.connect(DATABASE_URL)

    puts '>> Dropping all tables, if you screwed up cancel NOW. (5 second sleep)'
    sleep 5
    db.tables.each { |table| db.drop_table(table) }
    puts '>> All done.'
  end
end
