with 

v00 AS 
( 
 select top 2 * 
 from �ߓd�΍􃌃|�[�g_Q�N�͈̔� as v000 
 order by �N desc 
), 

v0 as 
( 
 select min(�N) as �N��, 
        max(�N) as �N�� 
 from v00 as y0 
), 

v1 as 
( 
 select �N, 
        max(���t) as ���t 
 from �J�����__T as c0 
 group by �N 
), 

v2 as 
( 
 select a.�N��, 
        m1.�N�W�v as �a��N�\����, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c1.���t,111),'','�N',DEFAULT,DEFAULT) as �a����t��, 
        a.�N��, 
        m2.�N�W�v as �a��N�\����, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c2.���t,111),'','�N',DEFAULT,DEFAULT) as �a����t�� 
 from v0 as a 
  left outer join �ߓd�΍􃌃|�[�g_Q�N�͈̔� as m1 
   on m1.�N=a.�N�� 
  left outer join �ߓd�΍􃌃|�[�g_Q�N�͈̔� as m2 
   on m2.�N=a.�N�� 
  left outer join v1 as c1 
   on c1.�N=a.�N�� 
  left outer join v1 as c2 
   on c2.�N=a.�N�� 
) 

 select * 
 from v2 as v20 


