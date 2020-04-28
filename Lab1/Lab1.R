## Завдання 1
library("readxl")
tmp = tempfile(fileext = ".xls")
url <- 'https://data.gov.ua/dataset/175386f8-fbce-4352-8ec9-44fc8c436aa9/resource/e58e005a-c448-4d97-9d45-813f05b1d737/download/nabir-2020-2022-roki.xls'
download.file(url = url, mode="wb", destfile = tmp)
d <- read_excel(tmp,1,col_names = TRUE)
d <- as.data.frame(d)
head(d, 6)

## Завдання 2
csvTmp <- tempfile()
csvurl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(csvurl, destfile = csvTmp)
csvFrame <- read.csv(csvTmp)
length(which(csvFrame$VAL == 24))


## Завдання 3
require(XML)
xmltmp <- tempfile()
xmlurl <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
download.file(xmlurl, xmltmp)
data <- xmlTreeParse(xmltmp, useInternalNodes = TRUE )
rootnode <- xmlRoot(data)
zipcode<-xpathSApply(rootnode,"//zipcode",xmlValue)
sum(zipcode == 21231)
