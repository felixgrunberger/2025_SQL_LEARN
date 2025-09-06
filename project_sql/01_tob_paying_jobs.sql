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


