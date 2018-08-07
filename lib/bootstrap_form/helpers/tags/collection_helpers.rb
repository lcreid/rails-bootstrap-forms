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
        class Builder # < BootstrapForm::FormBuilder # :nodoc:
          attr_reader :collection_builder

          def check_box(html_options = {})
            collection_builder.check_box(html_options)
          end

          def initialize(collection_builder)
            @collection_builder = collection_builder
          end

          delegate :label, :object, :text, :value, to: :collection_builder
        end
      end
    end
  end
end
