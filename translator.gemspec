Gem::Specification.new do |s|
  s.name        = 'translator'
  s.version     = '0.0.1'
  s.date        = '2016-09-03'
  s.summary     = 'Makes translating Rails apps easier.'
  s.description = 'Creates a modal with all translatable keys for the current view.'
  s.authors     = ['ForecastXL', 'Nicke van Oorschot']
  s.email       = 'developers@forecastxl.com'
  s.homepage    = 'https://www.forecastxl.com'
  s.license     = 'MIT'

  s.required_ruby_version = ">= 2.3"
  s.require_paths = ['lib']
  s.files       = ['lib/translator.rb']

  s.add_dependency('i18n-active_record')
end
