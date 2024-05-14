module RequestForm
  class Base
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    attr_accessor :request, :back

    def name
      self.class.name.demodulize.underscore
    end

    def required?
      true
    end

    def saveable_attributes
      attributes
    end
  end
end
