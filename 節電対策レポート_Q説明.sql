with 

v0 AS 
( 
 select top 1 
        min(�N) as �ŏ��N, 
        max(�N) as �ő�N 
 from �ߓd�΍􃌃|�[�g_T as y 
), 

v001 AS 
( 
 SELECT max(�N) as �N, 
        �N��, 
        �a��N 
 FROM �J�����__Q AS c001 
 GROUP BY �N��, 
          �a��N 
), 

v1 AS 
( 
 SELECT c.�N, 
        c.�N��, 
        c.�a��N 
 FROM v001 AS c 
  INNER JOIN v0 AS v 
   ON c.�N >= v.�ŏ��N 
   AND c.�N <= v.�ő�N 
 GROUP BY c.�N, 
          c.�N��, 
          c.�a��N 
), 

vp1 as 
( 
 select * 
 from ��ЏZ��_Q as p0 
 where ��ЃR�[�h='10' 
), 

vt1 as 
( 
 select * 
 from �ߓd�΍􃌃|�[�g_T as t0 
) 

 select distinct 
        convert(int,b.�N) as �N, 
        a.�N��+convert(varchar(4),a.�a��N)+'�N' as �N�W�v, 
        b.���ݒn�R�[�h, 
        isnull(p.�ꏊ��,'') as �ꏊ��, 
        isnull(b.�w�b�_�[,'') as �w�b�_�[, 
        isnull(b.�t�b�^�[,'') as �t�b�^�[ 
 from vt1 as b 
  left outer join v1 as a 
   on a.�N=b.�N 
  left outer join vp1 as p 
   on p.���ݒn�R�[�h=b.���ݒn�R�[�h 

