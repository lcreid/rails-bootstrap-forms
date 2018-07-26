# frozen_string_literal: true

module BootstrapForm
  module Helpers
    module Tags
      module Checkable # :nodoc:
        def control_classes
          @control_classes ||= begin
            control_classes = [@options[:class]]
            control_classes << "position-static" if @options[:skip_label] || @options[:hide_label]
            control_classes << "is-invalid" if @template_object.has_error?(@method_name)
            control_classes
          end
        end

        def control_options
          @control_options ||= @options.except(:label,
            :label_class,
            :error_message,
            :help,
            :inline,
            :custom,
            :hide_label,
            :skip_label,
            :wrapper_class)
        end

        def label_classes
          @label_classes ||= begin
            label_classes = [@options[:label_class]]
            label_classes << hide_class if @options[:hide_label]
            label_classes
          end
        end

        def layout_inline?
          @template_object.layout_inline?(@options[:inline])
        end

        def wrapper_div(wrapper_classes)
          @template_object.content_tag(:div, class: wrapper_classes) do
            yield
          end
        end
      end
    end
  end
end
