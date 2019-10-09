# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      module CollectionHelpers # :nodoc:
        extend ActiveSupport::Autoload

        autoload :Builder

        attr_reader :object, :options, :text, :value

        def initialize(bootstrap_builder, object, text, value, options)
          @bootstrap_builder = bootstrap_builder
          @object = object
          @options = options
          @text = text
          @value = value
        end
      end
    end
  end
end
