# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!


Rails.application.configure do
  config.action_mailer.smtp_settings = {
    :address => "smtp.mandrillapp.com",
    :port => "587",
    :domain => ENV["MANDRILL_DOMAIN"],
    :user_name => ENV["MANDRILL_USERNAME"],
    :password => ENV["MANDRILL_PASSWORD"],
    :authentication => "plain",
    :enable_starttls_auto => true
  }

end

