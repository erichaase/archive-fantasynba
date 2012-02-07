// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// todo
//   jQuery Dialog for warnings/errors?
//   jQuery Progressbar?

$(document).ready(function(){
  $("button#update").click(function() { requestData("ratings/now"); });
  requestData("ratings");
  // update $("p#status") if getJSON failed
});

function requestData ( url ) {
  $("p#status").html("updating: " + url);
  $.getJSON(url,function (data) {
    // assert that oXmlHttp.getResponseHeader("Content-Type") contains "application/json"
    // add error checking to determine if json data is valid
    // error/warning if status != 200
    //   $("p#status").html("An error occurred while updating (statusText = '" + oXmlHttp.statusText + "')");
    fillTable(data);
    $("p#status").html(""); // include time
  });
}

function fillTable (oJsonData) {
  // add error checking to determine if json data is valid

  table = "\n  <table>\n";
  appendHeader();
  counter = 0
  $.each(oJsonData, function(index, bse) {
    if (counter == 20) {
      appendHeader();
      counter = 0
    }
    appendPlayer(bse);
    counter += 1
  });
  table += "  </table>\n";

  $("div#table").html(table);
}


function appendHeader () {
  table += "    <tr>\n";
  table += "      <td class=\"h_player\">Name</td>\n";
  table += "      <td class=\"h_player\">BS</td>\n";
  table += "      <td class=\"h_player\">RW</td>\n";
  table += "      <td class=\"h_stat\">MIN</td>\n";
  table += "      <td class=\"h_stat\">FG</td>\n";
  table += "      <td class=\"h_stat\">FT</td>\n";
  table += "      <td class=\"h_stat\">3PT</td>\n";
  table += "      <td class=\"h_stat\">PTS</td>\n";
  table += "      <td class=\"h_stat\">REB</td>\n";
  table += "      <td class=\"h_stat\">AST</td>\n";
  table += "      <td class=\"h_stat\">STL</td>\n";
  table += "      <td class=\"h_stat\">BLK</td>\n";
  table += "      <td class=\"h_stat\">TO</td>\n";
  table += "      <td class=\"h_rating\">FG%</td>\n";
  table += "      <td class=\"h_rating\">FT%</td>\n";
  table += "      <td class=\"h_rating\">3PT</td>\n";
  table += "      <td class=\"h_rating\">PTS</td>\n";
  table += "      <td class=\"h_rating\">REB</td>\n";
  table += "      <td class=\"h_rating\">AST</td>\n";
  table += "      <td class=\"h_rating\">STL</td>\n";
  table += "      <td class=\"h_rating\">BLK</td>\n";
  table += "      <td class=\"h_rating\">TO</td>\n";
  table += "      <td class=\"h_total\">TOTAL</td>\n";
  table += "    </tr>\n";
}

function appendPlayer (bse) {
  prefix = "";
  table += "    <tr>\n";
  table += "      <td class=\"" + prefix + "player\"><a target=\"_blank\" href=\"http://espn.go.com/nba/player/gamelog/_/id/" + bse.pid_espn +  "/\">" + bse.fname + " " + bse.lname + "</a></td>\n";
  table += "      <td class=\"" + prefix + "player\"><a target=\"_blank\" href=\"http://scores.espn.go.com/nba/boxscore?gameId=" + bse.gid_espn + "\">" + "bs" + "</a></td>\n";
  table += "      <td class=\"" + prefix + "player\"><a target=\"_blank\" href=\"http://www.rotoworld.com/content/playersearch.aspx?searchname=" + bse.lname + ",%20" + bse.fname + "\">" + "rw" + "</a></td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.min + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.fgm + "-" + bse.fga + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.ftm + "-" + bse.fta + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.tpm + "-" + bse.tpa + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.pts + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.reb + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.ast + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.stl + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.blk + "</td>\n";
  table += "      <td class=\"" + prefix + "stat\">" + bse.to + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_fgp.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_ftp.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_tpm.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_pts.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_reb.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_ast.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_stl.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_blk.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "rating\">" + bse.r_to.toFixed(1) + "</td>\n";
  table += "      <td class=\"" + prefix + "total\">" + bse.r_tot.toFixed(1) + "</td>\n";
  table += "    </tr>\n";
}
