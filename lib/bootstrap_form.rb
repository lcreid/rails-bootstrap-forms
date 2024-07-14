require "action_view"
# require "action_pack"
require "bootstrap_form/action_view_extensions/form_helper"
require "bootstrap_form/form_builder"
require "bootstrap_form/configuration"

module BootstrapForm
  # extend ActiveSupport::Autoload

  # eager_autoload do
  #   autoload :Configuration
  #   autoload :FormBuilder
  #   autoload :FormGroupBuilder
  #   autoload :FormGroup
  #   autoload :Components
  #   autoload :Inputs
  #   autoload :Helpers
  # end

  class << self
    # def eager_load!
    #   super
    #   BootstrapForm::Components.eager_load!
    #   BootstrapForm::Helpers.eager_load!
    #   BootstrapForm::Inputs.eager_load!
    # end

    def config
      @config ||= BootstrapForm::Configuration.new
    end

    def configure
      yield config
    end
  end
end

# require "bootstrap_form/engine" if defined?(Rails)
