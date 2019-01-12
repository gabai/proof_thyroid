# Title: Proof of concept for machine learning decision support models for healthcare
# Author: Gabriel Anaya MD, MAS

library(keras)
library(neuralnet)

# Get data
data <- read.csv("C:/Users/D1/Desktop/ML/proof_thyroid/Simulated1.csv")

# Modify data
data <- as.matrix(data)
# dimnames(data) <- NULL #Remove variable names
data[, 1:6] <- normalize(data[, 1:8]) # If these two sentences are lower they alter model a lot
data[, 7] <- as.numeric(data[, 9]) -1

# Set random seed
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
# Pending: save model to use on Shiny
# P: have multiple models and early stop, also with other activation functions
model <- keras_model_sequential()

model %>%
  layer_dense(units = 50, activation = 'relu', input_shape = c(8)) %>%
  layer_dropout(rate = 0.4) %>%
  layer_dense(units = 25, activation = 'relu') %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 10, activation = 'relu') %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 12, activation = 'softmax')

# summary(model) # Model Summary

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
#plot(history)
#plot(testtarget, pred)


#Evaluate model
# Apply reinforcement learning to compare models (Model-free RL, Q-learning)
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

# LIME


# Data Visualization
# Feature importance plot

# Partial dependency plots

# Bayesian network

# 

# Experimental:
# Hindsight Experience Replay (HER)
# DDPG + HER
# Q-learning + neural networks + self play (TD-Gammon)
