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

  desc 'update country names'
  task :country_code do
    countries = [
      ["Afghanistan","AFG"],
      ["Albania","ALB"],
      ["Algeria","DZA"],
      ["Andorra","AND"],
      ["Angola","AGO"],
      ["Antigua and Barbuda","GLP"],
      ["Argentina","ARG"],
      ["Armenia","ARM"],
      ["Australia","AUZ"],
      ["Austria","AUT"],
      ["Azerbaijan","AZE"],
      ["Bahamas","BHS"],
      ["Bahrain","BHR"],
      ["Bangladesh","BGD"],
      ["Barbados","BRB"],
      ["Belarus","BLR"],
      ["Belgium","BFR"],
      ["Belize","BLZ"],
      ["Benin","BEN"],
      ["Bhutan","BTN"],
      ["Bolivia","BOL"],
      ["Bosnia-Herzegovina","BHF"],
      ["Botswana","BWA"],
      ["Brazil","BRA"],
      ["Brunei","BRN"],
      ["Bulgaria","BGR"],
      ["Burkina Faso","BFA"],
      ["Burundi","BDI"],
      ["Cambodia","KHM"],
      ["Cameroon","CMR"],
      ["Canada","CAN"],
      ["Central African Republic","CAF"],
      ["Chad","TCD"],
      ["Chile","CHX"],
      ["China","CHI"],
      ["Colombia","COL"],
      ["Comoros","COM"],
      ["Costa Rica","CRI"],
      ["Croatia","HRV"],
      ["Cuba","CUB"],
      ["Cyprus","CNM"],
      ["Czech Republic","CZE"],
      ["Czechoslovakia","CZE,SVK"],
      ["Democratic Republic of the Congo","COD"],
      ["Denmark","DNK"],
      ["Djibouti","DJI"],
      ["Dominica","DMA"],
      ["Dominican Republic","DOM"],
      ["East Germany (GDR)","DEU"],
      ["East Timor","TLX"],
      ["Ecuador","ECD"],
      ["Egypt","EGY"],
      ["El Salvador","SLV"],
      ["Equatorial Guinea","GNR"],
      ["Eritrea","ERI"],
      ["Estonia","EST"],
      ["Ethiopia","ETH"],
      ["Falkland Islands","FLK"],
      ["Fiji","FJI"],
      ["Finland","FIN"],
      ["France","FXX"],
      ["French Guiana","GUF"],
      ["French Polynesia","FJI"],
      ["Gabon","GAB"],
      ["Gambia","GMB"],
      ["Georgia","GEG"],
      ["Germany","DEU"],
      ["Ghana","GHA"],
      ["Gibraltar","ESX"],
      ["Greece","GRC"],
      ["Grenada","GRD"],
      ["Guadeloupe","GLP"],
      ["Guatemala","GTM"],
      ["Guinea","GIN"],
      ["Guinea-Bissau","GNB"],
      ["Guyana","GUY"],
      ["Haiti","HTI"],
      ["Honduras","HND"],
      ["Hong Kong","HKG"],
      ["Hungary","HUN"],
      ["Iceland","ISL"],
      ["India","INX"],
      ["Indonesia","IDN"],
      ["International","YEM"],
      ["Iran","IRN"],
      ["Iraq","RR"],
      ["Ireland","IRL"],
      ["Israel","ISR"],
      ["Italy","ITX"],
      ["Ivory Coast","CIV"],
      ["Jamaica","JAM"],
      ["Japan","JPH"],
      ["Jordan","JOR"],
      ["Kazakhstan","KAZ"],
      ["Kenya","KEN"],
      ["Kosovo","KOS"],
      ["Kuwait","KWT"],
      ["Kyrgyzstan","KGZ"],
      ["Laos","LAO"],
      ["Latvia","LVA"],
      ["Lebanon","LBN"],
      ["Lesotho","LSO"],
      ["Liberia","LBR"],
      ["Libya","LBY"],
      ["Lithuania","LTU"],
      ["Luxembourg","LUX"],
      ["Macau","MAC"],
      ["Macedonia","MKD"],
      ["Madagascar","MDG"],
      ["Malawi","MWI"],
      ["Malaysia","MYS"],
      ["Maldives","MDV"],
      ["Mali","MLI"],
      ["Malta","MLT"],
      ["Martinique","MTQ"],
      ["Mauritania","MRT"],
      ["Mauritius","MUS"],
      ["Mexico","MEX"],
      ["Moldova","MDA"],
      ["Montenegro","MNE"],
      ["Morocco","MAR"],
      ["Mozambique","MOZ"],
      ["Myanmar","MMR"],
      ["Namibia","NAM"],
      ["Nepal","NPL"],
      ["Netherlands","NLX"],
      ["New Caledonia","NCL"],
      ["New Hebrides","VUT"],
      ["New Zealand","NZS"],
      ["Nicaragua","NIC"],
      ["Niger","NER"],
      ["Nigeria","NGA"],
      ["North Korea","PRK"],
      ["North Yemen","YEM"],
      ["Norway","NOW"],
      ["Pakistan","PAK"],
      ["Panama","PAN"],
      ["Papua New Guinea","PNX"],
      ["Paraguay","PRY"],
      ["People's Republic of the Congo","COD"],
      ["Peru","PER"],
      ["Philippines","PHL"],
      ["Poland","POL"],
      ["Portugal","PRX"],
      ["Qatar","QAT"],
      ["Republic of the Congo","COG"],
      ["Rhodesia","ZWE"],
      ["Romania","ROU"],
      ["Russia","RUA,RUE"],
      ["Rwanda","RWA"],
      ["Saudi Arabia","SAU"],
      ["Senegal","SEN"],
      ["Serbia","SRS"],
      ["Serbia-Montenegro","SRS"],
      ["Seychelles","SYC"],
      ["Sierra Leone","SLE"],
      ["Singapore","SGP"],
      ["Slovak Republic","SVK"],
      ["Slovenia","SVN"],
      ["Solomon Islands","SLB"],
      ["Somalia","SOP"],
      ["South Africa","SAX"],
      ["South Korea","KOX"],
      ["South Sudan","SDS"],
      ["South Vietnam","VNM"],
      ["South Yemen","YEM"],
      ["Soviet Union","RUA,RUE"],
      ["Spain","ESX"],
      ["Sri Lanka","LKA"],
      ["St. Kitts and Nevis","GLP"],
      ["St. Lucia","LCA"],
      ["Sudan","SDN"],
      ["Suriname","SUR"],
      ["Swaziland","SWZ"],
      ["Sweden","SWE"],
      ["Switzerland","CHE"],
      ["Syria","SYZ"],
      ["Taiwan","TWN"],
      ["Tajikistan","TJK"],
      ["Tanzania","TZA"],
      ["Thailand","THA"],
      ["Togo","TGO"],
      ["Trinidad and Tobago","TTD"],
      ["Tunisia","TUN"],
      ["Turkey","TUR"],
      ["Turkmenistan","TKM"],
      ["Uganda","UGA"],
      ["Ukraine","UKR"],
      ["United Arab Emirates","ARE"],
      ["United Kingdom","ENG"],
      ["United States","USB"],
      ["Uruguay","URY"],
      ["Uzbekistan","UZB"],
      ["Vanuatu","VUT"],
      ["Vatican City","VAT"],
      ["Venezuela","VEN"],
      ["Vietnam","VNM"],
      ["Wallis and Futuna","NCL"],
      ["West Bank and Gaza Strip","GAZ"],
      ["West Germany (FRG)","DEU"],
      ["Western Sahara","SAH"],
      ["Yemen","YEM"],
      ["Yugoslavia","SVN,HRV,BIS,BHF,SRV,SRS,KOS,MNE,ALB,MKD"],
      ["Zaire","COD"],
      ["Zambia","ZMB"],
      ["Zimbabwe","ZWE"],
    ]

    countries.each do |country_row|
      country = Country.by_name(country_row[0])
      country.update({code_name: country_row[1]})
    end
  end
end
