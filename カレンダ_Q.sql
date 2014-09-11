SELECT
	a.日付
,	a.年度
,	a.年
,	a.月
,	a.日
,	a.週
,	a.業務週
,	a.月間週
,	a.曜日
,	a.曜日名
,	a.平日区分
,	a.稼働区分
,	c.名称 AS 稼働内容
,	d.祝日名
,	b.年号
,	b.年号略称
,	b.年 as 和暦年
,	b.年号+convert(varchar(4),b.年) + '年' as 和暦年表示
,	b.年号+convert(varchar(4),b.年) + '年' + convert(varchar(4),month(a.日付)) + '月' + convert(varchar(4),day(a.日付)) + '日' as 和暦日付
,	b.年号略称+convert(varchar(4),b.年) as 和暦年表示略称
,	b.年号略称+convert(varchar(4),b.年) + '.' + convert(varchar(4),month(a.日付)) + '.' + convert(varchar(4),day(a.日付)) as 和暦日付略称

FROM
	カレンダ_T as a
LEFT OUTER JOIN
	和暦_T as b
	ON b.西暦 = a.年
LEFT OUTER JOIN
	稼働区分_Q as c
	ON c.コード = a.稼働区分
LEFT OUTER JOIN
	dbo.祝日_T as d
	ON d.日付 = a.日付

