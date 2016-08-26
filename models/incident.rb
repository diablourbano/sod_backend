require_relative './../db_config.rb'
DbConfig.connect

class Incident < Sequel::Model
  plugin :json_serializer

  many_to_one :country

  def validate
    super
    validates_presence [:date]
  end

  def self.select_data_for(date_fragment)

    root_level = root_level_for(date_fragment)
    root = []

    root_level.each do |level|
      level.values[:countries] = JSON.parse(group_by_countries(date_fragment, level).to_json)
      level.values[:date] = level.values[:date].strftime('%Y-%m-%d')

      root << level.values
    end

    root
  end

  def self.root_level_for(date_fragment)
    fetch(%Q[SELECT date_trunc('#{date_fragment}', date) as date,
                    sum(kills) + sum(injuries) as casualties,
                    count(id) as incidents
             FROM incidents
             GROUP BY date_trunc('#{date_fragment}', date)
             ORDER BY date;]).entries
  end

  def self.group_by_countries(date_fragment, level)
    fetch(%Q[SELECT sum(kills) + sum(injuries) as casualties,
                    count(incidents.id) as incidents,
                    countries.code_name as country
             FROM incidents
             RIGHT JOIN countries ON incidents.country_id = countries.id
             WHERE extract(#{date_fragment} from date) = #{level.date.year}
             GROUP BY country_id, code_name;]).entries
  end

  def date_fragment
    self[:date_fragment]
  end

  def casualties
    self[:casualties]
  end

  def country
    self[:country]
  end

  def incidents
    self[:incidents]
  end
end
