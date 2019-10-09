# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      module CollectionHelpers # :nodoc:
        class Builder < BootstrapForm::FormBuilder
          def initialize(builder)
            @builder = builder
          end

          attr_reader :builder
          delegate_missing_to :builder
        end
      end
    end
  end
end
