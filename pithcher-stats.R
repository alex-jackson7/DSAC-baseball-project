# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

# check that we can scrape data from the chronicle -----------------------------

paths_allowed("https://www.fangraphs.com/teams/astros")

# read page --------------------------------------------------------------------

page <- read_html("https://www.fangraphs.com/teams/astros")

# parse components -------------------------------------------------------------

pitcher_name <- page |>
    html_elements(".team-stats-table:nth-child(8) tbody .frozen") |>
    html_text()

age <- page |>
  html_elements(".team-stats-table:nth-child(8) tbody .frozen+ td") |>
  html_text() 

innings_pitched <- page |>
  html_elements(".team-stats-table:nth-child(8) tbody td:nth-child(5)") |>
  html_text2()

article_types <- page |>
  html_elements(".kicker a:nth-child(1)") |>
  html_text2()

columns <- page |>
  html_elements(".kicker a+ a") |>
  html_text2()

urls <- page |>
  html_elements(".headline a") |>
  html_attr(name = "href")

# create a data frame ----------------------------------------------------------

astros_pitchers <- tibble(
  name = pitcher,
  age = age),
  abstract = abstracts,
  article_type = article_types,
  column = columns,
  url = urls
)

# clean up data ----------------------------------------------------------------

chronicle <- chronicle_raw |>
  # separate author_date into author and date
  separate(author_date, into = c("author", "date"), sep = "\\| ", fill = "left") |>
  # fix date and make it date type
  mutate(
    date = case_when(
      date == "15 hours ago" ~ "October 12, 2022",
      date == "5 days ago" ~ "October 7, 2022",
      date == "6 days ago" ~ "October 6, 2022",
      TRUE ~ date
    ),
    date = mdy(date)
  )
# make article type and column title case


# write data -------------------------------------------------------------------

write_csv(chronicle, file = "data/chronicle.csv")