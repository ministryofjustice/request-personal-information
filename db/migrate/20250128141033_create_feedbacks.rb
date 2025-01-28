class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks do |t|
      t.string :service_satisfaction_level
      t.text :comments

      t.timestamps
    end
  end
end
