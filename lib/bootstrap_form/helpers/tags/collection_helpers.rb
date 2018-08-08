# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      module CollectionHelpers # :nodoc:
        attr_reader :method, :options, :value

        def initialize(bootstrap_builder, name, value, options)
          @bootstrap_builder = bootstrap_builder
          @method = name
          @options = options
          @value = value
        end
      end
    end
  end
end
