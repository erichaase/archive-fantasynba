require 'collect'

namespace :stats do

  desc 'clears database'
  task :clear => :environment do
    BoxScoreEntry.all.each { |bse| bse.delete }
  end

  desc 'prints database'
  task :print => :environment do
    BoxScoreEntry.all.each { |bse| puts "#{bse.gid_espn}: #{bse.fname} #{bse.lname}" }
  end

  desc 'retrieves most recent box score entries and stores them in database'
  task :lastday => :environment do
    BoxScores.new(lastDay).save
  end

end
