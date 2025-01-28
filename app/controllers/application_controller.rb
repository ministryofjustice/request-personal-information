class ApplicationController < ActionController::Base
  helper :all
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder
end
