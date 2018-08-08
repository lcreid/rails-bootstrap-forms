module BootstrapForm
  module Helpers
    module Tags
      class CollectionRadioButtons
        class RadioButtonBuilder
          include CollectionHelpers

          def radio_button(html_options = {})
            @bootstrap_builder.radio_button(@method, @value, @options.merge(html_options))
          end
        end
      end
    end
  end
end
