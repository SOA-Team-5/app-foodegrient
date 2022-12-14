# frozen_string_literal: true

require 'http'
# require_relative '../../models/entities/menu'

module Foodegrient
  module Spoonacular
    # Library for Spoonacular API utilities
    class Api
      def initialize(token)
        @food_token = token
      end

      def menu_data(ingredients)
        Request.new(@food_token).menu(ingredients).parse
      end

      class Utils
        def build_query(ingredients)
          query = 'recipes/findByIngredients'
          ingredients.each_with_index do |ingredient, index|
            query += index.zero? ? "?ingredients=#{ingredient}" : ",+#{ingredient}"
          end
          query
        end
      end

      # Sends out HTTP requests to Spoonacular API
      class Request
        def initialize(token)
          @food_token = token
        end

        API_ROOT = 'https://api.spoonacular.com/'

        def build_query(ingredients)
          query = 'recipes/findByIngredients'
          ingredients.each_with_index do |ingredient, index|
            query += index.zero? ? "?ingredients=#{ingredient}" : ",+#{ingredient}"
          end
          query
        end

        def call_food_url(url)
          result = HTTP.headers('x-api-key' => @food_token).get(url)
          Response.new(result).tap do |response|
            raise(response.error) unless response.successful?
          end
        end

        def menu(ingredients)
          query = build_query(ingredients)
          recipes_url = API_ROOT + query
          call_food_url(recipes_url)
        end
      end

      # Decorates HTTP responses from Spoonacular API
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          # 401 => Errors::Unauthorized,
          # 404 => Errors::NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
