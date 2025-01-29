class PagesController < ApplicationController
  def homepage; end

  def feedback
    @feedback = Feedback.new # Create a dummy feedback object
  end

private

  def feedback_params
    params.require(:feedback).permit(:service_satisfaction_level, :comments) # whitelist submitted parameters
  end
end
