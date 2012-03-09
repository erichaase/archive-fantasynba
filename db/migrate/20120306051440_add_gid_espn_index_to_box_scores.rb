class AddGidEspnIndexToBoxScores < ActiveRecord::Migration
  def change
    add_index :box_scores, :gid_espn, :unique => true
  end
end
