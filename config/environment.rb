# frozen_string_literal: true

require 'roda'
require 'yaml'

module CodePraise
  # Configuration for the App
  class App < Roda
    CONFIG = YAML.safe_load(File.read('config/secrets.yml'))
    FOOD_API_TOKEN = CONFIG['FOOD_API_TOKEN']
  end
end