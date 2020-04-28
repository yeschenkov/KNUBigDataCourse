task\_script.R
================
v.yeshchenkov
2020-04-28

``` r
library('dplyr') 
library('leaflet.extras') 
library('DT') 
library('tidyr') 
library('tidyverse') 
library('zoo')
library('lubridate')


## Завантаження даних
setwd('C:/Users/v.yeshchenkov/Documents/Big data/IndividualTask')
dataframe <- read.csv('CHERNAIR.csv', stringsAsFactors = FALSE)


# Першопочатковий огляд даних
# Спочатку необхідно провести огляд використовуючи функції *summary*,*colnames*, *dim*, *str*,  *is.na*. 

## Отримання обсягу фрейму

dim(dataframe)
```

    ## [1] 2051   11

``` r
## найменування стовпців

colnames(dataframe)
```

    ##  [1] "PAYS"            "Code"            "Ville"          
    ##  [4] "X"               "Y"               "Date"           
    ##  [7] "End.of.sampling" "Duration.h.min." "I.131..Bq.m3."  
    ## [10] "Cs.134..Bq.m3."  "Cs.137..Bq.m3."

``` r
## Опис моделі фрейму

summary(dataframe)
```

    ##      PAYS                Code          Ville                 X        
    ##  Length:2051        Min.   : 1.00   Length:2051        Min.   :-6.28  
    ##  Class :character   1st Qu.: 3.00   Class :character   1st Qu.: 5.18  
    ##  Mode  :character   Median : 8.00   Mode  :character   Median : 9.80  
    ##                     Mean   :10.34                      Mean   :11.96  
    ##                     3rd Qu.:14.00                      3rd Qu.:14.50  
    ##                     Max.   :24.00                      Max.   :50.68  
    ##        Y             Date           End.of.sampling    Duration.h.min. 
    ##  Min.   : 0.00   Length:2051        Length:2051        Min.   :  0.20  
    ##  1st Qu.:45.80   Class :character   Class :character   1st Qu.:  6.00  
    ##  Median :48.46   Mode  :character   Mode  :character   Median : 24.00  
    ##  Mean   :47.54                                         Mean   : 20.81  
    ##  3rd Qu.:52.76                                         3rd Qu.: 24.00  
    ##  Max.   :63.83                                         Max.   :700.00  
    ##  I.131..Bq.m3.      Cs.134..Bq.m3.     Cs.137..Bq.m3.    
    ##  Length:2051        Length:2051        Length:2051       
    ##  Class :character   Class :character   Class :character  
    ##  Mode  :character   Mode  :character   Mode  :character  
    ##                                                          
    ##                                                          
    ## 

``` r
## Огляд структури фрейму

str(dataframe)
```

    ## 'data.frame':    2051 obs. of  11 variables:
    ##  $ PAYS           : chr  "SE" "SE" "SE" "SE" ...
    ##  $ Code           : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Ville          : chr  "RISOE" "RISOE" "RISOE" "RISOE" ...
    ##  $ X              : num  12.1 12.1 12.1 12.1 12.1 ...
    ##  $ Y              : num  55.7 55.7 55.7 55.7 55.7 55.7 55.7 55.7 55.7 55.7 ...
    ##  $ Date           : chr  "86/04/27" "86/04/28" "86/04/29" "86/04/29" ...
    ##  $ End.of.sampling: chr  "24:00:00" "24:00:00" "12:00" "24:00:00" ...
    ##  $ Duration.h.min.: num  24 24 12 12 24 24 24 24 12 12 ...
    ##  $ I.131..Bq.m3.  : chr  "1" "0.0046" "0.0147" "0.00061" ...
    ##  $ Cs.134..Bq.m3. : chr  "0" "0.00054" "0.0043" "0" ...
    ##  $ Cs.137..Bq.m3. : chr  "0.24" "0.00098" "0.0074" "0.00009" ...

``` r
# Перевіряємо наявність пустих даних

apply(dataframe, 2, function(x) sum(is.na(x)))
```

    ##            PAYS            Code           Ville               X 
    ##               0               0               0               0 
    ##               Y            Date End.of.sampling Duration.h.min. 
    ##               0               0               0               0 
    ##   I.131..Bq.m3.  Cs.134..Bq.m3.  Cs.137..Bq.m3. 
    ##               0               0               0

