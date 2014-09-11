with

v0 as
( 
select
	協力会社コード
,	社員コード
,	count(発行日) as 運転許可数
,	count(停止日) as 運転停止数
from
	協力会社運転許可証_Q as a0
group by
	協力会社コード,
,	社員コード 
)
,

v1 as
(
select
	a1.日付
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
,	dbo.FuncGetAgeString(isnull(a1.生年月日,''),getdate(),'才',default) as 年齢年月
,	dbo.FuncGetAgeString(isnull(a1.生年月日,''),getdate(),'','N') as 年齢年
,	isnull(a1.性別,1) as 性別
,	isnull(a1.最終学歴,6) as 最終学歴
,	a1.入社日
,	c1.年度 as 入社年度
,	convert(varchar(3),isnull(a1.経験年,0)) + '年' + convert(varchar(3),isnull(a1.経験月,0)) + 'ヶ月' as 経験年月
,	isnull(a1.経験年,0) as 経験年
,	isnull(a1.経験月,0) as 経験月
,	a1.発令日
,	a1.退職日
,	a1.退職年度
,	dbo.FuncGetAgeString(isnull(a1.入社日,''),isnull(a1.退職日,getdate()),default,default) as 勤続年月
,	dbo.FuncGetAgeString(isnull(a1.入社日,''),isnull(a1.退職日,getdate()),'','N') as 勤続年
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
from
	協力会社社員_T異動 as a1
left join
	v0 as b1
	on b1.協力会社コード = a1.協力会社コード
	and b1.社員コード = a1.社員コード
left join
	カレンダ_T as c1
	on c1.日付 = a1.入社日
left join
	協力会社_T as d1
	on d1.協力会社コード = a1.協力会社コード
)

select
	*
from
	v1 as a2

