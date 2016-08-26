require_relative './../db_config.rb'
DbConfig.connect

class Incident < Sequel::Model
  plugin :json_serializer

  many_to_one :country

  def validate
    super
    validates_presence [:date]
  end

  def self.select_data_for(date_fragment, extract_root_query)
    root_level = root_level_for(date_fragment, extract_root_query)
    root = []

    root_level.each do |level|
      extract_query = yield(level)
      level.values[:countries] = JSON.parse(group_by_countries(date_fragment, extract_query).to_json)
      level.values[:date] = level.values[:date].strftime('%Y-%m-%d')

      root << level.values
    end

    root
  end

  def self.years_overview(date_fragment)
    select_data_for(date_fragment, nil) do |level|
       %Q[WHERE extract(year from date) = #{level.date.year}]
    end
  end

  def self.year_overview(date_fragment, date_to_search)
    extract_root_query = %Q[WHERE extract(year from date) = #{date_to_search[0]}]

    select_data_for(date_fragment, extract_root_query) do |level|
      %Q[WHERE extract(year from date) = #{date_to_search[0]} AND
               extract(month from date) = #{level.date.month}]
    end
  end

  def self.month_overview(date_fragment, date_to_search)
    extract_root_query = %Q[WHERE extract(year from date) = #{date_to_search[0]} AND
                                  extract(month from date) = #{date_to_search[1]}]

    select_data_for(date_fragment, extract_root_query) do |level|
      %Q[WHERE extract(year from date) = #{date_to_search[0]} AND
               extract(month from date) = #{date_to_search[1]} AND
               extract(day from date) = #{level.date.day}]
    end
  end

  def self.root_level_for(date_fragment, date_to_search)
    fetch(%Q[SELECT date_trunc('#{date_fragment}', date) as date,
                    sum(kills) + sum(injuries) as casualties,
                    count(id) as incidents
             FROM incidents
             #{date_to_search}
             GROUP BY date_trunc('#{date_fragment}', date)
             ORDER BY date;]).entries
  end

  def self.group_by_countries(date_fragment, date_to_search)
    fetch(%Q[SELECT sum(kills) + sum(injuries) as casualties,
                    count(incidents.id) as incidents,
                    countries.code_name as country
             FROM incidents
             RIGHT JOIN countries ON incidents.country_id = countries.id
             #{date_to_search}
             GROUP BY country_id, code_name;]).entries
  end

  def extract_date_query(date_to_search)
    return if date_to_search.nil?
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
