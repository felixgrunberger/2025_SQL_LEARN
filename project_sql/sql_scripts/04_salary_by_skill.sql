WITH base AS (
  SELECT
    s.skills,
    j.job_id,
    j.salary_year_avg
  FROM skills_dim s
  JOIN skills_job_dim sj ON s.skill_id = sj.skill_id
  JOIN job_postings_fact j ON sj.job_id = j.job_id
  WHERE j.salary_year_avg BETWEEN 20000 AND 1000000
    AND j.job_title_short ILIKE '%Scientist%'
)
SELECT
  skills,
  COUNT(DISTINCT job_id) AS per_group,
  ROUND(AVG(salary_year_avg), 0) AS mean_salary_per_skill
FROM base
GROUP BY skills
HAVING COUNT(DISTINCT job_id) > 10
ORDER BY mean_salary_per_skill DESC;