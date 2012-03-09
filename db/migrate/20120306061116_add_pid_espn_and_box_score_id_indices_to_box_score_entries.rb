class AddPidEspnAndBoxScoreIdIndicesToBoxScoreEntries < ActiveRecord::Migration
  def change
    add_index :box_score_entries, :pid_espn
    add_index :box_score_entries, :box_score_id
  end
end
