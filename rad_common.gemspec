$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'rad_common/version'

Gem::Specification.new do |s|
  s.name = 'rad_common'
  s.version = RadCommon::VERSION
  s.authors = ['Gary Foster']
  s.email = ['gary@radicalbear.com']
  s.homepage = 'https://www.radicalbear.com/'
  s.summary = 'A library of common functions for a rad bear app'
  s.description = 'A library of common functions for a standard business web app, developed by Radical Bear'
  s.license = 'MIT'
  s.metadata['rubygems_mfa_required'] = 'true'
  s.required_ruby_version = '>= 3.0.4'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'active_storage_validations'
  s.add_dependency 'audited', '~> 4.9'
  s.add_dependency 'authtrail'

  # TODO: remove this override when we replace authy with twilio verify, see Task 37169
  s.add_dependency 'authy', '< 3.0.0'

  s.add_dependency 'aws-sdk-s3'
  s.add_dependency 'bootstrap4-kaminari-views', '~> 1.0.1'
  s.add_dependency 'devise'
  s.add_dependency 'sassc'
  s.add_dependency 'devise-authy'
  s.add_dependency 'devise_invitable'
  s.add_dependency 'devise-security', '0.16.0' # locked, see Task 35711
  s.add_dependency 'faker'
  s.add_dependency 'haml-rails', '~> 2.0'
  s.add_dependency 'hashids'
  s.add_dependency 'image_processing', '~> 1.9'
  s.add_dependency 'kaminari', '~> 1.2.1'

  # TODO: remove these 3 once the mail gem is up to date, see Task 37200
  s.add_dependency 'net-imap'
  s.add_dependency 'net-pop'
  s.add_dependency 'net-smtp'

  s.add_dependency 'nokogiri'
  s.add_dependency 'pg'
  s.add_dependency 'premailer-rails', '~> 1.10.2'
  s.add_dependency 'pretender'
  s.add_dependency 'puma', '~> 5.6'
  s.add_dependency 'pundit'
  s.add_dependency 'rails', '~> 6.1.4'
  s.add_dependency 'rails_email_validator'
  s.add_dependency 'sendgrid-ruby'
  s.add_dependency 'sentry-rails'
  s.add_dependency 'sentry-ruby'
  s.add_dependency 'sidekiq', '~> 6.4.1'
  s.add_dependency 'sidekiq-failures'
  s.add_dependency 'simple_form', '~> 5.0'
  s.add_dependency 'strip_attributes'
  s.add_dependency 'text'
  s.add_dependency 'twilio-ruby', '~> 5.63'
  s.add_dependency 'webpacker'

  s.add_development_dependency 'active_record_doctor'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'haml_lint'
  s.add_development_dependency 'listen', '~> 3.0.5'
  s.add_development_dependency 'rspec-rails'

  # keep up to date with latest rubocop supported by hound
  # http://help.houndci.com/en/articles/2461415-supported-linters
  s.add_development_dependency 'rubocop', '1.5.2'

  s.add_development_dependency 'rubocop-rails'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
