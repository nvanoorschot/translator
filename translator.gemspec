# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'translator/version'

Gem::Specification.new do |s|
  s.name        = 'translator'
  s.version     = Translator::VERSION
  s.date        = '2016-09-03'
  s.summary     = 'Makes translating Rails apps easier.'
  s.description = 'Creates a modal with all translatable keys for the current view.'
  s.authors     = ['Nicke van Oorschot']
  s.license     = 'MIT'

  # Requirements
  s.required_ruby_version = ['>= 2.3.0', '< 2.6.0']
  s.require_paths = ['lib', 'lib/translator', 'lib/assets/javascripts', 'lib/assets/stylesheets']
  s.files         = Dir['lib/**/*']

  # the gem only works with the activerecord backend, for now.
  s.add_dependency 'i18n-active_record'

  # Install all this in order to run the tests.
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sqlite3'
end
