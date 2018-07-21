# frozen_string_literal: true

module Translator
  class Translation < ActiveRecord::Base
    # VALIDATIONS
    #
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

      # Deletes both the Symbol and String version of the key. It matters.
      def clear_redis(locales)
        caches = locales.map do |locale, translations|
          translations.map do |key, _value|
            redis.keys(cache_key(locale, key.to_s)) + redis.keys(cache_key(locale, key.to_sym))
          end
        end.flatten

        return 0 if caches.empty?
        redis.del(caches)
      end

      # @return [String] that is the key which the cached values is stored under.
      def cache_key(locale, key)
        "i18n/#{I18n.cache_namespace}/#{locale}/#{key.hash}*"
      end

      # @return [Redis::Store] that handles the storing of the cache.
      def redis
        @redis ||= Redis::Store.new
      end
    end
  end
end
