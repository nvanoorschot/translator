Webinterface for Rails i18n-activerecord

# Installation

add Translator to your: Gemfile

```ruby
gem 'translator', git: 'https://github.com/forecastxl/translator.git'
```

Add the styles to your: app/assets/stylesheets/application.css

```css
*= require translator
```

Add the javascripts to your: app/assets/javascripts/application.js

```javascript
//= require translator
```

Include this module in your main controller: app/controllers/application_conroller.rb

```ruby
include Translator::Reset
```

Place this function in your: app/config/routes.rb

Tip: place this somewhere down the bottom of your routes.rb if this not called often or if it is not vital to the working of your app.

```ruby
translator_routes
```

Add the 'translator' css class to any html element you want to trigger the translator popup.

```html
<a href='#' class='translator'>Translate</a>
```

You can also call the following Javascript function directly to make the translator modal open.

```javascript
new Translator().openModal()
```

### Apartment

If you have the apartment gem included in your project make sure to add the translation classes to your list of excluded models (assuming that you do not want to store translations per tenant):

```ruby
Apartment.configure do |config|
  config.excluded_models = %w(
    I18n::Backend::ActiveRecord::Translation
    Translator::Translation
  )
end

```


# Migration

If you have already have translations in a certain backend and decide to move to a different one you can run a task to copy the translations into the new backend.

* Make sure the target backend exists before copying
* The task copies the translations to the target, it will NOT destroy the translations in the source
* If any keys already exist in the target backend then their values will be overwritten
* Keys in the target backend that do not exist in the source will remain untouched

### Limitations

* At this moment only the possible to copy from simple(yaml) to activerecord backend.


```console
rake translator:simple_to_activerecord
```


# Configuration

### Security

Translator implements no means of security or role-based access rights. Probably the easiest way of limiting who can translate is by enabling the routes to only the translators or only in specific environments.

If you are using Devise the authenicate users you can change your routes.rb to something like this.

```ruby
authenticate :user, lambda { |user| user.admin? } do
  translator_routes
end
```

and/or

```ruby
translator_routes if Rails.env.staging?
```

### Styling

If you don't like the way the modal looks you can override the styles or define your own. Just make sure that your css is required later in the application.css file then the translator.css. If you don´t like any of it you can choose not to require the translator.css altogether.

There is no html you can edit because all DOM elements are created on the fly by javascript. If you want to
change that you can copy the translator.js to your project and edit it your own liking.

# TODO
  - Fix the more complex interpolation in the modal
    - When getting the result from t() then the interpolations already took place
    - How to get the string that will be used for the interpolations?
  - Add tests

# Nice to haves
  - Retreive the translations only once? (and clear the cache at the same time?)
  - Start modal with keys without translation
  - Show the translation of a key in different languages
  - Show the result of Google translate (or similar webservice)
  - Warn when one or more translations are missing. Maybe directly open the modal when any are missing.
  - Maybe show all translations have been tried before the current one was found. This shows the translator and developer which translations are looked up without success.
