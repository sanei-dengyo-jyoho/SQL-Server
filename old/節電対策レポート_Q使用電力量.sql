with 

v0 AS 
( 
 select top 1 
        min(�N) as �ŏ��N, 
        max(�N) as �ő�N 
 from �ߓd�΍􃌃|�[�g_T�g�p�d�͗� as y 
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

vt0 as 
( 
 select * 
 from �ߓd�΍􃌃|�[�g_T�g�p�d�͗� as t0 
), 

vt1 as 
( 
 select �N, 
        ���ݒn�R�[�h, 
        1 as ��, 
        [1��] as �l, 
        ���l 
 from vt0 as vt001 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        2 as ��, 
        [2��] as �l, 
        ���l 
 from vt0 as vt002 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        3 as ��, 
        [3��] as �l, 
        ���l 
 from vt0 as vt003 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        4 as ��, 
        [4��] as �l, 
        ���l 
 from vt0 as vt004 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        5 as ��, 
        [5��] as �l, 
        ���l 
 from vt0 as vt005 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        6 as ��, 
        [6��] as �l, 
        ���l 
 from vt0 as vt006 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        7 as ��, 
        [7��] as �l, 
        ���l 
 from vt0 as vt007 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        8 as ��, 
        [8��] as �l, 
        ���l 
 from vt0 as vt008 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        9 as ��, 
        [9��] as �l, 
        ���l 
 from vt0 as vt009 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        10 as ��, 
        [10��] as �l, 
        ���l 
 from vt0 as vt010 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        11 as ��, 
        [11��] as �l, 
        ���l 
 from vt0 as vt011 
 union all 
 select �N, 
        ���ݒn�R�[�h, 
        12 as ��, 
        [12��] as �l, 
        ���l 
 from vt0 as vt012 
) 

 select distinct 
        convert(int,b.�N) as �N, 
        a.�N��+convert(varchar(4),a.�a��N)+'�N' as �N�W�v, 
        b.���ݒn�R�[�h, 
        isnull(p.�ꏊ��,'') as �ꏊ��, 
        convert(int,b.��) as ��, 
        convert(varchar(4),b.��)+'��' as ���W�v, 
        convert(money,b.�l) as �l, 
        isnull(b.���l,'') as ���l 
 from vt1 as b 
  left outer join v1 as a 
   on a.�N=b.�N 
  left outer join vp1 as p 
   on p.���ݒn�R�[�h=b.���ݒn�R�[�h 

