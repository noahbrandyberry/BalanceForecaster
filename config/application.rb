require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BalanceForecaster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_view.field_error_proc = Proc.new do |html_tag, instance|
      elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css 'label'
      if elements.first
        html_tag
      else
        if instance.error_message.kind_of?(Array)
          %(#{html_tag}<p class="help-text error-message">#{@name} #{instance.error_message[0]} #{if instance.error_message[1] then "and " + instance.error_message[1] end} </p>).html_safe
        else
          %(#{html_tag}<p class="help-text error-message">#{@name} #{instance.error_message}</p>).html_safe
        end
      end
    end
  end
end
