# frozen_string_literal: true

require 'roda'
require 'slim'

require_relative '../../spec/spec_helper'

module Foodegrient
  # Web App
  class App < Roda
    plugin :render, engine: 'slim', views: 'app/views'
    plugin :assets, css: 'style.css', path: 'app/views/assets'
    plugin :common_logger, $stderr
    plugin :halt

    route do |routing|
      routing.assets # load CSS
      response['Content-Type'] = 'text/html; charset=utf-8'

      # GET /
      routing.root do
        view 'home'
      end

      routing.on 'menu' do
        routing.is do
          # POST /project/
          routing.post do
            keywords = routing.params['keywords']
            # routing.halt 400 unless (gh_url.include? 'github.com') &&
            #                         (gh_url.split('/').count >= 3)
            # owner, project = gh_url.split('/')[-2..]

            routing.redirect "menu/#{keywords}"
          end
        end

        routing.on String do |keywords|
          # GET /menu/result/keywords
          routing.get do
            # rec = Spoonacular::MenuMapper
            #       .new(API_TOKEN)
            #       .search(%w[keywords])
            result = Foodegrient::ApiUtils.new(API_TOKEN).menu(keywords.split(" "))
            view('result', locals: { keywords: keywords, res: result })
          end
        end
      end
    end
  end
end