# Simple timeline with 4 items
dataBasic <- data.frame(
  id = 1:4,
  content = c("Item one", "Item two" ,"Ranged item", "Item four"),
  start   = c("2016-01-10", "2016-01-11", "2016-01-20", "2016-02-14"),
  end    = c(NA, NA, "2016-02-04", NA)
)

countryToCode <- list(
  "Argentina" = "ar",
  "Belgium" = "be",
  "Brazil" = "br",
  "Colombia" = "co",
  "Costa Rica" = "cr",
  "France" = "fr",
  "Germany" = "de",
  "Netherlands" = "nl"
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
        <td><img src="https://flagpedia.net/data/flags/mini/%s.png" width="31" height="20" alt="%s"></td>
        <th></th>
        <td><img src="https://flagpedia.net/data/flags/mini/%s.png" width="31" height="20" alt="%s"></td>
      </tr>
    </tbody></table>',
    stage, team1, score1, score2, team2, countryToCode[[team1]], team1, countryToCode[[team2]], team2
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

# Data for groups example (this data also gets exported in the package)
timevisData <- data.frame(
  id = 1:14,
  content = c(
    "Open", "Open", "Half price entry",
    "Open", "Adults only", "Open", "Staff meeting",
    "Open", "Men only", "Women only", "Open",
    "Hot water", "Very hot water",
    "Siesta"),
  start = c(
    "2016-05-01 06:00:00", "2016-05-01 14:00:00", "2016-05-01 08:00:00",
    "2016-05-01 08:00:00", "2016-05-01 14:00:00",
    "2016-05-01 16:00:00", "2016-05-01 19:30:00",
    "2016-05-01 08:00:00", "2016-05-01 14:00:00", "2016-05-01 16:00:00", "2016-05-01 18:00:00",
    "2016-05-01 09:00:00", "2016-05-01 14:00:00",
    "2016-05-01 12:00:00"),
  end   = c(
    "2016-05-01 12:00:00", "2016-05-01 22:00:00", "2016-05-01 10:00:00",
    "2016-05-01 12:00:00", "2016-05-01 16:00:00",
    "2016-05-01 20:00:00", NA,
    "2016-05-01 12:00:00", "2016-05-01 16:00:00", "2016-05-01 18:00:00", "2016-05-01 20:00:00",
    "2016-05-01 12:00:00", "2016-05-01 17:00:00",
    "2016-05-01 14:00:00"),
  group = c(rep("gym", 3), rep("pool", 4), rep("sauna", 4), rep("tub", 2), NA),
  type = c(rep("range", 6), "point", rep("range", 6), "background")
)
timevisDataGroups <- data.frame(
  id = c("gym", "pool", "sauna", "tub"),
  content = c("Gym", "Pool", "Sauna", "Hot Tub")
)
