module ActionDispatch::Routing
  # class RouteSet #:nodoc:
    # Ensure Devise modules are included only after loading routes, because we
    # need devise_for mappings already declared to create filters and helpers.
    # prepend Devise::RouteSet
  # end

  class Mapper
    def translator_routes
      namespace :translator, controller: 'translations', defaults: { format: 'json' } do
        get :translations
        post :translate
      end
    end
  end
end
