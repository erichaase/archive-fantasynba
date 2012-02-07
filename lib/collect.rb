require 'date'
require 'open-uri'

################################################################################

class BoxScores

  RE_BS_URL = %r`<\s*a\s*href\s*=\s*"\s*\/nba\/boxscore\?gameId=(\d+)\s*"\s*>\s*Box\s*&nbsp\s*;\s*Score\s*<\s*/\s*a\s*>`

  def initialize ( date )
    raise ArgumentError, "'date' argument is not a DateTime object" if date.class != Date
    @date = date
    @boxScores = []
    url = "http://scores.espn.go.com/nba/scoreboard?date=#{@date.strftime('%Y%m%d')}"
    open(url).read.scan(RE_BS_URL) { |gid| @boxScores << BoxScore.new(gid.first.to_i,@date) }
  end

  def save
    @boxScores.each { |bs| bs.save }
  end

end

################################################################################

class BoxScore

  RE_PLAYER = %r`\shref\s*=\s*"([^"]+)"\s*>([^<]+)<[^>]+>\s*,\s*([^<]+)<[^<]+((<\s*td[^>]*>[^<]+<\s*/\s*td\s*>\s*)+)`

  # examples:
  #   <tr align="right" class="odd player-46-130"><td style="text-align:left;" nowrap><a href="http://espn.go.com/nba/player/_/id/130/brian-cardinal">Brian Cardinal</a>, PF</td><td>12</td><td>1-1</td><td>1-1</td><td>0-0</td><td>0</td><td>0</td><td>0</td><td>1</td><td>0</td><td>0</td><td>1</td><td>2</td><td>+18</td><td>3</td></tr>
  #   <tr align="right" class="even player-46-1966"><td style="text-align:left;" nowrap><a href="http://espn.go.com/nba/player/_/id/1966/lebron-james">LeBron James</a>, SF</td><td>40</td><td>9-15</td><td>2-5</td><td>1-4</td><td>1</td><td>3</td><td>4</td><td>6</td><td>1</td><td>1</td><td>6</td><td>2</td><td>-24</td><td>21</td></tr>

  def initialize ( gid, date )
    raise ArgumentError, "'gid' argument is not a Fixnum object" if gid.class  != Fixnum
    raise ArgumentError, "'date' argument is not a Date object"  if date.class != Date
    @gid = gid
    @date = date
    @boxScoreEntries = []
    url = "http://scores.espn.go.com/nba/boxscore?gameId=#{gid}"
    open(url).read.scan(RE_PLAYER) { |href, name, pos, rest|
      stats = rest.split(%r`\s*<\s*/\s*td\s*>\s*<\s*td[^>]*>\s*`)

      if stats.size >= 1
        stats[0].sub!(%r`^\s*<\s*td[^>]*>\s*`,'')
        stats[-1].sub!(%r`\s*<\s*/\s*td\s*>\s*$`,'')
      end

      [href, name, pos].concat(stats).each { |x| x.strip!; x.downcase! }

      case stats.size
      when 1
        # message stored in stats[0]
        #   'dnp coach's decision'
        #   not entered game
        #   etc.
      when 13..14
        # assertions
        #   data types
        #   nulls

        bse = {}
        bse[:date]     = @date
        bse[:gid_espn] = @gid
        bse[:pid_espn] = href.scan(/\/id\/(\d+)\//)[0][0].to_i
        bse[:fname]    = name[/^\S+/]
        bse[:lname]    = name[/\S+$/]
        bse[:pos]      = pos
        bse[:min]      = stats[0].to_i
        bse[:fgm]      = stats[1][/^\d+/].to_i
        bse[:fga]      = stats[1][/\d+$/].to_i
        bse[:tpm]      = stats[2][/^\d+/].to_i
        bse[:tpa]      = stats[2][/\d+$/].to_i
        bse[:ftm]      = stats[3][/^\d+/].to_i
        bse[:fta]      = stats[3][/\d+$/].to_i
        bse[:oreb]     = stats[4].to_i

        case stats.size
          when 14
            bse[:dreb]      = stats[5].to_i
            bse[:reb]       = stats[6].to_i
            bse[:ast]       = stats[7].to_i
            bse[:stl]       = stats[8].to_i
            bse[:blk]       = stats[9].to_i
            bse[:to]        = stats[10].to_i
            bse[:pf]        = stats[11].to_i
            bse[:plusminus] = stats[12].to_i
            bse[:pts]       = stats[13].to_i
          when 13
            bse[:dreb]      = nil
            bse[:reb]       = stats[5].to_i
            bse[:ast]       = stats[6].to_i
            bse[:stl]       = stats[7].to_i
            bse[:blk]       = stats[8].to_i
            bse[:to]        = stats[9].to_i
            bse[:pf]        = stats[10].to_i
            bse[:plusminus] = stats[11].to_i
            bse[:pts]       = stats[12].to_i

        end

        @boxScoreEntries << BoxScoreEntry.new(bse)

      else
        warn "size of 'stats' is #{stats.size}, should be 1, 13 or 14: #{stats.inspect}"
      end
    }
  end

  def save
    BoxScoreEntry.where(:gid_espn => @gid).each { |bse| bse.delete }
    @boxScoreEntries.each { |bse| bse.save }
  end
end

################################################################################

def lastDay
  n = DateTime.now
  date = Date.new(n.year, n.mon, n.mday)
  date -= 1 if n.hour <= 12
  return date
end
