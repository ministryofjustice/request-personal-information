require "active_support/concern"

module Dateable
  extend ActiveSupport::Concern

  class_methods do
    def date_for_form(name)
      define_method "#{name}=" do |value|
        super(value)

        return if value.nil?

        # assign actual value to form
        date = attributes[name.to_s]
        instance_variable_set("@form_#{name}", { 3 => date.day, 2 => date.month, 1 => date.year })
      end

      define_method "form_#{name}" do
        instance_variable_get("@form_#{name}")
      end

      define_method "form_#{name}=" do |values|
        instance_variable_set("@form_#{name}", values)

        # set actual value to nil if form value is incomplete
        if values.nil? || send("form_#{name}").values.any?(nil)
          send("#{name}=", nil)
          return
        end

        # set actual value to nil if form value is invalid
        begin
          send("#{name}=", Date.new(values[1], values[2], values[3]))
        rescue Date::Error
          send("#{name}=", nil)
        end
      end

      # Validation methods

      define_method "check_#{name}_presence" do
        if send("form_#{name}").nil?
          errors.add("form_#{name}", :blank)
        end
      end

      define_method "check_#{name}" do
        # shortcut if the form value is empty because presence is validated elsewhere
        return if send("form_#{name}").nil?

        # Check the actual value, it is only nil here if the form value is invalid
        if send(name).nil?
          errors.add("form_#{name}", :invalid)
        end
      end
    end
  end
end