``` r
# Пустих даних у жодному стовпці не знайдено

## Наступним етапом буде опрацювання фрейму та приведення його до зручного вигляду

# Спочатку перейменовуємо назви стовпців для легшого сприйняття та навігації.

dataframe <- dataframe %>% rename(
  Country = PAYS,
  Country_code = Code,
  Region = Ville,
  Latitude = X,
  Longitude = Y,
  Iodine131 = I.131..Bq.m3.,
  Caesium134 = Cs.134..Bq.m3.,
  Caesium137 = Cs.137..Bq.m3.
)


# Після цього позбуваємося від колонок, що не мають необхідності в аналізі *End.of.sampling* та *Duration.h.min.*

dataframe <- subset(dataframe, select = -c(End.of.sampling, Duration.h.min.))


# Так як вимірювання проведено в Європі, переглянувши значення широти та довготи, можна зробити висновок, що вони переплутані. 
# Тому перейменовуємо колонки

colnames(dataframe)[c(4,5)] <- colnames(dataframe)[c(5,4)]


# Для більш гнучкого аналізу виділяємо окремо день, місяць та рік проведення вимірювання 

dataframe <- dataframe %>% 
  mutate(Date = ymd(Date)) %>% 
  mutate_at(vars(Date), funs(year, month, day))


# Приводимо дані до правильного типу

dataframe <- dataframe %>% mutate(
  Country = as.factor(Country),
  Country_code = as.factor(Country_code),
  Region = as.factor(Region),
  Iodine131 = as.numeric(dataframe$Iodine131),
  Caesium134 = as.numeric(dataframe$Caesium134),
  Caesium137 = as.numeric(dataframe$Caesium137)
)
```

    ## Warning: NAs introduced by coercion
    
    ## Warning: NAs introduced by coercion
    
    ## Warning: NAs introduced by coercion

``` r
# Після типізації пусті значення перетворилися на *NA*
# Перевіряємо, в яких стовпцях це відбулося

apply(dataframe, 2, function(x) sum(is.na(x)))
```

    ##      Country Country_code       Region    Longitude     Latitude 
    ##            0            0            0            0            0 
    ##         Date    Iodine131   Caesium134   Caesium137         year 
    ##            0           42          250          545            0 
    ##        month          day 
    ##            0            0

``` r
#З'явилися пусті значення NA у стовпцях Iodine131, Caesium134, Caesium137.

# Позбуваємося від пустих значень через:
# 1. розрахунок середнього арифметичного
# 2. групування по регіону та прийнятя значень за сусідні дні (вважаємо, що показники змінилися несуттєво)
# 3. групування по країні та дню та прийняття існуючого значення (вважаємо, що показники змінилися несуттєво)


dataframe <- dataframe %>%
  group_by_at(vars(-Iodine131, -Caesium134, -Caesium137)) %>%
  summarise(Iodine131 = mean(Iodine131, na.rm = T),
            Caesium134 = mean(Caesium134, na.rm =T),
            Caesium137 = mean(Caesium137, na.rm = T))
dataframe$Iodine131[is.nan(dataframe$Iodine131)] <- NA
dataframe$Caesium134[is.nan(dataframe$Caesium134)] <- NA 
dataframe$Caesium137[is.nan(dataframe$Caesium137)] <- NA



dataframe <- dataframe %>%
  group_by(Region) %>% 
  mutate(Iodine131 = na.locf(Iodine131, na.rm = F, fromLast = T, maxgap = 3)) %>%
  mutate(Caesium134 = na.locf(Caesium134, na.rm = F, fromLast = T, maxgap = 3)) %>%
  mutate(Caesium137 = na.locf(Caesium137, na.rm = F, fromLast = T, maxgap = 3))   

dataframe <- dataframe %>%
  group_by(Region) %>% 
  mutate(Iodine131 = na.locf(Iodine131, na.rm = F, fromLast = F, maxgap = 3)) %>%
  mutate(Caesium134 = na.locf(Caesium134, na.rm = F, fromLast = F, maxgap = 3)) %>%
  mutate(Caesium137 = na.locf(Caesium137, na.rm = F, fromLast = F, maxgap = 3))     



dataframe <- dataframe %>% group_by(Country, day) %>%
  mutate(Iodine131 = replace(Iodine131, is.na(Iodine131), mean(Iodine131, na.rm = TRUE))) %>%
  mutate(Caesium134 = replace(Caesium134, is.na(Caesium134), mean(Caesium134, na.rm = TRUE))) %>%
  mutate(Caesium137 = replace(Caesium137, is.na(Caesium137), mean(Caesium137, na.rm = TRUE)))


# Позбуваємося від рядків, дані в яких відновити не вдалося

dataframe <- dataframe %>% na.omit


# Приводимо назви країн до зручного вигляду (Повні назви)


unique(dataframe$Country)
```

    ##  [1] AU BE CH CZ DE ES F  FI GR HU IT NL NO SE UK
    ## Levels: AU BE CH CZ DE ES F FI GR HU IR IT NL NO SE UK

