with 

vp1 as 
( 
 select * 
 from ��Џꏊ_Q as p0 
 where ��ЃR�[�h='10' 
), 

vt1 as 
( 
 select ���ݒn�R�[�h 
 from �ߓd�΍􃌃|�[�g_T as t0 
 group by ���ݒn�R�[�h 
) 

 select distinct 
        p.���R�[�h, 
        p.���ݒn�R�[�h, 
        p.���僌�x��, 
        isnull(p.�ꏊ��,'') as �ꏊ�� 
 from vt1 as b 
  left outer join vp1 as p 
   on p.���ݒn�R�[�h=b.���ݒn�R�[�h 
 order by p.���R�[�h, 
          p.���ݒn�R�[�h, 
          p.���僌�x�� 

