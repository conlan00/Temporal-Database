# Temporal-Database

Spis treści
1. Problem biznesowy 
2. Model relacyjny problemu – forma graficzna 
3. Krótki opis modelu
4. Funkcje 
5. Triggery 
6. Zapytania temporalne

 ----------------
1. Problem biznesowy
   
Wybranym problemem biznesowym jest „Rezerwacja pokoi w hotelach”. Projektując model bazy danych szczególną uwage zwrociłem na table : Klient, Rezerwacja. Na przykładzie tych tabel będę starał się zaprezentować możliwości, zalety, zastosowanie „system-versioned tables”, czyli tabel temporalnych, przechowujących znaczniki czasu. Model biznesowy możemy porównać do serwisu internetowego, który udostępnia nam możliwość złożenia rezerwacji w hotelu. Najistotniejsze tabele, przy pomocy, których pokażę temporalność zawierają dane o kliencie tzn. takie dane, które opisują użytkownika w internecie, który po założeniu konta chce złożyć rezerwacje oraz rezerwacje, które mogą być w różnym stanie. Jak wiadomo, dane użytkowników, jak i rezerwacji w czasie 
mogą się zmieniać więc warto przechowywać takie dane na temat klientów i rezerwacji, aby zastosować je w różnych celach biznesowych.

2. Model relacyjny problemu – forma graficzna

![Zrzut ekranu 2023-10-16 215154](https://github.com/conlan00/Temporal-Database/assets/104897926/355389e6-04dd-497d-969e-c405bfe4f86e)

3. Krótki opis modelu

Graficzne przedstawienie bazy danych zostało przygotowane przy pomocy programu ORACLE DATA MODELER. W modelu bazy danych tabele oznaczone literką T (różowe) są temporalne, tzn. tworzą się do nich takie same tabele, które przechowują historię. Znaczniki czasu oznaczyłem tutaj jako TIMESTAMP. Na podstawie powyższego modelu przedstawię możliwości i działanie jakie udostępniają nam temporalne bazy danych w MSSQL.

4. Funkcje

   4.1. Funkcja sprawdzająca czy wprowadzony ciąg składa się tylko z liczb 
   4.2. Funkcja licząca ile dni zostało klientowi do rezerwacji od bieżącej daty
5. Triggery

   5.1. Trigger sprawdzający pesel 
   5.2. Trigger blokujący możliwość wstawienia województwa
   5.3. Trigger sprawdzający daty zameldowania
6. Zapytania temporalne

   6.1. Najchętniej odwiedzane hotele przez klientów 
   6.2. Najczęściej podróżujący klient
   6.3. Zestawienie zarobków firmy na podstawie rezerwacji, które się odbyły 
   6.4. Informacje dotyczące klientów, którzy zmienili dane 
   6.5. Zestawienie zmiany miejsc zamieszkania klientów 
   6.5.1. Dane
   6.5.2. Ilość osób, które dokonały przeprowadzek do poszczególnych miast 
