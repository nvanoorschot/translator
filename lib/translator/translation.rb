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

      clear_cache(options.keys) if I18n.cache_store
    end

    def self.clear_cache(locales)
      case I18n.cache_store
      when ActiveSupport::Cache::RedisStore
        locales.each do |locale|
          # TODO (Nicke) use scan instead of keys to iterate over collection.
          # redis.del(redis.scan(0, match: "i18n//#{locale}/*").presence)
          redis.del(redis.keys("i18n//#{locale}/*").presence)
        end
      else
        raise 'Only the Redis cache_store is implemented. Switch to Redis or add your own logic.'
      end
    end

    def self.redis
      @redis ||= Redis::Store.new
    end
  end
end
