module RequestForm
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations
    extend ActiveModel::Callbacks

    attr_accessor :request, :back

    # This will allow subclasses to define after_initialize callbacks
    # and is needed for some functionality to work, i.e. acts_as_gov_uk_date
    define_model_callbacks :initialize

    def initialize(*)
      run_callbacks(:initialize) { super }
    end

    def name
      self.class.name.demodulize.underscore
    end

    def required?
      true
    end

    # Add the ability to read/write attributes without calling their accessor methods.
    # Needed to behave more like an ActiveRecord model, where you can manipulate the
    # database attributes making use of `self[:attribute]`
    def [](attr_name)
      instance_variable_get("@#{attr_name}".to_sym)
    end

    # def []=(attr_name, value)
    #   instance_variable_set("@#{attr_name}".to_sym, value)
    # end

    def new_record?
      true
    end
  end
end
