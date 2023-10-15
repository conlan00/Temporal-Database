USE [master]
GO
CREATE DATABASE [Test]
GO
USE [Test]
CREATE TABLE [dbo].[KlientHistoria](
	[nazwa_uzytkownika] [varchar](20) NOT NULL,
	[pesel] [varchar](11) NOT NULL,
	[imie] [varchar](10) NOT NULL,
	[nazwisko] [varchar](15) NOT NULL,
	[email] [varchar](30) NOT NULL,
	[ulica] [varchar](30) NOT NULL,
	[id_miasta] [varchar](5) NOT NULL,
	[kod_pocztowy] [varchar](6) NOT NULL,
	[WaznyOd] [datetime2](7) NOT NULL,
	[WaznyDo] [datetime2](7) NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_MSSQL_TemporalHistoryFor_613577224_DE3646E6] ON [dbo].[KlientHistoria]
(
	[WaznyDo] ASC,
	[WaznyOd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Klient](
	[nazwa_uzytkownika] [varchar](20) NOT NULL,
	[pesel] [varchar](11) NOT NULL,
	[imie] [varchar](10) NOT NULL,
	[nazwisko] [varchar](15) NOT NULL,
	[email] [varchar](30) NOT NULL,
	[ulica] [varchar](30) NOT NULL,
	[id_miasta] [varchar](5) NOT NULL,
	[kod_pocztowy] [varchar](6) NOT NULL,
	[WaznyOd] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[WaznyDo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [Klient_PK] PRIMARY KEY CLUSTERED 
(
	[nazwa_uzytkownika] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Klient__UN] UNIQUE NONCLUSTERED 
(
	[pesel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Klient__UNv1] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([WaznyOd], [WaznyDo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[KlientHistoria])
)
GO
CREATE TABLE [dbo].[RezerwacjaHistoria](
	[id_rezerwacji] [numeric](5, 0) NOT NULL,
	[nazwa_uzytkownika] [varchar](20) NOT NULL,
	[numer_pokoju] [numeric](3, 0) NOT NULL,
	[id_hotelu] [numeric](4, 0) NOT NULL,
	[data_zameldowania] [date] NOT NULL,
	[data_wymeldowania] [date] NOT NULL,
	[WaznyOd] [datetime2](7) NOT NULL,
	[WaznyDo] [datetime2](7) NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_RezerwacjaHistoria] ON [dbo].[RezerwacjaHistoria]
(
	[WaznyDo] ASC,
	[WaznyOd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Rezerwacja](
	[id_rezerwacji] [numeric](5, 0) NOT NULL,
	[nazwa_uzytkownika] [varchar](20) NOT NULL,
	[numer_pokoju] [numeric](3, 0) NOT NULL,
	[id_hotelu] [numeric](4, 0) NOT NULL,
	[data_zameldowania] [date] NOT NULL,
	[data_wymeldowania] [date] NOT NULL,
	[WaznyOd] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[WaznyDo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
 CONSTRAINT [Rezerwacja_PK] PRIMARY KEY CLUSTERED 
(
	[id_rezerwacji] ASC,
	[nazwa_uzytkownika] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([WaznyOd], [WaznyDo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[RezerwacjaHistoria])
)
GO
CREATE TABLE [dbo].[Hotel](
	[id_hotelu] [numeric](4, 0) NOT NULL,
	[nazwa_hotelu] [varchar](50) NOT NULL,
	[id_miasta] [varchar](5) NOT NULL,
	[id_typu_hotelu] [numeric](2, 0) NOT NULL,
 CONSTRAINT [Hotel_PK] PRIMARY KEY CLUSTERED 
(
	[id_hotelu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Hotel__UN] UNIQUE NONCLUSTERED 
(
	[nazwa_hotelu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Miasto](
	[id_miasta] [varchar](5) NOT NULL,
	[nazwa] [varchar](15) NOT NULL,
	[id_powiatu] [varchar](5) NOT NULL,
 CONSTRAINT [Miasto_PK] PRIMARY KEY CLUSTERED 
(
	[id_miasta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Miasto__UN] UNIQUE NONCLUSTERED 
(
	[nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Pokoj](
	[numer_pokoju] [numeric](3, 0) NOT NULL,
	[opis] [varchar](100) NULL,
	[id_typu_pokoju] [numeric](2, 0) NOT NULL,
 CONSTRAINT [Pokoj_PK] PRIMARY KEY CLUSTERED 
(
	[numer_pokoju] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Powiat](
	[id_powiatu] [varchar](5) NOT NULL,
	[nazwa] [varchar](35) NOT NULL,
	[id_wojewodztwa] [numeric](2, 0) NOT NULL,
 CONSTRAINT [Powiat_PK] PRIMARY KEY CLUSTERED 
(
	[id_powiatu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Powiat__UN] UNIQUE NONCLUSTERED 
(
	[nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[TypHotelu](
	[id_typu_hotelu] [numeric](2, 0) NOT NULL,
	[nazwa] [varchar](30) NOT NULL,
 CONSTRAINT [TypHotelu_PK] PRIMARY KEY CLUSTERED 
(
	[id_typu_hotelu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [TypHotelu__UN] UNIQUE NONCLUSTERED 
(
	[nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[TypPokoju](
	[id_typu_pokoju] [numeric](2, 0) NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[opis] [varchar](300) NOT NULL,
	[cena] [numeric](5, 0) NOT NULL,
 CONSTRAINT [TypPokoju_PK] PRIMARY KEY CLUSTERED 
(
	[id_typu_pokoju] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [TypPokoju__UN] UNIQUE NONCLUSTERED 
(
	[nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[Wojewodztwo](
	[id_wojewodztwa] [numeric](2, 0) NOT NULL,
	[nazwa] [varchar](35) NOT NULL,
 CONSTRAINT [Wojewodztwo_PK] PRIMARY KEY CLUSTERED 
(
	[id_wojewodztwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [Wojewodztwo__UN] UNIQUE NONCLUSTERED 
(
	[nazwa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [Hotel_Miasto_FK] FOREIGN KEY([id_miasta])
REFERENCES [dbo].[Miasto] ([id_miasta])
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [Hotel_Miasto_FK]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [Hotel_TypHotelu_FK] FOREIGN KEY([id_typu_hotelu])
REFERENCES [dbo].[TypHotelu] ([id_typu_hotelu])
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [Hotel_TypHotelu_FK]
GO
ALTER TABLE [dbo].[Klient]  WITH CHECK ADD  CONSTRAINT [Klient_Miasto_FK] FOREIGN KEY([id_miasta])
REFERENCES [dbo].[Miasto] ([id_miasta])
GO
ALTER TABLE [dbo].[Klient] CHECK CONSTRAINT [Klient_Miasto_FK]
GO
ALTER TABLE [dbo].[Miasto]  WITH CHECK ADD  CONSTRAINT [Miasto_Powiat_FK] FOREIGN KEY([id_powiatu])
REFERENCES [dbo].[Powiat] ([id_powiatu])
GO
ALTER TABLE [dbo].[Miasto] CHECK CONSTRAINT [Miasto_Powiat_FK]
GO
ALTER TABLE [dbo].[Pokoj]  WITH CHECK ADD  CONSTRAINT [Pokoj_TypPokoju_FK] FOREIGN KEY([id_typu_pokoju])
REFERENCES [dbo].[TypPokoju] ([id_typu_pokoju])
GO
ALTER TABLE [dbo].[Pokoj] CHECK CONSTRAINT [Pokoj_TypPokoju_FK]
GO
ALTER TABLE [dbo].[Powiat]  WITH CHECK ADD  CONSTRAINT [Powiat_Wojewodztwo_FK] FOREIGN KEY([id_wojewodztwa])
REFERENCES [dbo].[Wojewodztwo] ([id_wojewodztwa])
GO
ALTER TABLE [dbo].[Powiat] CHECK CONSTRAINT [Powiat_Wojewodztwo_FK]
GO
ALTER TABLE [dbo].[Rezerwacja]  WITH CHECK ADD  CONSTRAINT [Rezerwacja_Hotel_FK] FOREIGN KEY([id_hotelu])
REFERENCES [dbo].[Hotel] ([id_hotelu])
GO
ALTER TABLE [dbo].[Rezerwacja] CHECK CONSTRAINT [Rezerwacja_Hotel_FK]
GO
ALTER TABLE [dbo].[Rezerwacja]  WITH CHECK ADD  CONSTRAINT [Rezerwacja_Klient_FK] FOREIGN KEY([nazwa_uzytkownika])
REFERENCES [dbo].[Klient] ([nazwa_uzytkownika])
GO
ALTER TABLE [dbo].[Rezerwacja] CHECK CONSTRAINT [Rezerwacja_Klient_FK]
GO
ALTER TABLE [dbo].[Rezerwacja]  WITH CHECK ADD  CONSTRAINT [Rezerwacja_Pokoj_FK] FOREIGN KEY([numer_pokoju])
REFERENCES [dbo].[Pokoj] ([numer_pokoju])
GO
ALTER TABLE [dbo].[Rezerwacja] CHECK CONSTRAINT [Rezerwacja_Pokoj_FK]
GO
ALTER DATABASE [Test] SET  READ_WRITE 
GO