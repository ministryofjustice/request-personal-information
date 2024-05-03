class InformationRequest < ApplicationRecord
  attr_accessor :date_of_birth

  def for_self?
    subject == "self"
  end

  def possessive_pronoun
    for_self? ? "your" : "their"
  end

  def to_hash
    {
      subject:,
      full_name:,
      other_names:,
      date_of_birth:,
    }
  end

end
