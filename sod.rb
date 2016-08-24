require 'grape'
require 'rack/cors'

require './db_config.rb'
require './sod_data.rb'

DbConfig.connect

module Sod
  class Application < Grape::API

    default_format :json
    format :json

    use Rack::Cors do
      allow do
        origins 'http://sod.quimera.suse'
        resource '*', headers: :any, methods: :get
      end
    end

    get '/' do
      JSON.parse(SodData.new.years_overview)
    end

    route_param :year do
      get do
        JSON.parse(SodData.new.overview_for([params[:year]]))
      end

      route_param :month do
        get do

          JSON.parse(SodData.new.overview_for([params[:year], params[:month]]))
        end
      end
    end
  end
end
