module Translator::Reset
  # Adds before_action to the host controller it was included in.
  def self.included(base)
    base.before_action :translations_reset
  end

  # Clears the translations hash before each request. If we would not do this then also translations
  # of previous request would be returned. The exception is when a flash message has been set,
  # because these are usually set by a redirect_to and would be cleared and never end up in our
  # translations hash.
  def translations_reset
    I18n.translations_reset unless flash.any? || controller_name == 'translations' || request.xhr?
  end
end
