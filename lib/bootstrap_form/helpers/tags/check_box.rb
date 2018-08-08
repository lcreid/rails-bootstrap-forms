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
          super object_name, method_name, template_object, options.symbolize_keys!
        end

        def render(&block)
          puts "control_options[:multiple]: #{control_options[:multiple]}"
          checkbox_html = @template_object.check_box_without_bootstrap(@method_name, control_options, @checked_value, @unchecked_value)

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

          wrapper_div do
            if @options[:skip_label]
              checkbox_html
            else
              checkbox_html.concat(@template_object.label(label_name, label_description, label_options))
            end
          end
        end

        def custom_class
          "custom-checkbox"
        end
      end
    end
  end
end
