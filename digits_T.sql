WITH

cte
(
	digit
)
AS
(
SELECT
	0 AS digit

UNION ALL

SELECT
	a0.digit + 1 AS digit

FROM
	cte AS a0

WHERE
	a0.digit < 9
)

SELECT
	*

FROM
	cte AS a1

