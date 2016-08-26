require_relative './../db_config.rb'
DbConfig.connect

class Country < Sequel::Model

  one_to_many :incidents

  def validate
    super
    validates_presence [:name, :code]
  end

  def self.exist?(code)
    Country.with_code(code).count == 1
  end

  def self.with_code(code)
    where('code = ?', code)
  end

  def self.by_name(name)
    where('name = ?', name)
  end
end
