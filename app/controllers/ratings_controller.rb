require 'collect'

################################################################################

class RatingsController < ApplicationController
  def index
    #if params[:days]
    #elsif params[:from] and params[:to]
    #else
    #end
    players = []
    BoxScoreEntry.where(:date => lastDay).each { |bse| players << Player.new(bse) }
    players.sort! { |a,b| b.r_tot <=> a.r_tot }
    render :json => players
  end

  def now
    players = []
    date = lastDay
    BoxScores.new(date).save
    BoxScoreEntry.where(:date => date).each { |bse| players << Player.new(bse) }
    players.sort! { |a,b| b.r_tot <=> a.r_tot }
    render :json => players
  end

  def day
    #players = []
    #players.sort! { |a,b| b.r_tot <=> a.r_tot }
    #render :json => players
  end

end

################################################################################


class Player
  attr_reader :r_tot
  def initialize (bse)
    @gid_espn   = bse.gid_espn
    @date       = bse.date
    @pid_espn   = bse.pid_espn
    @fname      = bse.fname
    @lname      = bse.lname
    @pos        = bse.pos
    @min        = bse.min
    @fgm        = bse.fgm
    @fga        = bse.fga
    @tpm        = bse.tpm
    @tpa        = bse.tpa
    @ftm        = bse.ftm
    @fta        = bse.fta
    @oreb       = bse.oreb
    @dreb       = bse.dreb
    @reb        = bse.reb
    @ast        = bse.ast
    @stl        = bse.stl
    @blk        = bse.blk
    @to         = bse.to
    @pf         = bse.pf
    @plusminus  = bse.plusminus
    @pts        = bse.pts
    @created_at = bse.created_at
    @updated_at = bse.updated_at
    if @fga == 0
      @r_fgp = 0.0
    else
      @r_fgp = (((@fgm.to_f / @fga.to_f) - 0.47) * (@fga / 22.8181818181818)) * 55.0266638166801
    end
    if @fta == 0
      @r_ftp = 0.0
    else
      @r_ftp = (((@ftm.to_f / @fta.to_f) - 0.769) * (@fta / 10.4901960784314)) * 25.5465168615693
    end
    @r_tpm = (@tpm - 0.9) * 3.33333333333333
    @r_pts = (@pts - 16.6) * 0.316872427983539
    @r_reb = (@reb - 6.0) * 0.779487179487179
    @r_ast = (@ast - 3.65) * 0.85972850678733
    @r_stl = (@stl - 1.1) * 4.66666666666667
    @r_blk = (@blk - 0.7) * 3.01724137931034
    @r_to  = (@to - 2.08) * -2.36111111111111
    @r_tot = @r_fgp + @r_ftp + @r_tpm + @r_pts + @r_reb + @r_ast + @r_stl + @r_blk + @r_to
  end
end
