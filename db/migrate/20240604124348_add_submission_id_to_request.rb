class AddSubmissionIdToRequest < ActiveRecord::Migration[7.1]
  def change
    change_table :information_requests, bulk: true do |t|
      t.column :submission_id, :string
      t.column :submitted_at, :timestamp
    end
  end
end
