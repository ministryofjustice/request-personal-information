class CreateInformationRequest < ActiveRecord::Migration[7.1]
  def change
    create_table :information_requests do |t|
      t.string :subject, null: false
      t.string :full_name, null: false
      t.string :other_names
      t.timestamps
    end
  end
end
