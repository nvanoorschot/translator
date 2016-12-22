module I18n
  @translations = {}

  class << self
    attr_reader :translations

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
      value = super
      current_locale = options[:locale] || locale
      @translations[current_locale] = {} unless @translations[current_locale]

      if value.is_a?(Hash)
        value.each do |sub_key, sub_value|
          lookup_key = [key.to_s, sub_key.to_s].join('.')
          @translations[current_locale][lookup_key] = { options: interpolations(options) }
          @translations[current_locale][lookup_key][:defaults] = []
          @translations[current_locale][lookup_key][:value] = sub_value
        end
      else
        @translations[current_locale][key] = { options: interpolations(options) }
        @translations[current_locale][key][:defaults] ||= options[:default] || []
        @translations[current_locale][key][:value] = return_value(value.dup, options)
      end

      value
    end
    alias t translate

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

    def return_value(value, options)
      return if value[/\Atranslation missing: /]

      reverse_interpolation(value, options)
    end

    def reverse_interpolation(value, options)
      return value.to_s if interpolations(options).empty?

      interpolations(options).each do |key, interpolation|
        value.gsub!(%r{#{interpolation}}, "%{#{key}}")
      end

      value
    end
  end
end
