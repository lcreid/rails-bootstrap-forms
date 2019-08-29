# frozen_string_literal: true

module BootstrapForm
  module Inputs
    module CollectionCheckBoxes
      extend ActiveSupport::Concern
      include Base
      include InputsCollection

      included do
        def collection_check_boxes_with_bootstrap(*args, &block)
          if block_given?
            with_block(*args, block)
          else
            without_block(*args)
          end
        end

        bootstrap_alias :collection_check_boxes

        def with_block(*args, &block)
          collection_check_boxes_without_bootstrap(*args) do |builder|
            block.call(builder)
          end
        end

        def without_block(*args)
          html = inputs_collection(*args) do |name, value, options|
            options[:multiple] = true
            check_box(name, options, value, nil)
          end
          hidden_field(args.first, value: "", multiple: true).concat(html)
        end
      end
    end
  end
end
