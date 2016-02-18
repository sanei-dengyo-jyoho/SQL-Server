with

p0 as
(
select
	発行年度
,	会社コード
,	社員コード
,	max(発行日) as 発行日
,	max(停止年度) as 停止年度
,	max(停止日) as 停止日
from
	運転許可証_T履歴 as p000
group by
	発行年度
,	会社コード
,	社員コード
)
,

l0 as
(
select
	l000.年度
,	l000.会社コード
,	l000.社員コード
,	max(l001.発行年度) as 発行年度
,	max(l001.発行日) as 発行日
,	max(l001.停止年度) as 停止年度
,	max(l001.停止日) as 停止日
from
	社員_T年度 as l000
LEFT OUTER JOIN
	p0 as l001
	on l001.発行年度 <= l000.年度
	and l001.会社コード = l000.会社コード
	and l001.社員コード = l000.社員コード
group by
	l000.年度
,	l000.会社コード
,	l000.社員コード
)
,

x01 as
(
select
	年度
from
	社員_T年度 as x010
group by
	年度
)
,

x02 as
(
select
	年度
from
	技術職員名簿_T明細 as x020
group by
	年度
)
,

x0 as
(
select
	x001.年度
,	max(x002.年度) as 技術年度
from
	x01 as x001
inner join
	x02 as x002
	on x002.年度 <= x001.年度
group by
	x001.年度
)
,

z0 as
(
select
	会社コード
,	年度
,	社員コード
,	count([№]) as [№]
from
	技術職員名簿_T資格 as z000
group by
	会社コード
,	年度
,	社員コード
)
,

