# frozen_string_literal: true

# require "bootstrap_form/form_builder"

# Avoid errors due to circular dependencies of classes
# TODO: Can I get rid of this?
# module BootstrapForm
#   class FormBuilder < ActionView::Helpers::FormBuilder
#   end
# end

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
