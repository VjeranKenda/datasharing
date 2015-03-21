## run_analysis.R

library(dplyr)
library(data.table)

## get data from raw source

## test - subject
file_name <- ".//UCI HAR Dataset//test//subject_test.txt"
data_test_s <- read.table(file_name)
names(data_test_s)[1] <- "Subject"

## test - y - activity
file_name <- ".//UCI HAR Dataset//test//y_test.txt"
data_test_a <- read.table(file_name)
names(data_test_a)[1] <- "Activity"

## test - data
file_name <- ".//UCI HAR Dataset//test//X_test.txt"
data_test_d <- read.table(file_name)

data_test <- bind_cols(data_test_s, data_test_a, data_test_d)

## train - subject
file_name <- ".//UCI HAR Dataset//train//subject_train.txt"
data_train_s <- read.table(file_name)
names(data_train_s)[1] <- "Subject"

## train - y - activity
file_name <- ".//UCI HAR Dataset//train//y_train.txt"
data_train_a <- read.table(file_name)
names(data_train_a)[1] <- "Activity"

## train - data
file_name <- ".//UCI HAR Dataset//train//X_train.txt"
data_train_d <- read.table(file_name)

data_train <- bind_cols(data_train_s, data_train_a, data_train_d)

data_all <- bind_rows(data_test, data_train)

## get column names
file_name <- ".//UCI HAR Dataset//features.txt"
feature <- read.table(file_name, stringsAsFactors = FALSE)

names(feature)[1] <- "col_id"
names(feature)[2] <- "col_name"

## apply column names
for (i in feature$col_id) {
        ## exclude "bandsEnergy" because of duplication
    if (!(feature$col_name[i] %like% "bandsEnergy")) {
        names(data_all)[i+2] <- feature$col_name[i]
    }
}

## new data with only needed columns
needed_columns <- c(1, 2,
    filter(feature, col_name %like% "std" | col_name %like% "mean")$col_id+2
    )
data <- select(data_all, needed_columns)

## the average of each variable for each activity and each subject
grp_data <- group_by(data, Activity, Subject)
agg_grp_data <- summarise_each(grp_data, funs(mean))

write.table(agg_grp_data, "tidy_data_set.txt", row.name=FALSE)
