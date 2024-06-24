# require 'bootstrap_form/aliasing'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder
    class << self
      private

      # Creates the methods *_without_bootstrap ~and *_with_bootstrap~.
      #
      # If your application did not include the rails gem for one of the dsl
      # methods, then a name error is raised and suppressed. This can happen
      # if your application does not include the actiontext dependency due to
      # `rich_text_area` not being defined.
      def bootstrap_alias(field_name)
        alias_method :"#{field_name}_without_bootstrap", field_name
        # alias_method field_name, :"#{field_name}_with_bootstrap"
      rescue NameError # rubocop:disable Lint/SuppressedException
      end
    end
    def initialize(object_name, object, template, options)
      @label_col = options[:label_col] || "col-sm-2"
      @control_col = options[:control_col] || "col-sm-10"
      @label_errors = !!options[:label_errors]
      @inline_errors = options[:inline_errors] || !@label_errors
      super
    end

    # def color_field(method, options = {})
    #   @template.content_tag(:div, class: "mb-3") do
    #     options[:class] = "form-control"
    #     label(method, class: "form-label") + "\n" + super
    #   end
    # end

    (field_helpers - %i[label check_box radio_button fields_for fields hidden_field file_field]).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(method, options = {})  # def text_field(method, options = {})
          @template.content_tag(:div, class: "mb-3") do
            options[:class] = "form-control"
            label(method, class: "form-label") + "\n" + super
          end
        end                                    # end
      RUBY_EVAL
    end

    bootstrap_alias :fields_for
  end
end
