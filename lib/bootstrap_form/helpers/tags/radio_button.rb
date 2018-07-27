# frozen_string_literal: true

require "bootstrap_form/helpers/bootstrap"
require_relative "base"
require_relative "checkable"

module BootstrapForm
  module Helpers
    module Tags
      class RadioButton < Base
        include BootstrapForm::Helpers::Bootstrap
        include Checkable

        def initialize(object_name, method_name, template_object, tag_value, *args)
          @tag_value = tag_value
          options = args.extract_options!.symbolize_keys!
          super object_name, method_name, template_object, options
        end

        def render
          unless @options[:custom]
            wrapper_class.append("disabled") if @options[:disabled]
          end
          radio_html = @template_object.radio_button_without_bootstrap(@method_name, @tag_value, control_options)

          label_options = { value: @tag_value, class: label_class }
          label_options[:for] = @options[:id] if @options[:id].present?

          wrapper_div do
            if @options[:skip_label]
              radio_html
            else
              radio_html.concat(@template_object.label(@method_name, @options[:label], label_options))
            end
          end
        end

        def custom_class
          "custom-radio"
        end
      end
    end
  end
end
