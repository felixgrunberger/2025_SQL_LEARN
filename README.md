# Compensation by Level


- [SQL projects for bio & health
  data](#sql-projects-for-bio--health-data)
  - [Motivation](#motivation)
  - [What’s here](#whats-here)
  - [Projects](#projects)
    - [1. **Project 01 — Learn
      SQL`project_sql/`**](#1-project-01--learn-sqlproject_sql)

# SQL projects for bio & health data

This repo is a small collection of projects where I collect **relational
databases and SQL**, with examples that could be useful in **omics** and
other field.

## Motivation

- Get comfortable with schemas, joins, and window functions.
- Try patterns that show up in research and industry (e.g., cohort-style
  filters, tidy aggregates).
- Keep everything simple and reproducible.

## What’s here

- Short, self-contained projects with queries and a brief write-up.
- Examples that try to be clear rather than clever.

## Projects

### 1. **Project 01 — Learn SQL[`project_sql/`](project_sql/)**

#### What this project is

A practical SQL exploration of the data-analyst job market. It answers
questions like: top-paying roles, skills needed for those roles, most
in-demand skills overall, skills linked to higher salaries, and a simple
“optimal skills” view where demand meets pay. The work is inspired by
Luke Barousse’s SQL job-market project and course materials.

#### Tools I used

- **SQL** — querying, cleaning, joining, aggregating.
- **PostgreSQL** — DB engine for the job-posting & skills tables.
- **Visual Studio Code** — editing and running SQL scripts.
- **Git & GitHub** — version control and sharing the analysis.
- **R** - tidyverse for plotting.

#### What I learned from the code

- **CTE pipelines** to keep logic readable (“filter → enrich → aggregate
  → rank”).
- **Joins across fact & dimension tables**, incl. many-to-many joins to
  map postings ↔ skills.
- **Robust summary stats**: medians & quartiles and why they beat simple
  averages.
- **Reproducible, plot-ready outputs** (tidy aggregates you can chart
  directly).
