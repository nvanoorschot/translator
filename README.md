Webinterface for Rails i18n-activerecord

# Installation

Gemfile
`gem 'translator'`

app/assets/stylesheets/application.css
`*= require translator`

app/assets/javascripts/application.js
`//= require translator`

app/controllers/application_conroller.rb
`include Translator`

app/config/routes.rb
`translator_routes`

# Limitations

- Does not work with more then one locale at the same time in a view. All translations are assumed
  to be in locale as set by I18n.locale

# TODO
  - Add tests
  - Make it independent from:
    - es6
    - sass
