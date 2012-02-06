class CreateBoxScoreEntries < ActiveRecord::Migration
  def change
    create_table :box_score_entries do |t|
      t.integer :gid_espn
      t.date :date
      t.integer :pid_espn
      t.string :fname
      t.string :lname
      t.string :pos
      t.integer :min
      t.integer :fgm
      t.integer :fga
      t.integer :tpm
      t.integer :tpa
      t.integer :ftm
      t.integer :fta
      t.integer :oreb
      t.integer :dreb
      t.integer :reb
      t.integer :ast
      t.integer :stl
      t.integer :blk
      t.integer :to
      t.integer :pf
      t.integer :plusminus
      t.integer :pts

      t.timestamps
    end
  end
end
