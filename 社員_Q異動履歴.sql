 SELECT a.��ЃR�[�h, 
        a.�Ј��R�[�h, 
        a.���t, 
        a.����, 
        a.�J�i����, 
        c.�{����, 
        c.����, 
        c.���喼, 
        c.���喼����, 
        c.���喼�ȗ�, 
        d.�E����, 
        d.�E��������, 
        e.�W��, 
        e.�W������, 
        b.�l������ AS ����, 
        '\' + CONVERT(varchar(2), CASE WHEN isnull(a.�o�^�敪,0) > 0 THEN - 1 ELSE 0 END) AS �敪 
 FROM �Ј�_T�ٓ� as a 
  LEFT OUTER JOIN �R�[�h�o�^�敪_Q as b 
   ON b.�o�^�敪 = a.�o�^�敪 
  LEFT OUTER JOIN ����_Q�ٓ�����_�S�K�w�� as c 
   ON c.�N�x = a.�N�x 
   AND c.����R�[�h = a.����R�[�h 
  LEFT OUTER JOIN �E��_T as d 
   ON d.�E���R�[�h = a.�E���R�[�h 
  LEFT OUTER JOIN �W��_T as e 
   ON e.�W�R�[�h = a.�W�R�[�h

