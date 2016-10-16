module I18n
  @translations = {}

  class << self
    def translations
      # lookups = Translator::Translation.where(key: lookup_keys(@translations)).
      #                                   pluck(:locale, :key, :value)

      # @translations.map do |locale, translations|
      #   [locale, translations.map do |key, options|
      #     [key, options.merge(value: lookups.detect { |e| e[0] == locale.to_s && e[1] == key.to_s }&.third)]
      #   end.to_h]
      # end.to_h
      @translations
    end

    # Clears the @translations variable. If not cleared the variable would continue to grow with new
    # translations on each .
    def translations_reset
      @translations = {}
    end

    # Adds every lookup of a translation to a separate Hash.
    # This Hash will contain all translations used in the current session.
    # Watch out for gems like SimpleForm for they will look for a translation in multiple places
    # resulting in more translations being requested then are actually used.
    #
    # 'super' will abort itself if no translation was found. Therefore the key is added to the Hash
    # before the lookup takes place. This ensures we can translate untranslated keys.
    def translate(key, options = {})
      current_locale = options[:locale] || locale
      @translations[current_locale] = {} unless @translations[current_locale]
      @translations[current_locale][key] = { options: interpolations(options) }
      @translations[current_locale][key][:defaults] ||= options[:default] || []
      @translations[current_locale][key][:value] = super
    end
    alias_method :t, :translate

    private

    # @param options [Hash] with the options as passed to the translate function.
    # @return [Hash] with the options that are relevant for the translator.
    def interpolations(options)
      options.except(*I18n::RESERVED_KEYS, :locale)
    end

    # @params translations [Array] that holds all of the translatable items.
    # @return [Array] with all unique translatable keys.
    def lookup_keys(translations)
      translations.map { |_locale, translation| translation.keys }.flatten.uniq
    end
  end
end
