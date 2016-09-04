module Translator
  # Acts as the controller for the Translation class.
  class TranslationsController < ApplicationController
    # GET translator/translations
    def translations
      render json: I18n.translations.to_json
    end

    # POST translator/translate
    def translate
      Translator::Translation.translate(translate_params)
      render json: 'ok'
    end

    private

    def translate_params
      params.require(:translations)
    end
  end
end
