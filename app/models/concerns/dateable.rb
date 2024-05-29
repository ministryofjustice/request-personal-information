require "active_support/concern"

module Dateable
  extend ActiveSupport::Concern

  included do
    validate :check_form_date
  end

  class_methods do
    def date_for_form(name)
      define_method "#{name}=" do |value|
        super(value)

        return if value.nil?

        date = attributes[name.to_s]

        instance_variable_set("@form_#{name}", { 3 => date.day, 2 => date.month, 1 => date.year })
      end

      define_method "form_#{name}" do
        instance_variable_get("@form_#{name}")
      end

      define_method "form_#{name}=" do |values|
        instance_variable_set("@form_#{name}", values)

        if values.nil? || send("form_#{name}").values.any?(nil)
          send("#{name}=", nil)
          return
        end

        begin
          send("#{name}=", Date.new(values[1], values[2], values[3]))
        rescue Date::Error
          send("#{name}=", nil)
          errors.add("form_#{name}", :invalid)
        end
      end

      define_method "check_form_date" do
        if send("form_#{name}").nil?
          errors.add("form_#{name}", :blank)
          return
        end

        if send("form_#{name}").values.any?(nil)
          errors.add("form_#{name}", :invalid)
          return
        end

        begin
          values = send("form_#{name}")
          send("#{name}=", Date.new(values[1], values[2], values[3]))
        rescue Date::Error
          errors.add("form_#{name}", :invalid)
        end
      end
    end
  end
end
