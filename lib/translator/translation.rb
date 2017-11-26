module Translator
  class Translation < ActiveRecord::Base
    # VALIDATIONS
    validates :key, :locale, presence: true
    validates :key, uniqueness: { scope: :locale }

    class << self
      def translate(locales)
        locales.each do |locale, translations|
          translations.select { |_key, value| value.present? }.each do |key, value|
            translation = find_by(locale: locale, key: key)
            translation&.update(value: value) || create(locale: locale, key: key, value: value)
          end
        end

        clear_cache(locales) if I18n.respond_to?(:cache_store) && I18n.cache_store.present?
        true
      end

      private

      def clear_cache(locales)
        case I18n.cache_store
        when ActiveSupport::Cache::RedisStore
          clear_redis(locales)
        else
          warn 'Only the Redis cache_store is implemented. Switch to Redis or submit a PR.'
        end
      end

      # Removes all cached keys from the changed locales. This is a very brute force approach, but
      # one that is guarenteed to work.
      def clear_redis(locales)
        caches = locales.map do |locale, _translations|
          redis.keys("i18n/#{I18n.cache_namespace}/#{locale}/*")
        end.flatten

        return 0 if caches.empty?
        redis.del(caches)
      end

      # Deletes both the Symbol and String version of the key. It matters since it depends on how
      # the keys are searched, how the key is cached.
      def clear_redis_concept(locales)
        caches = locales.map do |locale, translations|
          translations.map do |key, _value|
            cache_keys(locale, key).map { |cache_key| redis.keys(cache_key) }
          end
        end.flatten

        return 0 if caches.empty?
        redis.del(caches)
      end

      # @return [Array<String>] all potential keys that the translation is stored under.
      def cache_keys(locale, key)
        keys = [key.to_s, key.to_sym]
        plural = key[/[^\.]+\z/] if keys.first.include?('.')
        base = keys.first.remove(".#{plural}") if plural && plural_keys(locale).include?(plural)
        keys += [base, base.to_sym] if base

        keys.map { |local_key| "i18n/#{I18n.cache_namespace}/#{locale}/#{local_key.hash}*" }
      end

      # @return [Redis::Store] that handles the storing of the cache.
      def redis
        @redis ||= Redis::Store.new
      end

      def plural_keys(locale)
        keys = I18n.t(:'i18n.plural.keys', locale: locale)
        keys.is_a?(Array) ? keys.map(&:to_s) : keys
      end
    end
  end
end
