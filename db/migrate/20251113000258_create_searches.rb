class CreateSearches < ActiveRecord::Migration[8.1]
  def change
    create_table :searches do |t|
      t.string :name # Name of the search
      t.text :notes
      t.boolean :disabled, default: false

      # API fields
      t.text :query # Wuery to search with, e.g. q=iphone ipad
      t.string :category_ids # Ebay category, e.g. category_ids=29792
      # Filters
      t.string :buying_options # e.g. filter=buyingOptions:{FIXED_PRICE|BEST_OFFER}
      t.string :conditions # Broader condition , e.g. filter=conditions:{NEW|USED} (Options are NEW, USED, and UNSPECIFIED)
      t.string :condition_ids # Condition IDs, e.g. filter=conditionIds:{1000|1500} (New is 1000, New other is 1500, etc)
      t.text :excluded_sellers # List of sellers to exclude, e.g. filter=excludeSellers:{rpsseller|bigSales}
      t.string :excluded_category_ids # List of categories to exclude from the search, e.g. filter=excludeCategoryIds:{15032|31387}
      # Combined to form price field, e.g. filter=price:[10..50]
      t.integer :minimum_cents
      t.integer :maximum_cents
      t.string :price_currency # If not specified either in user profile or search, use USD as default (tenative)
      t.boolean :search_in_description # e.g. filter=searchInDescription:true
      t.text :sellers # List of sellers to filter by, e.g. filter=sellers:{rpsSeller|bigSales}

      # t.boolean :title_only, default: false # This will be used if :search_in_description doesn't do what we want

      t.timestamps

      # Other fields not included can be found at these links (and additional details)
      # https://developer.ebay.com/api-docs/buy/static/ref-buy-browse-filters.html
      # https://developer.ebay.com/api-docs/buy/browse/resources/item_summary/methods/search
      # https://developer.ebay.com/api-docs/sell/static/metadata/condition-id-values.html
    end
  end
end
