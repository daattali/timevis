# Simple timeline with 4 items
dataBasic <- data.frame(
  id = 1:4,
  content = c("Item one", "Item two" ,"Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14"),
  end    = c(NA, NA, "2016-02-04", NA)
)


# Template for world cup HTML of each item
templateWC <- function(stage, team1, team2, score1, score2) {
  sprintf(
    '<table><tbody>
      <tr><td colspan="3"><em>%s</em></td></tr>
      <tr>
        <td>%s</td>
        <th>&nbsp;%s - %s&nbsp;</th>
        <td>%s</td>
      </tr>
      <tr>
        <td><img src="flags/%s.png" width="31" height="20" alt="%s"></td>
        <th></th>
        <td><img src="flags/%s.png" width="31" height="20" alt="%s"></td>
      </tr>
    </tbody></table>',
    stage, team1, score1, score2, team2, gsub("\\s", "", tolower(team1)),
    team1, gsub("\\s", "", tolower(team2)), team2
  )
}

# Data for world cup 2014
dataWC <- data.frame(
  id = 1:7,
  start = c(
    "2014-07-04 13:00",
    "2014-07-04 17:00",
    "2014-07-05 13:00",
    "2014-07-05 17:00",
    "2014-07-08 17:00",
    "2014-07-09 17:00",
    "2014-07-13 16:00"
  ),
  content = c(
    templateWC("quarter-finals", "France", "Germany", 0, 1),
    templateWC("quarter-finals", "Brazil", "Colombia", 2, 1),
    templateWC("quarter-finals", "Argentina", "Belgium", 1, 0),
    templateWC("quarter-finals", "Netherlands", "Costa Rica", "0 (4)", "0 (3)"),
    templateWC("semi-finals", "Brazil", "Germany", 1, 7),
    templateWC("semi-finals", "Netherlands", "Argentina", "0 (2)", "0 (4)"),
    templateWC("final", "Germany", "Argentina", 1, 0)
  )
)
