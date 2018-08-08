module BootstrapForm
  module Helpers
    module Tags
      class CollectionCheckBoxes
        class CheckBoxBuilder
          attr_reader :method, :options, :value

          def initialize(bootstrap_builder, name, value, options)
            @bootstrap_builder = bootstrap_builder
            @method = name
            @options = options
            @value = value
          end

          def check_box(html_options = {})
            @bootstrap_builder.check_box(@method, @options.merge(html_options), @value)
          end
        end
      end
    end
  end
end
