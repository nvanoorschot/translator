module I18n
  @translations = {}

  class << self
    def translations
      lookups = Translator::Translation.where(key: lookup_keys(@translations)).pluck(:locale, :key, :value)

      @translations.map do |locale, translations|
        [locale, translations.map do |key, value|
          [key, lookups.detect { |e| e[0] == locale.to_s && e[1] == key.to_s }&.third]
        end.to_h]
      end.to_h
    end

    def translations_reset
      @translations = {}
    end

    # Adds every lookup of a translation to a separate Hash.
    # This Hash will contain all translations used in the current session.
    # Watch out for gems like SimpleForm for they will look a translation in multiple places
    # resulting in more translations being requested then are relevant.
    #
    # 'super' will abort itself if no translation was found. Therefore the key is added to the Hash
    # before the lookup takes place. This ensures we can translate untranslated keys.
    def translate(key, options = {})
      current_locale = options[:locale] || locale
      @translations[current_locale] = {} unless @translations[current_locale]
      @translations[current_locale][key] = nil
      super
    end
    alias_method :t, :translate

    private

    def lookup_keys(translations)
      translations.map { |locale, translation| translation.keys }.flatten.uniq
    end
  end
end
