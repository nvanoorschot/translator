# frozen_string_literal: true

# Holds the tasks in its own namespace
namespace :translator do
  # Stores all translations found in locale yamls in the ActiveRecord database.
  task simple_to_activerecord: :environment do
    Dir.glob("#{Rails.root}/config/locales/*.yml") do |file|
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

  # @param [Object] can be a String, Array or Boolean.
  # @return [String] that represents the given object in a String.
  def parse_value(value)
    case value
    when Array
      "---\n" + value.map { |item| "- #{item}" }.join("\n")
    when true
      "\001"
    when false
      "\002"
    else
      value
    end
  end
end
