# Holds the tasks in its own namespace
namespace :translator do
  # Stores all translations found in locale yamls in the ActiveRecord database.
  task simple_to_activerecord: :environment do
    backend = I18n::Backend::Simple.new
    Dir.glob("#{Rails.root.to_s}/config/locales/*.yml") do |file|
      puts "Loading #{file}"

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
        keys << [full_key.join('.'), parse_value(value)]
      end
      keys
    end
  end

  def parse_value(value)
    case value
    when Array
      "---\n" + value.map { |e| "- #{e}" }.join("\n")
    when true
      "\001"
    when false
      "\002"
    else
      value
    end
  end
end
