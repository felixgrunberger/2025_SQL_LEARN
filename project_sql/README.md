# Compensation by Level


# Introduction

Explore the global and German data job market! This project dives into
data analyst roles, highlighting 💰 top-paying jobs, 🔥 in-demand
skills, 📈 skills linked to higher salaries, and 📚 the best skills to
learn. We also cover 🎓 degree requirements, 👩‍💻 junior positions and
internships, 🧑‍💻🏢 common employment types, and 🌍 remote work
opportunities. Finally, we examine 📅 when data analyst job postings
peak, offering a comprehensive overview of the field.

🔍 SQL queries? Check them out here: sql_queries Folder

📊 Data visualization in Python? Find here: code_for_visualizations

Background

Driven by a quest to navigate the data analyst job market more
effectively, this project was born from a desire to pinpoint top-paid
and in-demand skills, streamlining others work to find optimal jobs.

Data hails from my SQL Course. It’s packed with insights on job titles,
salaries, locations, and essential skills.

The questions I wanted to answer through my SQL queries were:

What are the top-paying data analyst jobs? What skills are required for
these top-paying jobs? What skills are most in demand for data analysts?
Which skills are associated with higher salaries? What are the most
optimal skills to learn?

# Tools I Used

For my deep dive into the data analyst job market, I harnessed the power
of several key tools:

SQL: The backbone of my analysis, allowing me to query the database and
unearth critical insights. PostgreSQL: The chosen database management
system, ideal for handling the job posting data. Visual Studio Code: My
go-to for database management and executing SQL queries. Git & GitHub:
Essential for version control and sharing my SQL scripts and analysis,
ensuring collaboration and project tracking.

# The Analysis

Each query for this project aimed at investigating specific aspects of
the data analyst job market. Here’s how I approached each question:

## 1. Top Paying Data Analyst Jobs

To identify the highest-paying roles, I filtered data analyst positions
by average yearly salary and location, focusing on remote jobs. This
query highlights the high paying opportunities in the field.

``` {sql}
WITH filtered AS (
  SELECT
    j.job_id,
    j.job_title,
    j.job_title_short,
    j.salary_year_avg
  FROM job_postings_fact j
  WHERE j.salary_year_avg IS NOT NULL
    AND j.job_title_short ILIKE '%Scientist%'
    AND j.salary_year_avg BETWEEN 20000 AND 1000000
),
leveled AS (
  SELECT
    job_title,
    CASE
      WHEN job_title ILIKE '%Director%' THEN 'Director'
      WHEN job_title ILIKE '%Head%'     THEN 'Head'
      WHEN job_title ILIKE '%Lead%' OR job_title ILIKE '%Principal%' THEN 'Principal'
      WHEN job_title ILIKE '%Senior%'   THEN 'Senior'
      WHEN job_title ILIKE '%Manager%'  THEN 'Manager'
      WHEN job_title ILIKE '%Associate%' OR job_title ILIKE '%Mid%'  THEN 'Associate'
      WHEN job_title ILIKE '%Junior%' OR job_title ILIKE '%Entry%'   THEN 'Junior'
      ELSE 'Other'
    END AS level,
    salary_year_avg
  FROM filtered
),
by_title AS (
  SELECT
    job_title,
    level,
    COUNT(*) AS n_postings,
    ROUND(AVG(salary_year_avg),0) AS mean_salary,
    percentile_cont(0.50) WITHIN GROUP (ORDER BY salary_year_avg) AS median_salary
  FROM leveled
  GROUP BY job_title, level
  HAVING COUNT(*) >= 10                    
)
SELECT *
FROM by_title
ORDER BY median_salary DESC;
```
