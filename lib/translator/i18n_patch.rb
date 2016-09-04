module I18n
  @translations = {}

  class << self
    def translations
      @translations
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
      @translations[key] = nil
      @translations[key] = super
    end
    alias_method :t, :translate
  end
end
