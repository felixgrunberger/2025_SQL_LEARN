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
    f.job_title,    
    f.job_id,
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
  FROM filtered f
  ORDER BY
    salary_year_avg DESC
   LIMIT 20
)
SELECT 
    COUNT(*) AS skills_counter,
    skills
FROM leveled
INNER JOIN skills_job_dim ON leveled.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY skills
ORDER BY skills_counter DESC
LIMIT 5
 



