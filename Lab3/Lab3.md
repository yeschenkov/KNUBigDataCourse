Lab3.R
================
v.yeshchenkov
2020-04-27

``` r
## Зчитування html сторінки
library("rvest")
```

    ## Warning: package 'rvest' was built under R version 3.6.3

    ## Loading required package: xml2

    ## Warning: package 'xml2' was built under R version 3.6.3

``` r
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
```

    ## [1] "Той, хто біжить по лезу 2049" "Гра Моллі"                   
    ## [3] "Тор: Раґнарок"                "Назви мене своїм ім'ям"      
    ## [5] "Вбивство священного оленя"    "Воно"

``` r
## 2. Виведіть всі назви фільмів с тривалістю більше 120 хв.

movies[movies$Runtime > 120, ]$Title
```

    ##  [1] "Той, хто біжить по лезу 2049"            
    ##  [2] "Гра Моллі"                               
    ##  [3] "Тор: Раґнарок"                           
    ##  [4] "Назви мене своїм ім'ям"                  
    ##  [5] "Вбивство священного оленя"               
    ##  [6] "Воно"                                    
    ##  [7] "Вартові Галактики 2"                     
    ##  [8] "Людина-павук: Повернення додому"         
    ##  [9] "Зоряні війни: Епізод 8 - Останні Джедаї" 
    ## [10] "Красуня і Чудовисько"                    
    ## [11] "Пірати Карибського моря: Помста Салазара"
    ## [12] "Форма води"                              
    ## [13] "Логан: Росомаха"                         
    ## [14] "Трансформери: Останній лицар"            
    ## [15] "Валеріан і місто тисячі планет"          
    ## [16] "Чужий: Заповіт"                          
    ## [17] "Диво-жінка"                              
    ## [18] "Kingsman: Золоте кільце"                 
    ## [19] "Джон Вік 2"                              
    ## [20] "Мати!"                                   
    ## [21] "Темні часи"                              
    ## [22] "Примарна нитка"                          
    ## [23] "Король Артур: Легенда меча"              
    ## [24] "Сім сестер"                              
    ## [25] "The Shack"                               
    ## [26] "1+1: Нова історія"                       
    ## [27] "Метелик"                                 
    ## [28] "Форсаж 8"                                
    ## [29] "Вороги"                                  
    ## [30] "Війна за планету мавп"                   
    ## [31] "Saban's Могутні рейнджери"               
    ## [32] "Постріл в безодню"                       
    ## [33] "Зменшення"                               
    ## [34] "Ферма Мадбаунд"                          
    ## [35] "Усі гроші світу"

``` r
## 3. Скільки фільмів мають тривалість менше 100 хв

length(which(movies$Runtime < 100))
```

    ## [1] 12
