with

v0 as
( 
select
	���͉�ЃR�[�h
,	�Ј��R�[�h
,	count(���s��) as �^�]����
,	count(��~��) as �^�]��~��
from
	���͉�Љ^�]����_Q as a0
group by
	���͉�ЃR�[�h,
,	�Ј��R�[�h 
)
,

v1 as
(
select
	a1.���t
,	a1.���͉�ЃR�[�h
,	d1.���͉�Ж�
,	a1.�Ј��R�[�h
,	a1.����
,	a1.��
,	a1.��
,	a1.�J�i����
,	a1.�J�i��
,	a1.�J�i��
,	a1.�ǂݏ�
,	a1.���N����
,	dbo.FuncGetAgeString(isnull(a1.���N����,''),getdate(),'��',default) as �N��N��
,	dbo.FuncGetAgeString(isnull(a1.���N����,''),getdate(),'','N') as �N��N
,	isnull(a1.����,1) as ����
,	isnull(a1.�ŏI�w��,6) as �ŏI�w��
,	a1.���Г�
,	c1.�N�x as ���ДN�x
,	convert(varchar(3),isnull(a1.�o���N,0)) + '�N' + convert(varchar(3),isnull(a1.�o����,0)) + '����' as �o���N��
,	isnull(a1.�o���N,0) as �o���N
,	isnull(a1.�o����,0) as �o����
,	a1.���ߓ�
,	a1.�ސE��
,	a1.�ސE�N�x
,	dbo.FuncGetAgeString(isnull(a1.���Г�,''),isnull(a1.�ސE��,getdate()),default,default) as �Α��N��
,	dbo.FuncGetAgeString(isnull(a1.���Г�,''),isnull(a1.�ސE��,getdate()),'','N') as �Α��N
,	a1.���[���A�h���X
,	a1.�X�֔ԍ�
,	a1.�Z��
,	a1.������
,	a1.TEL
,	a1.FAX
,	a1.�ً}�A����
,	a1.������
,	a1.�o�^�敪
,	a1.�X�V����
,	b1.�^�]����
,	b1.�^�]��~��
from
	���͉�ЎЈ�_T�ٓ� as a1
left join
	v0 as b1
	on b1.���͉�ЃR�[�h = a1.���͉�ЃR�[�h
	and b1.�Ј��R�[�h = a1.�Ј��R�[�h
left join
	�J�����__T as c1
	on c1.���t = a1.���Г�
left join
	���͉��_T as d1
	on d1.���͉�ЃR�[�h = a1.���͉�ЃR�[�h
)

select
	*
from
	v1 as a2

