module RequestForm
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attr_accessor :request, :return_to

    def initialize(**args)
      super
      @request = args[:request]
    end

    def name
      self.class.name.demodulize.underscore
    end

    def required?
      true
    end

    def saveable_attributes
      attributes
    end

    def updateable_attributes
      attributes
    end
  end
end
