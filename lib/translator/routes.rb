# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def translator_routes
        namespace :translator, controller: 'translations', defaults: { format: 'json' } do
          get :translations
          post :translate
        end
      end
    end
  end
end
