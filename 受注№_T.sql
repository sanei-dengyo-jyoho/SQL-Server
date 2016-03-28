USE [UserOrderDB]
GO

CREATE TABLE
	[dbo].[受注№_T]
	(
	[受注№] [nvarchar](20) NOT NULL
,	[受注№枝番] [int] NOT NULL
,	[訂正区分] [int] NOT NULL
,	[過去データ区分] [int] NULL
,	[TS] [timestamp] NULL
,	CONSTRAINT
	[PK_受注№_T]
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
