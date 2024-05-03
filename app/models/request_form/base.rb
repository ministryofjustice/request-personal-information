module RequestForm
  class Base
    include ActiveModel::API
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attr_accessor :request

    def name
      self.class.name.demodulize.underscore
    end

    def required?
      true
    end
  end
end
