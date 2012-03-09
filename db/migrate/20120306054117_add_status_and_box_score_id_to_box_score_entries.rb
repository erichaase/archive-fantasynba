class AddStatusAndBoxScoreIdToBoxScoreEntries < ActiveRecord::Migration
  def change
    add_column :box_score_entries, :box_score_id, :integer
    add_column :box_score_entries, :status,       :string
  end
end
