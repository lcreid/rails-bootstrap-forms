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
          radio_options = @options.except(:label, :label_class, :error_message, :help, :inline, :custom, :hide_label, :skip_label, :wrapper_class)
          radio_classes = control_classes

          label_classes = [@options[:label_class]]
          label_classes << hide_class if @options[:hide_label]

          if @options[:custom]
            radio_options[:class] = radio_classes.prepend("custom-control-input").compact.join(" ")
            wrapper_class = ["custom-control", "custom-radio"]
            wrapper_class.append("custom-control-inline") if layout_inline?
            label_class = label_classes.prepend("custom-control-label").compact.join(" ")
          else
            radio_options[:class] = radio_classes.prepend("form-check-input").compact.join(" ")
            wrapper_class = ["form-check"]
            wrapper_class.append("form-check-inline") if layout_inline?
            wrapper_class.append("disabled") if @options[:disabled]
            label_class = label_classes.prepend("form-check-label").compact.join(" ")
          end
          radio_html = @template_object.radio_button_without_bootstrap(@method_name, @tag_value, radio_options)

          label_options = { value: @tag_value, class: label_class }
          label_options[:for] = @options[:id] if @options[:id].present?

          wrapper_class.append(@options[:wrapper_class]) if @options[:wrapper_class]

          wrapper_div(wrapper_class.compact.join(" ")) do
            html = if @options[:skip_label]
                     radio_html
                   else
                     radio_html.concat(@template_object.label(@method_name, @options[:label], label_options))
                   end
            html.concat(@template_object.generate_error(@method_name)) if @options[:error_message]
            html
          end
        end
      end
    end
  end
end
