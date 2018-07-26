# frozen_string_literal: true

require "bootstrap_form/helpers/bootstrap"
require_relative "base"
require_relative "checkable"

module BootstrapForm
  module Helpers
    module Tags
      class CheckBox < Base
        include BootstrapForm::Helpers::Bootstrap
        include Checkable

        def initialize(object_name, method_name, template_object, checked_value = "1", unchecked_value = "0", options = nil)
          @checked_value = checked_value
          @unchecked_value = unchecked_value
          super object_name, method_name, template_object, options
        end

        def render(&block)
          @options = @options.symbolize_keys!
          check_box_options = @options.except(:label, :label_class, :error_message, :help, :inline, :custom, :hide_label, :skip_label, :wrapper_class)
          check_box_classes = control_classes

          label_classes = [@options[:label_class]]
          label_classes << hide_class if @options[:hide_label]

          if @options[:custom]
            check_box_options[:class] = (["custom-control-input"] + check_box_classes).compact.join(" ")
            wrapper_class = ["custom-control", "custom-checkbox"]
            wrapper_class.append("custom-control-inline") if layout_inline?
            label_class = label_classes.prepend("custom-control-label").compact.join(" ")
          else
            check_box_options[:class] = (["form-check-input"] + check_box_classes).compact.join(" ")
            wrapper_class = ["form-check"]
            wrapper_class.append("form-check-inline") if layout_inline?
            label_class = label_classes.prepend("form-check-label").compact.join(" ")
          end

          checkbox_html = @template_object.check_box_without_bootstrap(@method_name, check_box_options, @checked_value, @unchecked_value)
          label_content = block_given? ? @template_object.capture(&block) : @options[:label]
          label_description = label_content || (@template_object.object && @template_object.object.class.human_attribute_name(@method_name)) || @method_name.to_s.humanize

          label_name = @method_name
          # label's `for` attribute needs to match checkbox tag's id,
          # IE sanitized value, IE
          # https://github.com/rails/rails/blob/5-0-stable/actionview/lib/action_view/helpers/tags/base.rb#L123-L125
          if @options[:multiple]
            label_name =
              "#{@method_name}_#{@checked_value.to_s.gsub(/\s/, '_').gsub(/[^-[[:word:]]]/, '').mb_chars.downcase}"
          end

          label_options = { class: label_class }
          label_options[:for] = @options[:id] if @options[:id].present?

          wrapper_class.append(@options[:wrapper_class]) if @options[:wrapper_class]

          @template_object.content_tag(:div, class: wrapper_class.compact.join(" ")) do
            html = if @options[:skip_label]
                     checkbox_html
                   else
                     checkbox_html.concat(@template_object.label(label_name, label_description, label_options))
                   end
            html.concat(@template_object.generate_error(@method_name)) if @options[:error_message]
            html
          end
        end
      end
    end
  end
end
