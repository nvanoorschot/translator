require 'translator/i18n_patch'
require 'translator/translation'
require 'translator/translations_controller'
require 'translator/engine'
require 'translator/routes'
require 'translator/reset'

module Translator
  # Disable the ability to pass default translations to the I18n.translate function.
  mattr_accessor :disable_default_translations
  @@disable_default_translations = false

  # Default way to setup Simple Form. Run rails generate simple_form:install
  # to create a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
