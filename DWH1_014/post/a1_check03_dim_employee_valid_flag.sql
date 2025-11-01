-- Make A1 dwh_014 schema the default for this session
SET
  search_path TO dwh_014,
  stg_014;

-- =======================================
-- Check [dim_employee.valid_flag = count(valid_to) AND 1 <= rolelevel <= 4] 
-- =======================================
SELECT
  SUM(
    CASE
      WHEN d_em.validto IS NULL THEN 1
      ELSE 0
    END
  ) AS valid_to_cnt,
  SUM(
    CASE
      WHEN d_em.current_flag = TRUE THEN 1
      ELSE 0
    END
  ) AS current_flag_active_count,
  MIN(d_em.rolelevel) AS min_rolelevel,
  MAX(d_em.rolelevel) AS max_rolelevel,
  CASE
    WHEN SUM(
      CASE
        WHEN d_em.current_flag = TRUE THEN 1
        ELSE 0
      END
    ) = SUM(
      CASE
        WHEN d_em.validto IS NULL THEN 1
        ELSE 0
      END
    )
    AND (
      MIN(d_em.rolelevel) <= 1
      AND MAX(d_em.rolelevel) >= 4
    ) THEN 'success'
    ELSE 'fail'
  END AS validation_result
FROM
  dwh_014.dim_employee d_em;