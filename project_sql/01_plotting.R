library(dplyr)
library(stringr)

# 1) filtered  (CTE 1)
set_d <- vroom(here("project_sql/csv/01_table.csv"))

filtered <- set_d %>%
  filter(
    !is.na(salary_year_avg),
    str_detect(job_title_short, regex("Scientist", ignore_case = TRUE)),
    between(salary_year_avg, 20000, 1e6) # optional guardrails
    # # and/or: job_posted_date >= Sys.Date() - lubridate::months(18)
  )

# 2) leveled  (CTE 2)  -- CASE -> case_when
leveled <- filtered %>%
  mutate(
    level = case_when(
      str_detect(job_title, regex("Director",  ignore_case = TRUE)) ~ "Director",
      str_detect(job_title, regex("Head",      ignore_case = TRUE)) ~ "Head",
      str_detect(job_title, regex("Lead|Principal", ignore_case = TRUE)) ~ "Principal",
      str_detect(job_title, regex("Senior",    ignore_case = TRUE)) ~ "Senior",
      str_detect(job_title, regex("Manager",   ignore_case = TRUE)) ~ "Manager",
      str_detect(job_title, regex("Associate|Mid", ignore_case = TRUE)) ~ "Associate",
      str_detect(job_title, regex("Junior|Entry",  ignore_case = TRUE)) ~ "Junior",
      TRUE ~ "Other"
    )
  )

# 3) by_title  (CTE 3)  -- GROUP BY + percentiles
# R's quantile(..., type = 7) is a continuous estimator (matches SQL percentile_cont style)
by_title <- leveled %>%
  group_by(job_title, level) %>%
  summarise(
    n_postings   = n(),
    mean_salary  = mean(salary_year_avg),
    p25_salary   = as.numeric(quantile(salary_year_avg, probs = 0.25, type = 7, names = FALSE)),
    median_salary= as.numeric(quantile(salary_year_avg, probs = 0.50, type = 7, names = FALSE)),
    p75_salary   = as.numeric(quantile(salary_year_avg, probs = 0.75, type = 7, names = FALSE)),
    .groups = "drop"
  ) %>%
  filter(n_postings >= 10)  # HAVING COUNT(*) >= 10

# 4) ranked  (CTE 4)  -- window ranks
ranked <- by_title %>%
  mutate(rank_overall = dense_rank(desc(median_salary))) %>%
  group_by(level) %>%
  mutate(rank_within_level = dense_rank(desc(median_salary))) %>%
  ungroup()

# FINAL (choose one)
ranked %>%
  arrange(desc(median_salary))                # like: SELECT * FROM ranked ORDER BY median DESC
# OR: ranked %>% filter(rank_within_level <= 10) %>% arrange(level, desc(median_salary))




01_plotting.R

library(here)
library(vroom)
library(tidyverse)
library(ggridges)

set_d <- vroom(here("project_sql/csv/01_table.csv"))
glimpse(set_d)
ggplot(data = set_d %>%
group_by(job_title_group) %>%
mutate(median_s = median(salary_year_avg)),
aes(y = fct_reorder(job_title_group, median_s),
x = salary_year_avg)) +
geom_density_ridges() +
theme_minimal()
