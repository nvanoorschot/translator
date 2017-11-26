# The main namespace for this gem.
module Translator
end

require 'translator/i18n_patch'
require 'translator/translation'
require 'translator/reset'

if defined?(Rails)
  require 'translator/engine'
  require 'translator/routes'
  require 'translator/translations_controller'
end
