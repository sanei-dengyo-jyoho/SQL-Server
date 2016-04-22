with

v1 as
(
select distinct
	ISNULL(a1.協力会社コード,0) * 10000 +
	ISNULL(a1.社員コード,0)
	AS キー
,
	convert(nvarchar(100),
		CONVERT(nvarchar(8),
			1000000 +
			ISNULL(a1.協力会社コード,0)
		) +
		N':' +
		ISNULL(d1.協力会社名,N'')
	)
	AS グループ
,	a1.協力会社コード
,	d1.協力会社名
,	a1.社員コード
,	a1.氏名
,	a1.氏
,	a1.名
,	a1.カナ氏名
,	a1.カナ氏
,	a1.カナ名
,	a1.読み順
,	a1.生年月日
,
	dbo.FuncGetAgeString(
		isnull(a1.生年月日,''),
		getdate(),
		N'才',
		default
	)
	as 年齢年月
,
	dbo.FuncGetAgeString(
		isnull(a1.生年月日,''),
		getdate(),
		N'',
		N'N'
	)
	as 年齢年
,	isnull(a1.性別,1) as 性別
,	isnull(a1.最終学歴,6) as 最終学歴
,	a1.入社日
,	c1.年度 as 入社年度
,
	convert(nvarchar(100),
		convert(nvarchar(3),isnull(a1.経験年,0)) + N'年' +
		convert(nvarchar(3),isnull(a1.経験月,0)) + N'ヶ月'
	)
	as 経験年月
,	isnull(a1.経験年,0) as 経験年
,	isnull(a1.経験月,0) as 経験月
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,
	dbo.FuncGetAgeString(
		isnull(a1.入社日,''),
		isnull(a1.退職日,getdate()),
		default,
		default
	)
	as 勤続年月
,
	dbo.FuncGetAgeString(
		isnull(a1.入社日,''),
		isnull(a1.退職日,getdate()),
		N'',
		N'N'
	)
	as 勤続年
,	a1.メールアドレス
,	a1.郵便番号
,	a1.住所
,	a1.建物名
,	a1.TEL
,	a1.FAX
,	a1.緊急連絡先
,	a1.部署名
,	a1.登録区分
,	a1.更新日時
,	b1.運転許可数
,	b1.運転停止数
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
						( i91.[u_filepath_name] = N'\assets\Icon\employee_male.png' )
					)
				when isnull(a1.性別,1) = 2
				then
					(
					select top 1
						i92.[u_fullpath_name]
					from
						[FileTable_Qassets] as i92
					where
						( i92.[u_filepath_name] = N'\assets\Icon\employee_female.png' )
					)
			end
			else i9.[u_fullpath_name]
	end
	as 顔写真パス名
from
	協力会社社員_T as a1
LEFT OUTER JOIN
	(
	select
		a0.協力会社コード
	,	a0.社員コード
	,	count(a0.発行日) as 運転許可数
	,	count(a0.停止日) as 運転停止数
	from
		協力会社運転許可証_T as a0
	group by
		a0.協力会社コード
	,	a0.社員コード
	)
	as b1
	on b1.協力会社コード = a1.協力会社コード
	and b1.社員コード = a1.社員コード
LEFT OUTER JOIN
	カレンダ_T as c1
	on c1.日付 = a1.入社日
LEFT OUTER JOIN
	協力会社_T as d1
	on d1.協力会社コード = a1.協力会社コード
LEFT OUTER JOIN
	[FileTable_Q協力会社顔写真] as i9
	on i9.[company_code] = a1.協力会社コード
	and i9.[employee_code] = a1.社員コード
)

select
	*
from
	v1 as v100
