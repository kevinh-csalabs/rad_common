module RadCommon
  class Engine < ::Rails::Engine
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    require 'audited'
    require 'authority'
    require 'devise'
    require 'devise-authy'
    require 'devise_invitable'
    require 'faker'
    require 'font-awesome-rails'
    require 'haml-rails'
    require 'kaminari'
    require 'bootstrap4-kaminari-views'
    require 'momentjs-rails'
    require 'nokogiri'
    require 'pg'
    require 'premailer/rails'
    require 'schema_validations'
    require 'sentry-raven'
    require 'sidekiq'
    require 'simple_form'
    require 'bootstrap'
  end
end
