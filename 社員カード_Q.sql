with

c0 as
(
select top 1
	年度

from
	カレンダ_T as c01

where
	( 日付 = convert(varchar(10),GETDATE(),111) )
)
,

e0 as
(
select
	e01.年度
,	CASE WHEN ISNULL(s01.場所名,N'') = N'本社' THEN ISNULL(s01.会社コード,'')+CONVERT(nvarchar(5),10000+ISNULL(s01.順序コード,0))+N'@'+N'本社' ELSE ISNULL(s01.会社コード,'')+CONVERT(nvarchar(5),10000+ISNULL(s01.順序コード,0))+CONVERT(nvarchar(5),10000+ISNULL(s01.本部コード,0))+CONVERT(nvarchar(5),10000+ISNULL(s01.部コード,0))+CONVERT(nvarchar(5),10000+ISNULL(s01.課コード,0))+CONVERT(nvarchar(5),10000+ISNULL(s01.所在地コード,0))+N'@'+ISNULL(s01.場所名,N'') END as 事業所レコード順序
,	s01.会社コード
,	s01.順序コード
,	s01.本部コード
,	s01.部コード
,	s01.課コード
,	s01.所在地コード
,	CASE WHEN ISNULL(d01.職制名,N'') LIKE N'%会長%' THEN -95 WHEN ISNULL(d01.職制名,N'') LIKE N'%社長%' THEN -90 WHEN ISNULL(d01.職制名,N'') LIKE N'%専務%' THEN -80 WHEN ISNULL(d01.職制名,N'') LIKE N'%常務%' THEN -70 WHEN ISNULL(e01.職制区分,0) = 1 THEN -50 ELSE s01.部門レベル END AS 部門レベル
,	e01.部門コード
,	s01.上位コード
,	s01.場所名
,	s01.本部名
,	s01.部名
,	substring(convert(varchar(5),10000+e01.社員コード),2,4) as 社員コードキー
,	e01.社員コード
,	e01.氏名
,	e01.カナ氏名
,	e01.職制区分
,	e01.職制コード
,	c01.職制区分名
,	d01.職制名
,	e01.係コード
,	f01.係名
,	e01.生年月日
,	dbo.FuncGetAgeString(isnull(e01.生年月日,''),GETDATE(),'才',DEFAULT) as 年齢年月
,	isnull(e01.性別,1) as 性別
,	e01.入社日
,	dbo.FuncGetAgeString(isnull(e01.入社日,''),isnull(e01.退職日,GETDATE()),DEFAULT,DEFAULT) as 勤続年月
,	e01.メールアドレス

from
	社員_T年度 as e01
inner join
	c0 AS y01
	on y01.年度 = e01.年度
LEFT OUTER JOIN
	職制区分_T as c01
	on c01.職制区分 = e01.職制区分
LEFT OUTER JOIN
	職制_T as d01
	on d01.職制区分 = e01.職制区分
	and d01.職制コード = e01.職制コード
LEFT OUTER JOIN
	係名_T as f01
	on f01.係コード = e01.係コード
LEFT OUTER JOIN
	部門_T年度 as j01
	on j01.年度 = e01.年度
	and j01.会社コード = e01.会社コード
	and j01.部門コード = e01.部門コード
LEFT OUTER JOIN
	部門_Q異動履歴_全階層順 as s01
	on s01.年度 = j01.年度
	and s01.会社コード = j01.会社コード
	and s01.部門コード = j01.集計部門コード

where
	( isnull(e01.退職日,'') = '' )
	and ( e01.会社コード = '10' )
)
,

v0 as
(
select distinct
	a0.年度
,	a0.事業所レコード順序
,	SUBSTRING(a0.事業所レコード順序,1,CHARINDEX(N'@',a0.事業所レコード順序)-1) as 事業所順序
,	a0.会社コード
,	a0.順序コード
,	a0.本部コード
,	a0.部コード
,	a0.課コード
,	a0.所在地コード
,	a0.部門レベル
,	a0.部門コード
,	a0.上位コード
,	b0.部門名階層
,	b0.階層レベル
,	a0.場所名
,	a0.本部名
,	a0.部名
,	b0.部門名
,	a0.社員コードキー
,	a0.社員コード
,	a0.氏名
,	a0.カナ氏名
,	a0.職制区分
,	a0.職制コード
,	a0.職制区分名
,	a0.職制名
,	a0.係名
,	case isnull(a0.生年月日,'') when '' then '' else convert(varchar(10),a0.生年月日,111) end as 生年月日
,	case isnull(a0.生年月日,'') when '' then '' else a0.年齢年月 end as 年齢年月
,	dbo.FuncConvertGenderString(isnull(a0.性別,1)) as 性別
,	case isnull(a0.入社日,'') when '' then '' else convert(varchar(10),a0.入社日,111) end as 入社日
,	case isnull(a0.入社日,'') when '' then '' else a0.勤続年月 end as 勤続年月
,	a0.メールアドレス
,	case 
	when i0.[file_stream] is null then
		case
		when isnull(a0.性別,1) = 1
			then (select top 1 i91.[file_stream]
					from [FileTable_Qassets] as i91
					where i91.[u_filepath_name] = '\assets\Icon\employee_male.png')
		when isnull(a0.性別,1) = 2
			then (select top 1 i92.[file_stream]
					from [FileTable_Qassets] as i92
					where i92.[u_filepath_name] = '\assets\Icon\employee_female.png')
		end
	else i0.[file_stream]
	end as 顔写真

from
	e0 as a0
LEFT OUTER JOIN
	部門_Q名称_階層順 as b0
	on b0.年度 = a0.年度
	and b0.会社コード = a0.会社コード
	and b0.部門コード = a0.部門コード
LEFT OUTER JOIN
	[FileTable_Q安全顔写真] as i0
	on i0.[company_code] = a0.会社コード
	and i0.[employee_code] = a0.社員コード

where
	( isnull(a0.社員コードキー,'') <> '' )
)

select
	*

from
	v0 as v000

