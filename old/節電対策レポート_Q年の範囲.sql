WITH 

v0 AS 
( 
 SELECT �N 
 FROM �ߓd�΍􃌃|�[�g_T AS y 
 GROUP BY �N 
), 

v1 AS 
( 
 SELECT c.�N, 
        c.�N��, 
        c.�a��N 
 FROM �J�����__Q AS c 
  INNER JOIN v0 AS v 
   ON c.�N = v.�N 
 GROUP BY c.�N, 
          c.�N��, 
          c.�a��N 
) 

 SELECT DISTINCT 
        �N��+CONVERT(varchar(4),�a��N)+'�N' AS �N�W�v, 
        CONVERT(int,�N) AS �N 
 FROM v1 AS b 

