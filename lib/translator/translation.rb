module Translator
  class Translation < ApplicationRecord
    # validations
    validates :key, :locale, presence: true
    validates :locale, inclusion: I18n.available_locales.map(&:to_s)
    validates :key, uniqueness: { scope: :locale }

    def self.translate(translations)
      translations.each do |key, value|
        if value
          if translation = find_by(locale: I18n.locale, key: key)
            translation.update(value: value)
          else
            create(locale: I18n.locale, key: key, value: value)
          end
        end
      end
    end
  end
end