``` r
dataframe$Country <- as.character(dataframe$Country)
dataframe <- dataframe %>% 
  ungroup(Country) %>% 
  mutate(Country = replace(Country, Country == "AU", "Austria"))  %>%
  mutate(Country = replace(Country, Country == "BE", "Belgium")) %>%
  mutate(Country = replace(Country, Country == "CH", "Switzerland")) %>%
  mutate(Country = replace(Country, Country == "CZ", "Czechoslovakia"))  %>% #At that moment Czecia and Slovakia were not two independent countries.
  mutate(Country = replace(Country, Country == "DE", "Germany")) %>%
  mutate(Country = replace(Country, Country == "ES", "Spain")) %>%
  mutate(Country = replace(Country, Country == "F", "France")) %>%
  mutate(Country = replace(Country, Country == "FI", "Finland")) %>%
  mutate(Country = replace(Country, Country == "GR", "Greece")) %>%
  mutate(Country = replace(Country, Country == "HU", "Hungary")) %>%
  mutate(Country = replace(Country, Country == "IT", "Italy")) %>%
  mutate(Country = replace(Country, Country == "NL", "Netherlands")) %>%
  mutate(Country = replace(Country, Country == "NO", "Norway")) %>%
  mutate(Country = replace(Country, Country == "SE", "Sweden")) %>%
  mutate(Country = replace(Country, Country == "UK", "United Kingdom"))
dataframe$Country = as.factor(dataframe$Country)

head(dataframe)
```

    ## # A tibble: 6 x 12
    ##   Country Country_code Region Longitude Latitude Date        year month
    ##   <fct>   <fct>        <fct>      <dbl>    <dbl> <date>     <dbl> <dbl>
    ## 1 Austria 14           BREGE~      9.78     47.5 1986-04-30  1986     4
    ## 2 Austria 14           BREGE~      9.78     47.5 1986-05-01  1986     5
    ## 3 Austria 14           BREGE~      9.78     47.5 1986-05-02  1986     5
    ## 4 Austria 14           BREGE~      9.78     47.5 1986-05-03  1986     5
    ## 5 Austria 14           BREGE~      9.78     47.5 1986-05-04  1986     5
    ## 6 Austria 14           BREGE~      9.78     47.5 1986-05-05  1986     5
    ## # ... with 4 more variables: day <int>, Iodine131 <dbl>, Caesium134 <dbl>,
    ## #   Caesium137 <dbl>

``` r
tail(dataframe)
```

    ## # A tibble: 6 x 12
    ##   Country Country_code Region Longitude Latitude Date        year month
    ##   <fct>   <fct>        <fct>      <dbl>    <dbl> <date>     <dbl> <dbl>
    ## 1 United~ 9            HARWE~      -1.3     51.6 1986-05-14  1986     5
    ## 2 United~ 9            HARWE~      -1.3     51.6 1986-05-15  1986     5
    ## 3 United~ 9            HARWE~      -1.3     51.6 1986-05-16  1986     5
    ## 4 United~ 9            HARWE~      -1.3     51.6 1986-05-17  1986     5
    ## 5 United~ 9            HARWE~      -1.3     51.6 1986-05-19  1986     5
    ## 6 United~ 9            HARWE~      -1.3     51.6 1986-05-23  1986     5
    ## # ... with 4 more variables: day <int>, Iodine131 <dbl>, Caesium134 <dbl>,
    ## #   Caesium137 <dbl>

