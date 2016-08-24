require_relative './../db_config.rb'
DbConfig.connect

class Incident < Sequel::Model

  many_to_one :country

  def validate
    super
    validates_presence [:date]
  end
end