v1 as
(
select
	a1.年度
,	a1.会社コード
,	a1.社員コード
,	a1.氏名
,	a1.氏
,	a1.名
,	a1.カナ氏名
,	a1.カナ氏
,	a1.カナ名
,	a1.読み順
,	f1.県コード
,	b1.所在地コード
,	b1.集計部門コード
,	b1.部門レベル
,	b1.上位コード
,	a1.部門コード
,	b1.部門名
,	b1.部門名略称
,	b1.部門名省略
,	a1.出向部門コード
,	b2.部門名 as 出向部門名
,	b2.部門名略称 as 出向部門名略称
,	b2.部門名省略 as 出向部門名省略
,	a1.職制区分
,	a1.職制コード
,	e1.職制名
,	e1.職制名略称
,	a1.係コード
,	d1.係名
,	d1.係名省略
,	a1.兼務係コード
,	d2.係名 as 兼務係名
,	d2.係名省略 as 兼務係名省略
,	a1.生年月日
,
	case
		isnull(a1.生年月日,'')
		when ''
		then N''
		else dbo.FuncGetAgeString(a1.生年月日,GETDATE(),N'才',DEFAULT)
	end
	as 年齢年月
,
	case
		isnull(a1.生年月日,'')
		when ''
		then N''
		else dbo.FuncGetAgeString(a1.生年月日,GETDATE(),N'',N'N')
	end
	as 年齢年
,	isnull(a1.性別,1) as 性別
,	isnull(a1.最終学歴,6) as 最終学歴
,	a1.出身校
,	a1.専攻
,	a1.入社日
,	c1.年度 as 入社年度
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,
	case
		isnull(a1.入社日,'')
		when ''
		then N''
		else dbo.FuncGetAgeString(a1.入社日,isnull(a1.退職日,GETDATE()),DEFAULT,DEFAULT)
	end
	as 勤続年月
,
	case
		isnull(a1.入社日,'')
		when ''
		then N''
		else dbo.FuncGetAgeString(a1.入社日,isnull(a1.退職日,GETDATE()),N'',N'N')
	end
	as 勤続年
,	a1.内線番号
,	a1.メールアドレス
,	a1.郵便番号
,	a1.住所
,	a1.建物名
,	a1.TEL
,	a1.FAX
,	a1.緊急連絡先
,	a1.登録区分
,	a1.更新日時
,	t11.頁
,	t11.行
,	t11.枝番
,	t11.[№]
,	t11.年齢
,	isnull(t11.経験年数,s1.経験年数) as 経験年数
,	s1.過去経験
,	s1.過去経験年
,	s1.過去経験月
,
	case
		isnull(s1.過去経験,0)
		when 0
		then N''
		else N' ' + N'過去' +
			case
				isnull(s1.過去経験年,0)
				when 0
				then N''
				else convert(nvarchar(3),isnull(s1.過去経験年,0)) + N'年'
			end
			+
			case
				isnull(s1.過去経験月,0)
				when 0
				then N''
				else convert(nvarchar(3),isnull(s1.過去経験月,0)) + N'ヶ月'
			end
	end
	as 過去経験年月
,
	case
		isnull(t11.交付番号,'')
		when ''
		then 0
		else 1
	end
	as 監理
,	t11.交付番号
,	t11.交付日付
,	t11.有効期限
,
	case
		(isnull(t11.講習受講1,0) + isnull(t11.講習受講2,0))
		when 0
		then 0
		else 1
	end
	as 講習受講
,
	case
		isnull(t2.[№],0)
		when 0
		then 0
		else 1
	end
	as 資格
,	t11.資格区分
,	t11.点数
,	t11.表示資格名1
,	t11.交付番号1
,	t11.取得日付1
,	t11.表示資格名2
,	t11.交付番号2
,	t11.取得日付2
,
	case
		isnull(t12.[№],0)
		when 0
		then 0
		else 1
	end
	as 専任
,
	case
		isnull(t14.[№],0)
		when 0
		then 0
		else 1
	end
	as 主任
,
	case
		isnull(t13.[№],0)
		when 0
		then 0
		else 1
	end
	as 使用人
,
	case
		when isnull(t15.建設業経理事務士,9) > 2
		then 0
		else 1
	end
	as 経理
,
	case
		when isnull(t15.建設業経理事務士,9) > 2
		then 0
		else t15.建設業経理事務士
	end
	as 経理事務士
,
	case
		when isnull(t15.建設業経理事務士,9) > 2
		then N''
		else CONVERT(nvarchar(4),dbo.SqlStrConv(t15.建設業経理事務士,4)) + N'級'
	end
	as 経理士
,
	isnull(t2.[№],0) +
	case
		isnull(s1.監理技術者,0)
		when 0
		then 0
		else 1
	end
	+
	case
		isnull(t15.建設業経理事務士,0)
		when 0
		then 0
		else 1
	end
	as [資格証№]
,	l1.発行日 as 運転許可日
,	l1.発行年度 as 運転許可年度
,	l1.停止日 as 運転停止日
,	l1.停止年度 as 運転停止年度
,
	case
		isnull(l1.発行日,'')
		when ''
		then 0
		else 1
	end
	as 運転許可数
,
	case
		isnull(l1.停止日,'')
		when ''
		then 0
		else 1
	end
	as 運転停止数
,
	case
		when isnull(i9.[u_fullpath_name],'') = ''
		then
			case
				when isnull(a1.性別,1) = 1
				then
					(
					select top 1
						i91.[u_fullpath_name]
					from
						[FileTable_Qassets] as i91
					where
						( i91.[u_filepath_name] = '\assets\Icon\employee_male.png' )
					)
				when isnull(a1.性別,1) = 2
				then
					(
					select top 1
						i92.[u_fullpath_name]
					from
						[FileTable_Qassets] as i92
					where
						( i92.[u_filepath_name] = '\assets\Icon\employee_female.png' )
					)
			end
	else i9.[u_fullpath_name]
	end
	as 顔写真パス名
from
	社員_T年度 as a1
LEFT OUTER JOIN
	部門_T年度 as b1
	on b1.年度 = a1.年度
	and b1.部門コード = a1.部門コード
LEFT OUTER JOIN
	部門_T年度 as b2
	on b2.年度 = a1.年度
	and b2.部門コード = a1.出向部門コード
LEFT OUTER JOIN
	カレンダ_T as c1
	on c1.日付 = a1.入社日
LEFT OUTER JOIN
	係名_T as d1
	on d1.係コード = a1.係コード
LEFT OUTER JOIN
	係名_T as d2
	on d2.係コード = a1.兼務係コード
LEFT OUTER JOIN
	職制_T as e1
	on e1.職制区分 = a1.職制区分
	and e1.職制コード = a1.職制コード
LEFT OUTER JOIN
	会社住所_T年度 as f1
	on f1.年度 = b1.年度
	and f1.所在地コード = b1.所在地コード
LEFT OUTER JOIN
	l0 as l1
	on l1.年度 = a1.年度
	and l1.会社コード = a1.会社コード
	and l1.社員コード = a1.社員コード
LEFT OUTER JOIN
	工事技術者_T as s1
	on s1.会社コード = a1.会社コード
	and s1.社員コード = a1.社員コード
LEFT OUTER JOIN
	x0 as t1
	on t1.年度 = a1.年度
LEFT OUTER JOIN
	技術職員名簿_T明細 as t11
	on t11.会社コード = a1.会社コード
	and t11.年度 = t1.技術年度
	and t11.社員コード = a1.社員コード
LEFT OUTER JOIN
	技術職員名簿_T専任技術者 as t12
	on t12.会社コード = a1.会社コード
	and t12.年度 = t1.技術年度
	and t12.社員コード = a1.社員コード
LEFT OUTER JOIN
	技術職員名簿_T使用人 as t13
	on t13.会社コード = a1.会社コード
	and t13.年度 = t1.技術年度
	and t13.社員コード = a1.社員コード
LEFT OUTER JOIN
	技術職員名簿_T主任電気工事士 as t14
	on t14.会社コード = a1.会社コード
	and t14.年度 = t1.技術年度
	and t14.社員コード = a1.社員コード
LEFT OUTER JOIN
	技術職員名簿_T経理事務士 as t15
	on t15.会社コード = a1.会社コード
	and t15.年度 = t1.技術年度
	and t15.社員コード = a1.社員コード
LEFT OUTER JOIN
	z0 as t2
	on t2.会社コード = a1.会社コード
	and t2.年度 = t1.技術年度
	and t2.社員コード = a1.社員コード
LEFT OUTER JOIN
	[FileTable_Q顔写真] as i9
	on i9.[company_code] = a1.会社コード
	and i9.[employee_code] = a1.社員コード
)

select
	*
from
	v1 as v100
