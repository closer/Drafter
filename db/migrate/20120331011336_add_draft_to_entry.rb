class AddDraftToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :draft, :text
  end
end
