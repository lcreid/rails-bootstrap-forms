# frozen_string_literal: true

require "byebug"

module BootstrapForm
  module Inputs
    module CollectionCheckBoxes
      extend ActiveSupport::Concern
      include Base
      include InputsCollection

      included do
        def collection_check_boxes_with_bootstrap(*args, &block)
          if block_given?
            with_block(*args, &block)
          else
            without_block(*args)
          end
        end

        bootstrap_alias :collection_check_boxes

        def with_block(*args, &block)
          collection_check_boxes_without_bootstrap(*args) do |builder|
            # Ideas:
            # Figure out how to make a class inherited from `builder`
            # or refactor my code so that we use mostly our regular helpers,
            # but use the underlying Rails helper from `builder` instead of `self`.
            # Maybe the same as the first: pass in my object that has a member
            # that's the builder, and delegates methods to the builder.
            block.call(BootstrapForm::Helpers::Tags::CollectionHelpers::Builder.new(builder))
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
