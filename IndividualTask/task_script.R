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


## найменування стовпців

colnames(dataframe)


## Опис моделі фрейму

summary(dataframe)


## Огляд структури фрейму

str(dataframe)



# Перевіряємо наявність пустих даних

apply(dataframe, 2, function(x) sum(is.na(x)))

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


# Після типізації пусті значення перетворилися на *NA*
# Перевіряємо, в яких стовпцях це відбулося

apply(dataframe, 2, function(x) sum(is.na(x)))


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
tail(dataframe)

summary(dataframe)

str(dataframe)

write.csv(dataframe, 'tidy_chernair.csv')




