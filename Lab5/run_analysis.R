library(reshape2)

archiveName <- "data.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


## Завантаження та зчитування даних
# Завантаження
if(!file.exists(archiveName)){
  download.file(url,archiveName, mode = "wb") 
}

# Розархівування
if(!file.exists("UCI HAR Dataset")){
  unzip(archiveName, files = NULL, exdir=".")
}


# train data
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# test data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

feature <- read.table("UCI HAR Dataset/features.txt")
a_label <- read.table("UCI HAR Dataset/activity_labels.txt")

# 1. Об’єднує навчальний та тестовий набори, щоб створити один набір даних.
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

head(x_data)
head(y_data)
head(s_data)
# 2. Витягує лише вимірювання середнього значення та стандартного
# відхилення (mean and standard deviation) для кожного вимірювання.

selectedCols <- grep("-(mean|std).*", as.character(feature[,2]))
head(selectedCols)
# 3. Використовує описові назви діяльностей (activity) для найменування
# діяльностей у наборі даних.

# Отримання назв діяльностей
a_label[,2] <- as.character(a_label[,2])
head(a_label[,2])

#4. Відповідно присвоює змінним у наборі даних описові імена

selectedColNames <- feature[selectedCols, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

x_data <- x_data[selectedCols]
resDataSet <- cbind(s_data, y_data, x_data)
colnames(resDataSet) <- c("Subject", "Activity", selectedColNames)

resDataSet$Activity <- factor(resDataSet$Activity, levels = a_label[,1], labels = a_label[,2])
resDataSet$Subject <- as.factor(resDataSet$Subject)
head(resDataSet)
#5. З набору даних з кроку 4 створити другий незалежний акуратний набір
# даних (tidy dataset) із середнім значенням для кожної змінної для кожної
# діяльності та кожного суб’єкту (subject).
meltedData <- melt(resDataSet, id = c("Subject", "Activity"))
tidyData <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)
