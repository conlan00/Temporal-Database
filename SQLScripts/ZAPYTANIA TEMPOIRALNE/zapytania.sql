USE [Test]
GO
DECLARE @pierwsza_rezerwacja DATE
DECLARE @aktualna_data DATE
SET @pierwsza_rezerwacja=( SELECT min(convert (date,waznyOd)) FROM dbo.RezerwacjaHistoria)
SET @aktualna_data =( SELECT convert (date,SYSDATETIME()))
SELECT TOP 3 h.nazwa_hotelu AS 'Nazwa Hotelu', m.nazwa AS 'Miasto w ktorym znajduje sie hotel',
count(Rezerwacja.id_rezerwacji) AS 'Liczba zrealizowanych pobytow'
FROM dbo.Rezerwacja
FOR SYSTEM_TIME FROM @pierwsza_rezerwacja TO @aktualna_data
INNER JOIN dbo.Hotel h ON h.id_hotelu=Rezerwacja.id_hotelu
INNER JOIN dbo.Miasto m ON m.id_miasta=h.id_miasta
WHERE (Rezerwacja.data_wymeldowania IN (select convert (date,WaznyDo) FROM dbo.RezerwacjaHistoria) ) 
AND ('11:00:00.0000000' IN (SELECT convert (time,WaznyDo) FROM dbo.RezerwacjaHistoria))
GROUP BY h.nazwa_hotelu, m.nazwa
ORDER BY count(Rezerwacja.id_rezerwacji) DESC
GO
DECLARE @pierwsza_rezerwacja DATE
DECLARE @aktualna_data DATE
SET @pierwsza_rezerwacja=( SELECT min(convert (date,waznyOd)) FROM dbo.RezerwacjaHistoria)
SET @aktualna_data =( SELECT convert (date,SYSDATETIME()))
SELECT k.imie+' '+k.nazwisko AS 'KLIENT',  k.email AS 'E-MAIL'
FROM dbo.Rezerwacja
FOR SYSTEM_TIME FROM @pierwsza_rezerwacja TO @aktualna_data
INNER JOIN dbo.Klient k ON Rezerwacja.nazwa_uzytkownika=k.nazwa_uzytkownika
WHERE (Rezerwacja.data_wymeldowania IN (select convert (date,WaznyDo) FROM dbo.RezerwacjaHistoria) ) 
AND ('11:00:00.0000000' IN (SELECT convert (time(7),WaznyDo,0) FROM dbo.RezerwacjaHistoria))
GROUP BY k.imie, k.nazwisko,k.email 
HAVING(SELECT MAX(s.warosc) FROM(
SELECT COUNT(Rezerwacja.id_rezerwacji) as warosc   FROM  dbo.Rezerwacja 
FOR SYSTEM_TIME FROM @pierwsza_rezerwacja TO @aktualna_data
WHERE (Rezerwacja.data_wymeldowania IN (select convert (date,WaznyDo) FROM dbo.RezerwacjaHistoria) ) 
AND ('11:00:00.0000000' IN (SELECT convert (time,WaznyDo) FROM dbo.RezerwacjaHistoria))
Group By Rezerwacja.nazwa_uzytkownika) s) 
IN
(COUNT(Rezerwacja.id_rezerwacji))
GO
DECLARE @pierwsza_rezerwacja DATE
DECLARE @aktualna_data DATE
SET @pierwsza_rezerwacja=( SELECT min(convert (date,waznyOd)) FROM dbo.RezerwacjaHistoria)
SET @aktualna_data =( SELECT convert (date,SYSDATETIME()))
SELECT s.rok as 'LATA',sum(s.suma) as 'ZAROBEK [PLN]'
FROM(
SELECT Year(waznyDo) AS rok,DATEDIFF(day,data_zameldowania,data_wymeldowania)*t.cena AS suma
FROM Rezerwacja 
FOR SYSTEM_TIME BETWEEN @pierwsza_rezerwacja AND @aktualna_data
INNER JOIN dbo.Pokoj p ON Rezerwacja.numer_pokoju=p.numer_pokoju
INNER JOIN dbo.TypPokoju t ON p.id_typu_pokoju=t.id_typu_pokoju
WHERE (Rezerwacja.data_wymeldowania IN (SELECT convert (date,WaznyDo) FROM dbo.RezerwacjaHistoria) ) 
AND ('11:00:00.0000000' IN (SELECT convert (time,WaznyDo) FROM dbo.RezerwacjaHistoria))
GROUP BY data_zameldowania,data_wymeldowania,t.cena ,Year(waznyDo)
HAVING DATEDIFF(day,data_zameldowania,data_wymeldowania)>0) s
GROUP BY s.rok
GO
DECLARE @pierwsza_zmiana DATE
DECLARE @aktualna_data DATE
SET @pierwsza_zmiana=(SELECT min(convert (date,waznyOd)) FROM dbo.KlientHistoria)
SET @aktualna_data =(SELECT convert (date,SYSDATETIME()))
SELECT poprzedni.imie+' '+poprzedni.nazwisko+' '+poprzedni.pesel AS 'DANE HISTORIA',aktualny.imie+' '+aktualny.nazwisko+' '+aktualny.pesel AS 'DANE AKTUALNE'
,CASE WHEN poprzedni.imie=aktualny.imie
THEN 'BRAK BLEDU W IMIENIU' ELSE 'BLAD W IMIENIU' 
END AS 'ERROR 1'
,CASE
WHEN poprzedni.nazwisko=aktualny.nazwisko
THEN 'BRAK BLEDU W NAZWISKU' ELSE 'BLAD W NAZWISKU' 
END AS 'ERROR 2'
,CASE
WHEN poprzedni.pesel=aktualny.pesel
THEN 'BRAK BLEDU W PESLU' ELSE 'BLAD W PESLU' 
END AS 'ERROR 3'
FROM
(SELECT row_number() OVER (ORDER BY nazwa_uzytkownika) AS '#BLAD#',imie ,nazwisko , pesel 
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
WHERE WaznyDo <> '9999-12-31 23:59:59.9999999' AND (
(imie  NOT IN (SELECT imie FROM dbo.Klient)) OR (nazwisko NOT IN (SELECT nazwisko FROM dbo.Klient)) 
OR (pesel NOT IN (SELECT pesel FROM dbo.Klient))
)) poprzedni
FULL OUTER JOIN
(SELECT  row_number() over (ORDER BY nazwa_uzytkownika) AS '#BLAD#',imie,nazwisko , pesel 
FROM dbo.Klient
WHERE nazwa_uzytkownika IN (
SELECT nazwa_uzytkownika 
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
WHERE WaznyDo <> '9999-12-31 23:59:59.9999999' AND (
(imie  NOT IN (SELECT imie FROM dbo.Klient)) OR (nazwisko NOT IN (SELECT nazwisko FROM dbo.Klient)) 
OR (pesel NOT IN (SELECT pesel FROM dbo.Klient))
)
)) aktualny
ON poprzedni.#BLAD#=aktualny.#BLAD#
GO
DECLARE @pierwsza_zmiana DATE
DECLARE @aktualna_data DATE
SET @pierwsza_zmiana=(SELECT min(convert (date,waznyOd)) FROM dbo.KlientHistoria)
SET @aktualna_data =(SELECT convert (date,SYSDATETIME()))
SELECT poprzedni.nazwisko AS 'NAZWISKO',poprzedni.ulica AS 'ADRES ZAMIESZKANIA',poprzedni.kod_pocztowy AS 'KOD POCZTOWY',poprzedni.nazwa AS 'MIASTO',
aktualny.nazwisko AS 'NAZWISKO akt',aktualny.ulica AS 'ADRES ZAMIESZKANIA akt',aktualny.kod_pocztowy AS 'KOD POCZTOWY akt',aktualny.nazwa AS 'MIASTO akt'
FROM
(SELECT row_number() over (ORDER BY nazwisko) AS Przeprowadzka,nazwisko, ulica, kod_pocztowy,m.nazwa
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE (WaznyDo <> '9999-12-31 23:59:59.9999999') AND ( ulica NOT IN (SELECT ulica FROM dbo.Klient)) 
OR (kod_pocztowy NOT IN(SELECT kod_pocztowy FROM dbo.Klient))
) poprzedni 
FULL OUTER JOIN 
(SELECT row_number() over (ORDER BY nazwisko) AS Przeprowadzka, nazwisko, ulica, kod_pocztowy,m.nazwa
FROM dbo.Klient
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE nazwa_uzytkownika IN (SELECT nazwa_uzytkownika 
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE (WaznyDo <> '9999-12-31 23:59:59.9999999') AND ( ulica NOT IN (SELECT ulica FROM dbo.Klient)) 
OR (kod_pocztowy NOT IN(SELECT kod_pocztowy FROM dbo.Klient))
)
) aktualny
ON
poprzedni.Przeprowadzka=aktualny.Przeprowadzka
GO
DECLARE @pierwsza_zmiana DATE
DECLARE @aktualna_data DATE
SET @pierwsza_zmiana=(SELECT min(convert (date,waznyOd)) FROM dbo.KlientHistoria)
SET @aktualna_data =(SELECT convert (date,SYSDATETIME()))
SELECT g.[MIASTO akt],count(g.[MIASTO akt]) AS 'ILOSC OSOB'
FROM(
SELECT poprzedni.nazwisko AS 'NAZWISKO',poprzedni.ulica AS 'ADRES ZAMIESZKANIA',poprzedni.kod_pocztowy AS 'KOD POCZTOWY',poprzedni.nazwa AS 'MIASTO',
aktualny.nazwisko AS 'NAZWISKO akt',aktualny.ulica AS 'ADRES ZAMIESZKANIA akt',aktualny.kod_pocztowy AS 'KOD POCZTOWY akt',aktualny.nazwa AS 'MIASTO akt'
FROM
(SELECT row_number() over (ORDER BY nazwisko) AS Przeprowadzka,nazwisko, ulica, kod_pocztowy,m.nazwa
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE (WaznyDo <> '9999-12-31 23:59:59.9999999') AND ( ulica NOT IN (SELECT ulica FROM dbo.Klient)) 
OR (kod_pocztowy NOT IN(SELECT kod_pocztowy FROM dbo.Klient))
) poprzedni 
FULL OUTER JOIN 
(SELECT row_number() over (ORDER BY nazwisko) AS Przeprowadzka, nazwisko, ulica, kod_pocztowy,m.nazwa
FROM dbo.Klient
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE nazwa_uzytkownika IN (SELECT nazwa_uzytkownika 
FROM dbo.Klient
FOR SYSTEM_TIME BETWEEN @pierwsza_zmiana AND @aktualna_data
INNER JOIN dbo.Miasto m ON m.id_miasta=Klient.id_miasta
WHERE (WaznyDo <> '9999-12-31 23:59:59.9999999') AND ( ulica NOT IN (SELECT ulica FROM dbo.Klient)) 
OR (kod_pocztowy NOT IN(SELECT kod_pocztowy FROM dbo.Klient))
)
) aktualny
ON poprzedni.Przeprowadzka=aktualny.Przeprowadzka
) g
GROUP BY g.[MIASTO akt]
GO