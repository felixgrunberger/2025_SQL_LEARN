WITH base AS (
  SELECT j.job_id, s.skills
  FROM job_postings_fact j
  JOIN skills_job_dim sj ON j.job_id = sj.job_id
  JOIN skills_dim      s ON sj.skill_id = s.skill_id
  WHERE j.job_title_short ILIKE '%Data Scientist%'
),
tot AS (
  SELECT COUNT(DISTINCT job_id) AS n_jobs FROM base
)
SELECT
  b.skills,
  COUNT(DISTINCT b.job_id) AS demand_count,
  ROUND( COUNT(DISTINCT b.job_id)::numeric / t.n_jobs * 100, 1 ) AS demand_pct
FROM base b
CROSS JOIN tot t
GROUP BY b.skills, t.n_jobs
ORDER BY demand_count DESC
LIMIT 5;
