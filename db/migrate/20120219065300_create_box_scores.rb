class CreateBoxScores < ActiveRecord::Migration
  def change
    create_table :box_scores do |t|
      t.integer :gid_espn
      t.string :status
      t.date :date

      t.timestamps
    end
  end
end
