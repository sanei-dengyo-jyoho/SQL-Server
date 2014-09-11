select
	a0.会社コード
,	b0.システム名
,	c0.サイクル区分
,	d0.年度
from
	会社_T as a0
cross join
	プロジェクト名_T as b0
cross join
	運用サイクル名_Q as c0
cross join
	年度_Q as d0
