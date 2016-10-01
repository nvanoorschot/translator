Webinterface for Rails i18n-activerecord

# Installation

add Translator to your: Gemfile

```ruby
gem 'translator', git: 'https://github.com/forecastxl/translator.git'
```

Add the styles to your: app/assets/stylesheets/application.css

```
*= require translator
```

Add the javascripts to your: app/assets/javascripts/application.js

```
//= require translator
```

Include this module in your main controller: app/controllers/application_conroller.rb

```ruby
include Translator::Reset
```

Place this function in your: app/config/routes.rb

You probably want to place this somewhere down the bottom of your routes.rb because these routes will not be called often and/or are not vital to the working of your app.

```ruby
translator_routes
```

Call the following Javascript function.

```javascript
new Translator()
```

You can do this in the console of you favorite browser but easier would be if you place a link or button somewhere in your app that executes this function.

```html
<a href='#' onmousedown='new Translator()'>Translate</a>
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

If you don't like the way the modal looks you can override the styles or define your own. Just make sure that you css is required later in the application.css file then the translate.css. If you don´t like any of it you can choose not to require the translator.css altogether.

There is no html you can edit because all DOM elements are created on the fly by javascript. If you want to
change that you can copy the translator.js to your project and edit it your own liking. Do not forget the remove the require statement from application.js.

# TODO
  - Add tests
  - Make it independent from:
    - sass
  - Better styling of modal
  - Add close button to modal
  - Show interpolations send to the translate function, maybe switch between interpolated or not,
    this is usefull when no translation yet exist so the translator can see which interpolations are
    send to the translate function.
  - Retreive the translations only once (and clear the cache at the same time?)

  - Start modal with keys without translation
  - Show the translation of a key in different languages
  - Show the result of Google translate (or similar webservice)
  - Warn when one or more translations are missing. Maybe directly open the modal when any are missing.
