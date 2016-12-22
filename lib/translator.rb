module Translator
  # Disable the ability to pass default translations to the I18n.translate function.
  mattr_accessor :disable_default_translations
  @@disable_default_translations = false

  # Load the settings from the host app.
  def self.setup
    yield self
  end
end

require 'translator/i18n_patch'
require 'translator/translation'
require 'translator/reset'

if defined?(Rails)
  require 'translator/engine'
  require 'translator/routes'
  require 'translator/translations_controller'
end
