class RemoveUnusedColumnsFromBoxScoreEntries < ActiveRecord::Migration
  def up
    remove_column :box_score_entries, :pos, :dreb, :gid_espn, :date
  end

  def down
    add_column :box_score_entries, :pos,      :string
    add_column :box_score_entries, :dreb,     :integer
    add_column :box_score_entries, :gid_espn, :integer
    add_column :box_score_entries, :date,     :date
  end
end
