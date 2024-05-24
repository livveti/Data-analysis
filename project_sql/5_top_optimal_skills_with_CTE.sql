WITH demand_skills AS(
SELECT
  skills_dim.skill_id,
  skills_dim.skills,
  COUNT(skills_job_dim.job_id) AS job_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst' AND
  job_work_from_home = TRUE AND
  salary_year_avg IS NOT NULL
GROUP BY
  skills_dim.skill_id
),

job_count_salary AS (
SELECT
  skills_dim.skill_id,
  skills_dim.skills,
  ROUND (AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
  job_title_short = 'Data Analyst' AND
  salary_year_avg IS NOT NULL AND
  job_work_from_home = TRUE
GROUP BY
  skills_dim.skill_id
)

SELECT
  demand_skills.skill_id,
  demand_skills.skills,
  job_count,
  avg_salary
FROM demand_skills
INNER JOIN job_count_salary ON demand_skills.skills = job_count_salary.skills
WHERE
  job_count > 10
ORDER BY
  avg_salary DESC,
  job_count DESC
LIMIT 25