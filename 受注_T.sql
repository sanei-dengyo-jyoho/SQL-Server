USE [UserOrderDB]
GO

CREATE TABLE
	[dbo].[受注_T]
(
	[受注№] [nvarchar](20) NOT NULL
,	[受注№枝番] [int] NOT NULL
,	[訂正区分] [int] NOT NULL
,	[過去データ区分] [int] NULL
,	[訂正元受注№] [nvarchar](20) NULL
,	[取引先コード] [int] NULL
,	[入札レコード№] [int] NULL
,	[部門コード] [int] NULL
,	[社員コード] [int] NULL
,	[種別コード] [int] NULL
,	[小口] [int] NULL
,	[工事件名] [nvarchar](100) NULL
,	[県コード] [int] NULL
,	[市町村コード] [int] NULL
,	[地区コード] [int] NULL
,	[工事場所] [nvarchar](100) NULL
,	[工期自日付] [datetime] NULL
,	[工期至日付] [datetime] NULL
,	[発行日付] [datetime] NULL
,	[発行年月] [int] NULL
,	[発行年] [int] NULL
,	[発行月] [int] NULL
,	[発行日] [int] NULL
,	[落成日付] [datetime] NULL
,	[落成年月] [int] NULL
,	[落成年] [int] NULL
,	[落成月] [int] NULL
,	[落成日] [int] NULL
,	[受注年度] [int] NULL
,	[受注年月] [int] NULL
,	[受注年] [int] NULL
,	[受注月] [int] NULL
,	[担当部門コード] [int] NULL
,	[担当社員コード] [int] NULL
,	[担当者名] [nvarchar](50) NULL
,	[構造主] [nvarchar](50) NULL
,	[構造従] [nvarchar](50) NULL
,	[延床面積] [money] NULL
,	[建物用途] [nvarchar](50) NULL
,	[受注額] [money] NULL
,	[消費税率] [decimal](8, 2) NULL
,	[消費税額] [money] NULL
,	[備考] [nvarchar](200) NULL
,	[ＣＯＲＩＮＳ番号] [nvarchar](20) NULL
,	[TS] [timestamp] NULL
,	CONSTRAINT
	[PK_受注_T]
	PRIMARY KEY
	CLUSTERED
	(
	[受注№] ASC
,	[受注№枝番] ASC
,	[訂正区分] ASC
	)
	WITH
	(
	PAD_INDEX = OFF
,	STATISTICS_NORECOMPUTE = OFF
,	IGNORE_DUP_KEY = OFF
,	ALLOW_ROW_LOCKS = ON
,	ALLOW_PAGE_LOCKS = ON
	)
	ON [PRIMARY]
)
ON [PRIMARY]
