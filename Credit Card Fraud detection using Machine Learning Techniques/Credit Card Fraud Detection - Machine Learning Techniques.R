# Final Project Step 3: Final Project Submission
# Name: Kalkar, Manish
# Date: 2020-08-06

library(ggplot2)
library(class)
library(pROC)
library(QuantPsyc)

## Set the working directory to the root of your DSC 520 directory
setwd("C:/Users/msupn/OneDrive/Documents/MS-DS/DSC520 - Statistics for Data Science/Github Repository/dsc520")

## Load the `data/creditcard.csv` to `creditcard_df`
creditcard_df <- read.csv("data/creditcard.csv")

## Data Exploration and check the need for cleaning the data

## Check Variable Names
names(creditcard_df)

## Check missing values in each variable
colMeans(is.na(creditcard_df))

## Display first 5 rows of the data set
head(creditcard_df,5)

## Data Exploration / Data Analysis

## Check fraudulent vs non-fraudulent transactions
table(creditcard_df$Class)

## Check % Fraudulent Transactions
TransactionCount <- as.numeric(table(creditcard_df$Class)) 
TransactionCount

percentTransactions <- TransactionCount / sum(TransactionCount)
percentTransactions

# Display summary of the data set
summary(creditcard_df)

summary(creditcard_df$Amount)

aggregate(creditcard_df$Amount, by=list(creditcard_df$Class), FUN=mean)

ggplot(creditcard_df, aes(x = Class)) + geom_bar() + ggtitle("Number of Non-fraudulent vs Fraudulent Transactions")
ggplot(creditcard_df, aes(x = Class, y = Amount)) + xlim("-0.5", "1.5") + geom_boxplot() + ggtitle("Distribution of Transaction Amount by Class")

## Data Split

set.seed(100)

# Split data set into train and test data set and separate out predictor from cl 
random_df <- sample(1:nrow(creditcard_df), 0.8 * nrow(creditcard_df))

# Train Data set
train_df <- creditcard_df[random_df,]

# Test Data set
test_df <- creditcard_df[-random_df,]


## 80/20 Split
table(train_df$Class)
table(test_df$Class)

dim(train_df)
dim(test_df)


## Data Model

## Logistic Regression

## Fit the logistic regression model to the data set that predicts the fraudulent transaction

creditcard_glm <- glm(Class ~ Time + V1 + V2 + V3 + V4 + V5 + V6 + V7 + V8 + V9 + V10 + 
                   V11 + V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + V21 + 
                   V22 + V23 + V24 + V25 + V26 + V27 + V28 + Amount, data = train_df, family = "binomial")

## Include a summary using the summary() function in your results
summary(creditcard_glm)

## Calculate Predicted Probability
creditcard_predicted_probability = predict(creditcard_glm, test_df, type = "response")

## Calculate and build the Confusion Matrix
confusion_matrix <- table(Actual_Value = test_df$Class, Predicted_Value = creditcard_predicted_probability > 0.5)

## Calculate the Accuracy of the model
accuracy = (confusion_matrix[[1,1]] + confusion_matrix[[2,2]])/sum(confusion_matrix) * 100
accuracy


## Visual representation - Plotting the Logistic Regression

## casewise diagnostics to identify outliers and/or influential cases
creditcard_DataFrame <- as.data.frame(resid(creditcard_glm))
creditcard_DataFrame$residuals <- resid(creditcard_glm)
creditcard_DataFrame$standardized.residuals <- rstandard(creditcard_glm)
creditcard_DataFrame$studentized.residuals <- rstudent(creditcard_glm)
creditcard_DataFrame$cooks.distance <- cooks.distance(creditcard_glm)
creditcard_DataFrame$dfbeta <- dfbeta(creditcard_glm)
creditcard_DataFrame$dffit <- dffits(creditcard_glm)
creditcard_DataFrame$leverage <- hatvalues(creditcard_glm)
creditcard_DataFrame$covariance.ratios <- covratio(creditcard_glm)

plot(dffits(creditcard_glm), resid(creditcard_glm), xlim=c(-40, 40), xlab = "Predicted (Fitted) Value", ylab = "Residual", main="Residual Vs Predicted (Fitted) Value")
qqplot(dffits(creditcard_glm), rstandard(creditcard_glm), xlim=c(-40, 40), xlab = "Predicted (Fitted) Value", ylab = "Standardized Residual", main="Standardized Residual Vs Predicted (Fitted) Value")
plot(dffits(creditcard_glm), rstandard(creditcard_glm), xlim=c(-40, 40), xlab = "Predicted (Fitted) Value", ylab = "Standardized Residual", main="Standardized Residual Vs Predicted (Fitted) Value")
plot(hatvalues(creditcard_glm), resid(creditcard_glm), xlim=c(-40, 40), xlab = "Leverage", ylab = "Residual", main="Residual Vs Leverage")


## Plot ROC Curve
creditcard_predict_ROC <- predict(creditcard_glm, test_df, probability = TRUE)
creditcard_auc_ROC = roc(test_df$Class, creditcard_predict_ROC, plot = TRUE, col = "blue")
creditcard_auc_ROC


## K Nearest Neighbor Algorithm

## Target data set
target_df<- creditcard_df[random_df,31]
target_test_df <- creditcard_df[-random_df,31]

# Build nearest neighbors model

# Let's build the nearest neighbor model based on k value = 1
prediction_model_k1 <- knn(train_df, test_df, cl= target_df, k = 1)

# confusion Matrix for k=1
knn_confusion_matrix_k1 <- table(prediction_model_k1, target_test_df)

## Calculate the Accuracy of the model for k=1
accuracy_k1 = (knn_confusion_matrix_k1[[1,1]])/sum(knn_confusion_matrix_k1) * 100
accuracy_k1