``` r
summary(dataframe)
```

    ##            Country     Country_code       Region       Longitude    
    ##  France        :259   3      :259   STOCKHOLM:  33   Min.   :-4.83  
    ##  Germany       :211   2      :211   MOL      :  29   1st Qu.: 4.81  
    ##  Sweden        :152   22     :125   PRAHA    :  29   Median : 9.78  
    ##  Czechoslovakia:122   23     :122   UMEAA    :  29   Mean   :12.44  
    ##  Italy         :118   5      :118   ATTIKIS  :  27   3rd Qu.:14.84  
    ##  Austria       :100   14     :100   RISOE    :  27   Max.   :50.68  
    ##  (Other)       :402   (Other):429   (Other)  :1190                  
    ##     Latitude          Date                 year          month      
    ##  Min.   : 0.00   Min.   :1986-04-27   Min.   :1986   Min.   :4.000  
    ##  1st Qu.:45.21   1st Qu.:1986-05-04   1st Qu.:1986   1st Qu.:5.000  
    ##  Median :48.73   Median :1986-05-08   Median :1986   Median :5.000  
    ##  Mean   :46.88   Mean   :1986-05-09   Mean   :1986   Mean   :4.947  
    ##  3rd Qu.:52.38   3rd Qu.:1986-05-13   3rd Qu.:1986   3rd Qu.:5.000  
    ##  Max.   :63.83   Max.   :1986-08-04   Max.   :1986   Max.   :8.000  
    ##                                                                     
    ##       day          Iodine131          Caesium134       
    ##  Min.   : 1.00   Min.   : 0.00000   Min.   : 0.000000  
    ##  1st Qu.: 5.00   1st Qu.: 0.00300   1st Qu.: 0.000004  
    ##  Median : 9.00   Median : 0.02192   Median : 0.001850  
    ##  Mean   :10.67   Mean   : 0.95312   Mean   : 0.172666  
    ##  3rd Qu.:14.00   3rd Qu.: 0.50000   3rd Qu.: 0.075500  
    ##  Max.   :31.00   Max.   :55.00000   Max.   :12.000000  
    ##                                                        
    ##    Caesium137       
    ##  Min.   : 0.000000  
    ##  1st Qu.: 0.001158  
    ##  Median : 0.007500  
    ##  Mean   : 0.312731  
    ##  3rd Qu.: 0.250225  
    ##  Max.   :11.100000  
    ## 

``` r
str(dataframe)
```

    ## tibble [1,364 x 12] (S3: tbl_df/tbl/data.frame)
    ##  $ Country     : Factor w/ 15 levels "Austria","Belgium",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ Country_code: Factor w/ 17 levels "1","2","3","4",..: 12 12 12 12 12 12 12 12 12 12 ...
    ##  $ Region      : Factor w/ 95 levels "AACHEN(DWD)",..: 13 13 13 13 13 13 13 13 13 13 ...
    ##  $ Longitude   : num [1:1364] 9.78 9.78 9.78 9.78 9.78 9.78 9.78 9.78 9.78 9.78 ...
    ##  $ Latitude    : num [1:1364] 47.5 47.5 47.5 47.5 47.5 ...
    ##  $ Date        : Date[1:1364], format: "1986-04-30" "1986-05-01" ...
    ##  $ year        : num [1:1364] 1986 1986 1986 1986 1986 ...
    ##  $ month       : num [1:1364] 4 5 5 5 5 5 5 5 5 5 ...
    ##  $ day         : int [1:1364] 30 1 2 3 4 5 6 7 8 9 ...
    ##  $ Iodine131   : num [1:1364] 0.00851 2.4013 4.884 2.9785 1.1803 ...
    ##  $ Caesium134  : num [1:1364] 0.403 0.403 1.831 1.164 0.322 ...
    ##  $ Caesium137  : num [1:1364] 0.00114 0.592 3.367 2.22 0.6216 ...

``` r
write.csv(dataframe, 'tidy_chernair.csv')
```
