# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


Rails.application.configure do
  config.action_mailer.smtp_settings = {
    :address => "smtp.mandrillapp.com",
    :port => "587",
    :domain => "theherd.io",
    :user_name => ,
    :password => ,
    :authentication => "plain",
    :enable_starttls_auto => true
  }

end

