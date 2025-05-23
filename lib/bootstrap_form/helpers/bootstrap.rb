module BootstrapForm
  module Helpers
    module Bootstrap
      include ActionView::Helpers::OutputSafetyHelper

      def alert_message(title, options={})
        css = options[:class] || "alert alert-danger"
        return unless object.respond_to?(:errors) && object.errors.full_messages.any?

        tag.div class: css do
          if options[:error_summary] == false
            title
          else
            tag.p(title) + error_summary
          end
        end
      end

      def error_summary
        return unless object.errors.any?

        tag.ul(class: "rails-bootstrap-forms-error-summary") do
          object.errors.full_messages.reduce(ActiveSupport::SafeBuffer.new) do |acc, error|
            acc << tag.li(error)
          end
        end
      end

      def errors_on(name, options={})
        return unless error?(name)

        hide_attribute_name = options[:hide_attribute_name] || false
        custom_class = options[:custom_class] || false

        tag.div class: custom_class || "invalid-feedback" do
          errors = if hide_attribute_name
                     object.errors[name]
                   else
                     object.errors.full_messages_for(name)
                   end
          safe_join(errors, ", ")
        end
      end

      def static_control(*args)
        options = args.extract_options!
        name = args.first

        static_options = options.merge(
          readonly: true,
          control_class: [options[:control_class], static_class].compact
        )

        static_options[:value] = object.send(name) unless static_options.key?(:value)

        text_field_with_bootstrap(name, static_options)
      end

      def custom_control(*args, &)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &)
      end

      def prepend_and_append_input(name, options, &)
        options = options.extract!(:prepend, :append, :input_group_class).compact

        input = capture(&) || ActiveSupport::SafeBuffer.new

        input = attach_input(options, :prepend) + input + attach_input(options, :append)
        input << generate_error(name)
        options.present? &&
          input = tag.div(input, class: ["input-group", options[:input_group_class]].compact)
        input
      end

      def input_with_error(name, &)
        input = capture(&)
        input << generate_error(name)
      end

      def input_group_content(content)
        return content if content.include?("btn")

        tag.span(content, class: "input-group-text")
      end

      def static_class
        "form-control-plaintext"
      end

      private

      def attach_input(options, key)
        tags = [*options[key]].map do |item|
          input_group_content(item)
        end
        safe_join(tags)
      end
    end
  end
end
