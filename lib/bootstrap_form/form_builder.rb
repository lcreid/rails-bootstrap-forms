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

    # also remove `file_field` because it doesn't get some of the wrappers -- I think.
    (field_helpers - %i[label check_box radio_button fields_for fields hidden_field]).each do |selector|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{selector}(method, options={})  # def text_field(method, options = {})
          classes = ["#{selector == :range_field ? 'form-range' : 'form-control'}"]
          options.merge!(control_options(classes, method, options))
          label_text = options.delete(:label)
          help_text = options.delete(:help)

          @template.content_tag(:div, **wrapper_options("mb-3", options)) do
            result = if options.delete(:floating)
              super + "\n" + label(method, label_text, **label_options(["form-label"], method, options))
            else
              label(method, label_text, **label_options(["form-label"], method, options)) + "\n" + super
            end

            result += generate_error_messages(method)

            result += generate_help(method, help_text)

            result
          end
        end
      RUBY_EVAL
    end

    bootstrap_alias :fields_for

    def check_box(method, options={}, checked_value="1", unchecked_value="0", &block)
      show_error_message = !!options.delete(:error_message)
      classes = ["form-check-input"]
      options.merge!(control_options(classes, method, options))
      label_text = options.delete(:label)
      label_text = yield if block
      help_text = options.delete(:help)

      @template.content_tag(:div, **check_box_wrapper_options(%w[form-check mb-3], options)) do
        label_classes = ["form-check-label"]
        # Ugh. The order of operations affects where we delete `hide_label`. It affects the label and control classes.
        label_classes += ["visually-hidden"] if options.delete(:hide_label) || options[:skip_label]
        result = if options.delete(:skip_label)
                   super
                 else
                   super + "\n" + label(method, label_text, **label_options(label_classes, method, options))
                 end
        result += generate_error_messages(method) if show_error_message
        result += generate_help(method, help_text)
        result
      end
    end
    bootstrap_alias :check_box

    private

    def label_options(label_classes, method, options)
      label_classes += Array(options.delete(:label_class)) if options[:label_class]
      label_classes += ["required"] if required_field?(options, method)
      {
        class: label_classes,
        for: options[:id]
      }.compact
    end

    def wrapper_options(wrapper_classes, options)
      wrapper = options.delete(:wrapper)
      wrapper_classes = Array(options.delete(:wrapper_class) || wrapper&.[](:classes) || wrapper_classes)
      wrapper_classes += ["form-floating"] if options[:floating]
      {
        class: wrapper_classes
      }.compact
    end

    def check_box_wrapper_options(wrapper_classes, options)
      classes_to_add = Array(options.delete(:wrapper_class))
      wrapper = options.delete(:wrapper)
      classes_to_add += Array(wrapper[:classes]) if wrapper
      # The next couple of lines are a tremendous hack just because comparing classes is order dependent,
      # and the old implementation had this funny order for the classes.
      wrapper_classes = normalize_classes(wrapper_classes)
      wrapper_classes.insert(1, "form-check-inline") if options.delete(:inline)
      wrapper_classes += classes_to_add
      wrapper_classes += ["form-floating"] if options[:floating]
      {
        class: wrapper_classes.compact
      }.compact
    end

    def control_options(classes, method, options)
      classes += ["position-static"] if options[:hide_label] || options[:skip_label]
      classes += ["is-invalid"] if error?(method)
      {
        class: classes,
        required: required_field?(options, method),
        placeholder: options[:floating] && object.class.human_attribute_name(method)
      }.compact
    end

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
    def generate_error_messages(method)
      return unless error?(method)

      @template.content_tag(:div, class: "invalid-feedback") do
        object.class.try(:reflections)&.each do |association_name, a|
          next unless a.is_a?(ActiveRecord::Reflection::BelongsToReflection)
          next unless a.foreign_key == method.to_s

          object.errors[association_name].each do |error|
            object.errors.add(method, error)
          end
        end

        object.errors[method].join(", ")
      end
    end
    # rubocop:enable Metrics/AbcSize

    def generate_help(method, help_text)
      return if help_text == false

      help_klass ||= "form-text text-muted"
      help_text ||= get_help_text_by_i18n_key(method)
      help_tag ||= :small

      @template.content_tag(help_tag, help_text, class: help_klass) if help_text.present?
    end

    def get_help_text_by_i18n_key(name)
      return unless object

      partial_scope = if object_class.respond_to?(:model_name)
                        object_class.model_name.name
                      else
                        object_class.name
                      end

      # First check for a subkey :html, as it is also accepted by i18n, and the
      # simple check for name would return an hash instead of a string (both
      # with .presence returning true!)
      help_text = nil
      ["#{name}.html", name, "#{name}_html"].each do |scope|
        break if help_text

        help_text = scoped_help_text(scope, partial_scope)
      end
      help_text
    end

    def object_class
      if !object.class.is_a?(ActiveModel::Naming) &&
         object.respond_to?(:klass) && object.klass.is_a?(ActiveModel::Naming)
        object.klass
      else
        object.class
      end
    end

    def scoped_help_text(name, partial_scope)
      underscored_scope = "activerecord.help.#{partial_scope.underscore}"
      downcased_scope = "activerecord.help.#{partial_scope.downcase}"

      help_text = translated_help_text(name, underscored_scope).presence

      help_text ||= if (text = translated_help_text(name, downcased_scope).presence)
                      warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                      text
                    end

      help_text
    end

    def translated_help_text(name, scope)
      ActiveSupport::SafeBuffer.new I18n.t(name, scope: scope, default: "")
    end

    def normalize_classes(classes)
      Array(classes).flat_map { |item| item.is_a?(Array) ? normalize_classes(item) : item.split }
    end
  end
end
