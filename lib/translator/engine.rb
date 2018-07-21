# frozen_string_literal: true

module Translator
  module Rails
    # By adding the empty class it becomes possible for Rails apps to require the assets.
    class Engine < ::Rails::Engine
    end
  end
end
