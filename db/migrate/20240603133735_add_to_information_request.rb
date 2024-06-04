class AddToInformationRequest < ActiveRecord::Migration[7.1]
  def change
    change_table :information_requests, bulk: true do |t|
      t.column :date_of_birth, :date
      t.column :relationship, :string
      t.column :organisation_name, :string
      t.column :requester_name, :string
      t.column :letter_of_consent_id, :integer
      t.column :requester_photo_id, :integer
      t.column :requester_proof_of_address_id, :integer
      t.column :subject_photo_id, :integer
      t.column :subject_proof_of_address_id, :integer
      t.column :prison_service, :boolean
      t.column :probation_service, :boolean
      t.column :hmpps_information, :boolean
      t.column :currently_in_prison, :string
      t.column :current_prison_name, :string
      t.column :recent_prison_name, :string
      t.column :prison_number, :string
      t.column :prison_nomis_records, :boolean
      t.column :prison_security_data, :boolean
      t.column :prison_other_data, :boolean
      t.column :prison_other_data_text, :string
      t.column :prison_date_from, :date
      t.column :prison_date_to, :date
      t.column :probation_office, :string
      t.column :probation_ndelius, :boolean
      t.column :probation_other_data, :boolean
      t.column :probation_other_data_text, :string
      t.column :probation_date_from, :date
      t.column :probation_date_to, :date
      t.column :laa, :boolean
      t.column :opg, :boolean
      t.column :moj_other, :boolean
      t.column :moj_other_where, :string
      t.column :laa_text, :string
      t.column :laa_date_from, :date
      t.column :laa_date_to, :date
      t.column :opg_text, :string
      t.column :opg_date_from, :date
      t.column :opg_date_to, :date
      t.column :moj_other_text, :string
      t.column :moj_other_date_from, :date
      t.column :moj_other_date_to, :date
      t.column :contact_address, :string
      t.column :contact_email, :string
      t.column :upcoming_court_case, :string
      t.column :upcoming_court_case_text, :string
    end
  end
end
