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

-

# TODO
  - Add tests
  - Make it independent from:
    - es6
    - sass
  - Better styling of modal
  - Start modal with keys without translation
  - Show interpolations send to the translate function, maybe switch between interpolated or not
  - Show the translation of a key in different languages
  - Show the result of Google translate (or similar webservice)
