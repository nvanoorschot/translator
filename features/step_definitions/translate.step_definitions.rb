# frozen_string_literal: true

Given(/^the following translations exist$/) do |table|
  params = {}
  table.hashes.each do |row|
    params[row[:locale]] = {} unless params[row[:locale]]
    params[row[:locale]][row[:key]] = row[:value]
  end

  Translator::Translation.translate(params)
end

Given(/^the current locale is ':(.+)'$/) do |locale|
  @locale = locale.to_sym
  I18n.locale = @locale
end

When(/^the translation '(.+)' is requested$/) do |key|
  @key = key.to_sym
  @value = I18n.t(@key)
end

Then(/^it is logged in the @translations variable$/) do
  assert_equal(I18n.translations[@locale][@key][:value], @value)
end
