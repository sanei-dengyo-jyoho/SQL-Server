 SELECT a.���t, 
        a.�����R�[�h, 
        a.����於, 
        a.����於�J�i, 
        a.����旪��, 
        a.����旪�̃J�i, 
        e.���, 
        d.�Ǝ�, 
        c.������ AS ����, 
        b.����, 
        '\' + CONVERT(varchar(2), CASE WHEN isnull(a.�o�^�敪,0) > 0 THEN - 1 ELSE 0 END) AS �敪 
 FROM �����_T�ٓ� as a 
  LEFT OUTER JOIN �R�[�h�o�^�敪_Q as b 
   ON a.�o�^�敪 = b.�o�^�敪 
  LEFT OUTER JOIN ����_Q as c 
   ON a.�����R�[�h = c.�����R�[�h 
  LEFT OUTER JOIN �Ǝ�_Q as d 
   ON a.�Ǝ�R�[�h = d.�Ǝ�R�[�h 
  LEFT OUTER JOIN �������_T as e 
   ON a.��ʃR�[�h = e.��ʃR�[�h 

