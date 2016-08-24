require 'csv'
require 'date'

require_relative './../models/country.rb'
require_relative './../models/incident.rb'

namespace :import_data do

  DATABASE_CONNECTION =  {
                adapter: ENV['ADAPTER'],
                host: 'localhost',
                port: ENV['PORT'],
                database: ENV['DATABASE'],
                username: ENV['USERNAME'],
                password: ENV['PASSWORD'],
                encoding: 'utf8'
              }

  desc 'import data from gdt in csv format'
  task :csv do
    year = 0
    month = 1
    day = 2
    country_code = 3
    country_txt = 4
    kill = 5
    wound = 6
    
    CSV.foreach('./db/gdt.csv') do |row|
      break if row[year].to_i == 1972
      # first, let's import country
      if Country.exist?(row[country_code])
        country = Country.with_code(row[country_code].to_i)
        country_id = country.entries[0].id
      else
        country = Country.create({ name: row[country_txt], code: row[country_code].to_i })
        country_id = country.id
      end


      incident_date = Date.parse("#{row[year]}/#{row[month]}/#{row[day]}")
      kills = row[kill].to_i || 0
      wounds = row[wound].to_i || 0
      Incident.create({ country_id: country_id, date: incident_date, kills: kills, injuries: wounds})
    end

    puts 'done!'
  end
end
