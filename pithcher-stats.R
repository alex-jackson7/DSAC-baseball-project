# load packages ----------------------------------------------------------------

library(tidyverse)
library(rvest)
library(lubridate)
library(robotstxt)

# check that we can scrape data from the chronicle -----------------------------

paths_allowed("https://www.fangraphs.com/teams/astros/stats")

# read page --------------------------------------------------------------------

page <- read_html("https://www.fangraphs.com/teams/astros/stats")

# parse components -------------------------------------------------------------

pitcher <- page |>
  html_elements(".frozen") |>
  html_text()

authors_dates <- page |>
  html_elements(".dateline.has-photo") |>
  html_text2() |>
  str_remove("By")

abstracts <- page |>
  html_elements(".has-photo.d-md-block") |>
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
  title = pitcher),
  author_date = authors_dates,
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