# Holds the tasks in its own namespace
namespace :translator do
  # Stores all translations found in locale yamls in the ActiveRecord database.
  task simple_to_activerecord: :environment do
    backend = I18n::Backend::Simple.new
    Dir.glob("#{Rails.root.to_s}/config/locales/*.yml") do |file|
      YAML.load_file(file).each do |locale, translations|
        join_keys(translations).each do |key, value|
          Translator::Translation.create(locale: locale, key: key, value: value)
        end
      end
    end
  end

  # Recursive function to turn the nested hash into a two dimension array.
  # @param hash [Hash] with translation keys and values.
  def join_keys(hash, parent_keys = [])
    hash.inject([]) do |keys, (key, value)|
      full_key = parent_keys + [key]
      if value.is_a?(Hash)
        keys += join_keys(value, full_key)
      elsif !value.nil?
        keys << [full_key.join('.'), value]
      end
      keys
    end
  end
end
