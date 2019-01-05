library(keras)
library(neuralnet)

#Get data
data <- read.csv("C:/Users/D1/Desktop/ML/proof_thyroid/Simulated1.csv")

#Modify data
data <- as.matrix(data)

data[, 1:6] <- normalize(data[, 1:8])
data[, 7] <- as.numeric(data[, 9]) -1

#Set random seed
set.seed(7)

# Split data 70/30 for training/testing
ind <- sample(2, nrow(data), replace = T, prob = c(0.7, 0.3))
training <- data[ind==1, 1:8]
test <- data[ind==2, 1:8]
trainingtarget <- data[ind==1,9]
testtarget <- data[ind==2, 9]

#Create matrix of outcome variables
trainlabel <- to_categorical(trainingtarget)
testlabel <- to_categorical(testtarget)

# Model
model <- keras_model_sequential()

model %>%
  layer_dense(units = 50, activation = 'relu', input_shape = c(8)) %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 25, activation = 'relu') %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, activation = 'relu') %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 12, activation = 'softmax')

# Compile
model %>%
  compile(loss = 'categorical_crossentropy',
          optimizer = 'adam',
          metrics = 'accuracy')

# Fit Model
history <- model %>%
  fit(training, 
      trainlabel,
      epoch = 200,
      batch_size = 32,
      validation_split = 0.2)

#Plot loss, val_loss
plot(history)

#Evaluate model
model %>%
  evaluate(test,
           testlabel)

#Predictions
prob <- model %>%
  predict_proba(test)

pred <- model %>%
  predict_classes(test)

table(Predicted = pred, Actual = testtarget)

cbind(prob, pred, testtarget)
