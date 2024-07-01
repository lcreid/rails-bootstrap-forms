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

    # also remove `file_field` because it doesn't get some of the wrappers -- I think.
    (field_helpers - %i[label check_box radio_button fields_for fields hidden_field]).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__,  __LINE__ + 1
        def #{selector}(method, options = {})  # def text_field(method, options = {})
          label_classes = ["form-label"]
          label_classes += ["required"] if required_field?(options, method)
          label_options = {
            class: label_classes,
            for: options[:id],
          }.compact

          classes = ["form-control"]
          classes += ["is-invalid"] if error?(method)
          options.merge!(
            {
              class: classes,
              required: required_field?(options, method),
              placeholder: options[:floating] && object.class.human_attribute_name(method),
            }.compact
          )

          wrapper_classes = ["mb-3"]
          wrapper_classes += ["form-floating"] if options[:floating]
          wrapper_options = {
            class: wrapper_classes,
          }.compact

          @template.content_tag(:div, **wrapper_options) do
            result = if options.delete(:floating)
              super + "\n" + label(method, **label_options)
            else
              label(method, **label_options) + "\n" + super
            end

            result += @template.content_tag(:div, class: "invalid-feedback") do
              get_error_messages(method)
            end if error?(method)

            result
          end
        end
      RUBY_EVAL
    end

    bootstrap_alias :fields_for

    private

    def required_field?(options, method)
      if options[:skip_required]
        warn "`:skip_required` is deprecated, use `:required: false` instead"
        false
      elsif options.key?(:required)
        options[:required]
      else
        required_attribute?(object, method)
      end
    end

    def required_attribute?(obj, attribute)
      return false unless obj && attribute

      target = obj.instance_of?(Class) ? obj : obj.class
      return false unless target.respond_to? :validators_on

      presence_validators?(target, obj, attribute) || required_association?(target, obj, attribute)
    end

    def required_association?(target, object, attribute)
      target.try(:reflections)&.any? do |name, a|
        next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
        next unless a.foreign_key == attribute.to_s

        presence_validators?(target, object, name)
      end
    end

    def presence_validators?(target, object, attribute)
      target.validators_on(attribute).select { |v| presence_validator?(v.class) }.any? do |validator|
        if_option = validator.options[:if]
        unless_opt = validator.options[:unless]
        (!if_option || call_with_self(object, if_option)) && (!unless_opt || !call_with_self(object, unless_opt))
      end
    end

    def call_with_self(object, proc)
      proc = object.method(proc) if proc.is_a? Symbol
      object.instance_exec(*[(object if proc.arity >= 1)].compact, &proc)
    end

    def presence_validator?(validator_class)
      validator_class == ActiveModel::Validations::PresenceValidator ||
        (defined?(ActiveRecord::Validations::PresenceValidator) &&
          validator_class == ActiveRecord::Validations::PresenceValidator)
    end

    def error?(name)
      name && object.respond_to?(:errors) && (object.errors[name].any? || association_error?(name))
    end

    def association_error?(name)
      object.class.try(:reflections)&.any? do |association_name, a|
        next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
        next unless a.foreign_key == name.to_s

        object.errors[association_name].any?
      end
    end

    # rubocop:disable Metrics/AbcSize
    def get_error_messages(name)
      object.class.try(:reflections)&.each do |association_name, a|
        next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
        next unless a.foreign_key == name.to_s

        object.errors[association_name].each do |error|
          object.errors.add(name, error)
        end
      end

      object.errors[name].join(", ")
    end
    # rubocop:enable Metrics/AbcSize
  end
end
