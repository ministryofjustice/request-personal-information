class InformationRequest < ApplicationRecord
  def possessive_pronoun
    for_self? ? "your" : "their"
  end

  def to_hash
    {
      subject:,
      full_name:,
      other_names:,
    }
  end

private

  def for_self?
    subject == "self"
  end
end
