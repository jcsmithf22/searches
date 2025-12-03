class AddStatusToSearches < ActiveRecord::Migration[8.1]
  def change
    add_column :searches, :status, :string, default: "drafted", null: false
  end
end
