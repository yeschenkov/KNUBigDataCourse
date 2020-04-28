## Зчитування html сторінки
library("rvest")
htmlpage <- read_html("http://www.imdb.com/search/title?count=100&release_date=2017,2017&title_type=feature")
html <- html_nodes(htmlpage,'.text-primary')
rank <- as.numeric(html_text(html))
title_html <- html_nodes(htmlpage,'.lister-item-header a')
title <- html_text(title_html)
runtime_html <- html_nodes(htmlpage,'.text-muted .runtime')
runtime <- html_text(runtime_html)
runtime <- as.numeric(gsub(" min", "", runtime))
movies <- data.frame(Rank = rank, Title = title, Runtime = runtime, stringsAsFactors = FALSE )

## 1. Виведіть перші 6 назв фільмів дата фрейму.

head(movies$Title)

## 2. Виведіть всі назви фільмів с тривалістю більше 120 хв.

movies[movies$Runtime > 120, ]$Title

## 3. Скільки фільмів мають тривалість менше 100 хв

length(which(movies$Runtime < 100))
