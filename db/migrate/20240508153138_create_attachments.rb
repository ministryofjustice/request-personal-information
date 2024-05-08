class CreateAttachments < ActiveRecord::Migration[7.1]
  def change
    create_table :attachments do |t|
      t.string :key, null: false
      t.timestamps
    end
  end
end
