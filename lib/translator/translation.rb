class Translator::Translation < ActiveRecord::Base
  # validations
  validates :key, :locale, presence: true
  validates :key, uniqueness: { scope: :locale }

  def self.translate(locales)
    locales.each do |locale, translations|
      translations.select { |_key, value| value.present? }.each do |key, value|
        if translation = find_by(locale: locale, key: key)
          translation.update(value: value)
        else
          create(locale: locale, key: key, value: value)
        end
      end
    end

    clear_cache(locales) if I18n.respond_to?(:cache_store) && I18n.cache_store
  end

  def self.clear_cache(locales)
    case I18n.cache_store
    when ActiveSupport::Cache::RedisStore
      locales.each do |locale, translations|
        translations.each do |key, _value|
          # TODO: use scan instead of keys to iterate over collection.
          # redis.del(redis.scan(0, match: "i18n//#{locale}/*").presence)

          redis.del(redis.keys(cache_key(locale, key)).presence)
        end
      end
    else
      warn 'Only the Redis cache_store is implemented. Switch to Redis or submit a PR.'
    end
  end

  def self.cache_key(locale, key)
    "i18n/#{I18n.cache_namespace}/#{locale}/#{key.hash}/*"
  end

  def self.redis
    @redis ||= Redis::Store.new
  end
end
