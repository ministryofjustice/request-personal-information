class RenameMultipleColumnsInInformationRequests < ActiveRecord::Migration[7.1]
  def change
    rename_column :InformationRequests, :moj_other_date_to, :moj_other_where_date_to
    rename_column :InformationRequests, :moj_other_date_from, :moj_other_where_date_from
  end
end
