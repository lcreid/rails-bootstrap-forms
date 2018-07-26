# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      class Base # :nodoc:
        def initialize(object_name, method_name, template_object, options = nil)
          @object_name = object_name
          @method_name = method_name
          @template_object = template_object
          @options = options
        end

        # This is what child classes implement.
        def render
          raise NotImplementedError, "Subclasses must implement a render method"
        end
      end
    end
  end
end
