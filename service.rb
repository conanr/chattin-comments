require 'logger'
require 'active_record'
require 'sinatra/base'

require 'models/comment.rb'

class Service < Sinatra::Base

  module Helpers
    private

    def env
      @env ||= ENV["RACK_ENV"] || ENV["SINATRA_ENV"] || "development"
    end

    def production?
      @env == "production"
    end

    def development?
      @env == "development"
    end

    def json_body
      request.body.rewind
      JSON.parse(request.body.read)
    end
  end

  register Helpers
  helpers  Helpers

  configure do
    databases = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(databases[env])

    if development?
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end
  end

  mime_type :json, "application/json"

  before do
    content_type :json
  end

  get '/comments/presentation/:id' do
    presentation_id = params[:id].to_i

    Comment.where(presentation_id: presentation_id).to_json
  end

  post '/comments/presentation/:id' do
    presentation_id = params[:id].to_i
    Comment.create!(json_body).to_json
  end
end
