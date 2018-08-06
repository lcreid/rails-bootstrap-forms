# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      module Checkable # :nodoc:
        attr_reader :control_classes
        attr_reader :control_options

        def initialize(object_name, method_name, template_object, options)
          super
          @wrapper_class = if @options[:custom]
                             x = ["custom-control", custom_class]
                             x.append("custom-control-inline") if layout_inline?
                             x
                           else
                             x = ["form-check"]
                             x.append("form-check-inline") if layout_inline?
                             x
                           end
          @wrapper_class.append(@options[:wrapper_class]) if @options[:wrapper_class]

          @control_classes = [@options[:class]]
          @control_classes << "position-static" if @options[:skip_label] || @options[:hide_label]
          @control_classes << "is-invalid" if @template_object.has_error?(@method_name)

          @control_options = @options.except(:custom,
            :error_message,
            :help,
            :hide_label,
            :inline,
            :label,
            :label_class,
            :skip_label,
            :wrapper_class)
          @control_options[:class] = control_classes
                                     .prepend(@options[:custom] ? "custom-control-input" : "form-check-input")
                                     .compact
                                     .join(" ")

          @label_classes = [
            @options[:custom] ? "custom-control-label" : "form-check-label",
            @options[:label_class]
          ]
          @label_classes << hide_class if @options[:hide_label]
        end

        def label_class
          label_classes.compact.join(" ")
        end

        attr_reader :label_classes

        def layout_inline?
          @template_object.layout_inline?(@options[:inline])
        end

        attr_reader :wrapper_class

        def wrapper_div
          @template_object.content_tag(:div, class: wrapper_class.compact.join(" ")) do
            html = yield
            html.concat(@template_object.generate_error(@method_name)) if @options[:error_message]
            html
          end
        end
      end
    end
  end
end
