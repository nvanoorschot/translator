require 'minitest/autorun'
require 'i18n'
require 'i18n/backend/active_record'
require 'sqlite3'
require 'translator'

I18n.backend = I18n::Backend::ActiveRecord.new

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: ':memory:'
)

ActiveRecord::Migration[5.0].create_table(:translations) do |t|
  t.string :locale
  t.string :key
  t.text   :value
  t.text   :interpolations
  t.boolean :is_proc, default: false

  t.timestamps
end
