class ChangeDefaultStatusOnSearches < ActiveRecord::Migration[8.1]
  def change
    change_column_default :searches, :status, from: "drafted", to: "inactive"
  end
end
