module Translator
  # Acts as the controller for the Translation class.
  class TranslationsController < ActionController::Base
    # GET translator/translations
    def translations
      render json: I18n.translations.to_json, status: 200
    end

    # POST translator/translate
    def translate
      Translator::Translation.translate(translate_params)
      render json: { result: 'ok' }, status: 200
    end

    private

    def translate_params
      params.require(:translations)
    end
  end
end
