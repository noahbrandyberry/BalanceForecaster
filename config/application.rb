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
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe

      form_fields = [
        'textarea',
        'input',
        'select'
      ]

      html = Nokogiri::HTML::DocumentFragment.parse(html_tag).css("label, " + form_fields.join(', ')).first

      if html.node_name.eql? 'label'
        css_class = html['class'] || "" 
        html.add_class "is-invalid-label"
        html_tag = html.to_s.html_safe
      else
        name = html['name'].scan(/\[([^\)]+)\]/).first.first
        html.add_class "is-invalid-input"
        html = %(#{html}<p class="form-error is-visible">#{name.humanize} #{instance.error_message.join(' and ')}</p>)
        html_tag = html.to_s.html_safe
      end

      html_tag
    end
  end
end
