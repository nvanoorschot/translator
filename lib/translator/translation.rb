module Translator
  class Translation < ActiveRecord::Base
    # validations
    validates :key, :locale, presence: true
    validates :key, uniqueness: { scope: :locale }

    def self.translate(options)
      options.each do |locale, translations|
        translations.select { |key, value| value.present? }.each do |key, value|
          if translation = find_by(locale: locale, key: key)
            translation.update(value: value)
          else
            create(locale: locale, key: key, value: value)
          end
        end
      end
    end
  end
end
