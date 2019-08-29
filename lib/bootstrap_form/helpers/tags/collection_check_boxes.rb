# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      class CollectionCheckBoxes
        class CheckBoxBuilder
          include CollectionHelpers

          def check_box(html_options={})
            @bootstrap_builder.check_box(@text, @options.merge(html_options), @value, nil)
          end
        end
      end
    end
  end
end
