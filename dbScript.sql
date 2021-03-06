USE [test]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 07/21/2014 14:24:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](50) NULL,
	[UnitPrice] [int] NULL,
	[UnitsInStock] [int] NULL,
	[Discontinued] [bit] NULL,
	[Category] [varchar](50) NULL,
	[CreatedDateTime] [datetime] NULL,
	[UniqueCode] [varchar](50) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (3, N'levis Jeans', 4, 2, 1, N'Men', CAST(0x0000A36F00DA296A AS DateTime), NULL)
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (6, N'Shirt', 6, 1, 1, N'Casual', CAST(0x0000A36F00BC334F AS DateTime), NULL)
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (7, N'T-Shirt', 2, 3, 1, N'Casual', CAST(0x0000A2FB0100CD45 AS DateTime), NULL)
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (16, N'jersy', 2, 3, 1, N'Casual', CAST(0x0000A36F00D2C585 AS DateTime), N'16-jer')
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (17, N'Shorts', 1, 2, 1, N'Men', CAST(0x0000A36F00D864BF AS DateTime), N'17-Sho')
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (18, N'Winter Cap', 1, 2, 1, N'Casual', CAST(0x0000A36F00D89F29 AS DateTime), N'18-Win')
INSERT [dbo].[Product] ([ProductID], [ProductName], [UnitPrice], [UnitsInStock], [Discontinued], [Category], [CreatedDateTime], [UniqueCode]) VALUES (19, N'Summer Hat', 2, 2, 0, N'Casual', CAST(0x0000A36F00D9FE80 AS DateTime), N'19-Sum')
SET IDENTITY_INSERT [dbo].[Product] OFF
/****** Object:  StoredProcedure [dbo].[spUpdateInsertProduct]    Script Date: 07/21/2014 14:24:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateInsertProduct]
	@ID int,
	@ProductName varchar(50),
	@UnitPrice int,
	@UnitsInStock int,
	@Discontinued bit,
	@Category varchar(50),
	@RetID int output
AS
BEGIN
	SET NOCOUNT ON;
	IF EXISTS(SELECT * FROM Product WHERE ProductID=@ID)
	BEGIN
		UPDATE Product
		SET ProductName=@ProductName ,UnitPrice=@UnitPrice,UnitsInStock=@UnitsInStock,Discontinued=@Discontinued,Category=@Category,CreatedDateTime=GETDATE()
		WHERE ProductID=@ID

		SET @RetID=@ID
		RETURN @RetID
	END

	INSERT INTO Product (ProductName, UnitPrice, UnitsInStock , Discontinued,Category,CreatedDateTime)
	VALUES(@ProductName, @UnitPrice, @UnitsInStock , @Discontinued,@Category,GETDATE())
	
	IF @@ERROR<>0
	BEGIN
		SET @RetID=-1
	END

	SET @RetID=SCOPE_IDENTITY()

	if SCOPE_IDENTITY()>0
	BEGIN
		UPDATE Product
		SET UniqueCode=cast(SCOPE_IDENTITY() as varchar)+'-'+Left(@ProductName,3) WHERE ProductID=SCOPE_IDENTITY()
	END
	--CONVERT(varchar(255), NEWID()) --this will generate random sting in 2008

	RETURN @RetID
END
GO
