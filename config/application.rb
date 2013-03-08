require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Selfstarter
  
  class Application < Rails::Application
    
    config.crowdtilt_mode = 'sandbox'  #sandbox or production
    #Crowdtilt API key/secret
    config.crowdtilt_production_key = ENV['CROWDTILT_PRODUCTION_KEY']
    config.crowdtilt_production_secret = ENV['CROWDTILT_PRODUCTION_SECRET']
    config.crowdtilt_sandbox_key = ENV['CROWDTILT_SANDBOX_KEY']
    config.crowdtilt_sandbox_secret = ENV['CROWDTILT_SANDBOX_SECRET']
    
    # --- Standard Rails Config ---
    config.time_zone = 'Pacific Time (US & Canada)'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_record.whitelist_attributes = true
    # Enable the asset pipeline
    config.assets.enabled = true
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
    # --- Standard Rails Config ---
    
    #loading for ckeditor
    config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
    
    #Fix for getting Devise to work on Heroku deploy
    #Forcing app to not access the DB or models when precompiling
    config.assets.initialize_on_precompile = false
    
    #Paperclip default options
    paperclip_path = "/:id/:style.:extension" 
    if defined?(ENV['CROWDTILT_PRODUCTION_KEY']) && !ENV['CROWDTILT_PRODUCTION_KEY'].nil?
      paperclip_path = ENV['CROWDTILT_PRODUCTION_KEY'] + paperclip_path
    end

    config.paperclip_defaults = {
      storage: :s3,
      s3_credentials: { 
        access_key_id: ENV['AWS_ACCESS_KEY_ID'], 
        access_key_secret: ENV['AWS_SECRET_ACCESS_KEY']  
      },
      path: paperclip_path,
      bucket: "crowdhoster",
      s3_protocol: 'https',
      default_url: '/images/missing_:style.jpg'
    }
    
    #Mailgun options
    config.action_mailer.smtp_settings = {
       :authentication => :plain,
       :address => "smtp.mailgun.org",
       :port => 587,
       :domain => ENV['MAILGUN_DOMAIN'],
       :user_name => ENV['MAILGUN_USERNAME'],
       :password => ENV['MAILGUN_PASSWORD']
      }
     
  end
end