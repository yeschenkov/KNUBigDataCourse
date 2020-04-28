library("RSQLite")
conn <- dbConnect(SQLite(), "database.sqlite")

## 1. Назва статті (Title), тип виступу (EventType). Необхідно вибрати тільки статті
## с типом виступу Spotlight. Сортування по назві статті.

firstRes <- dbSendQuery(conn, "SELECT Title, EventType FROM Papers WHERE EventType='Spotlight' Order By Title")
firstResFetched <- dbFetch(firstRes, 10)
dbClearResult(firstRes)
firstResFetched

## 2. Ім’я автора (Name), Назва статті (Title). Необхідно вивести всі назви статей
## для автора «Josh Tenenbaum». Сортування по назві статті.

secondRes <- dbSendQuery(conn, "SELECT Title, Name FROM Papers JOIN PaperAuthors ON Papers.Id = PaperId JOIN Authors On AuthorId = Authors.Id WHERE Name='Josh Tenenbaum' Order By Title")
secondResFetched <- dbFetch(secondRes, 10)
dbClearResult(secondRes)
secondResFetched

## 3. Вибрати всі назви статей (Title), в яких є слово «statistical». Сортування по
## назві статті.

thirdRes <- dbSendQuery(conn, "SELECT Title FROM Papers WHERE Title LIKE '%statistical%' Order By Title")
thirdResFetched <- dbFetch(thirdRes, 10)
dbClearResult(thirdRes)
thirdResFetched

## 4. Ім’я автору (Name), кількість статей по кожному автору (NumPapers).
## Сортування по кількості статей від більшої кількості до меньшої

fourthRes <- dbSendQuery(conn, "SELECT Name, count(*) as NumPapers FROM Authors JOIN PaperAuthors ON Authors.id = AuthorId GROUP BY Name Order By NumPapers DESC")
fourthResFetched <- dbFetch(fourthRes, 10)
dbClearResult(fourthRes)
fourthResFetched

