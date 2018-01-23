import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
from simple_perceptron import Perceptron
from decision_boundaries import plot_decision_regions
from simple_adaline import AdalineGD

# setup data set
DATAFRAME = pd.read_csv('https://archive.ics.uci.edu/ml/'
                        'machine-learning-databases/iris/iris.data',
                        header=None)
DATAFRAME.tail()

# setup target vec
TARGET_VEC = DATAFRAME.iloc[0:100, 4].values
TARGET_VEC = np.where(TARGET_VEC == 'Iris-setosa', -1, 1)
# setup train matrix
TRAIN_MAT = DATAFRAME.iloc[0:100, [0, 2]].values
# setup and display scatter plot
plt.scatter(TRAIN_MAT[:50, 0], TRAIN_MAT[:50, 1],
            color='red', marker='o', label='setosa')
plt.scatter(TRAIN_MAT[50:100, 0], TRAIN_MAT[50:100, 1],
            color='blue', marker='x', label='versicolor')
plt.xlabel('sepal length')
plt.ylabel('petal length')
plt.legend(loc='upper left')
plt.show()
# train
PERCEP = Perceptron(eta=0.1, n_iter=10)
PERCEP.fit(TRAIN_MAT, TARGET_VEC)
# setup and display number of errors for each epoch
plt.plot(range(1, len(PERCEP.errors) + 1), PERCEP.errors, marker='o')
plt.xlabel('Epochs')
plt.ylabel('Number of misclassifications')
plt.show()
# plot decision regions for this classification
plot_decision_regions(TRAIN_MAT, TARGET_VEC, classifier=PERCEP)
plt.xlabel('sepal length [cm]')
plt.ylabel('petal length [cm]')
plt.legend(loc='upper left')
plt.show()
# setup and display scatter plot for adaline with eta 0.01
_, SUBPLOTS = plt.subplots(nrows=1, ncols=2, figsize=(8, 4))
ADA1 = AdalineGD(n_iter=10, eta=0.01).fit(TRAIN_MAT, TARGET_VEC)
SUBPLOTS[0].plot(range(1, len(ADA1.cost) + 1), np.log10(ADA1.cost), marker='o')
SUBPLOTS[0].set_xlabel('Epochs')
SUBPLOTS[0].set_ylabel('log(Sum-squared-error)')
SUBPLOTS[0].set_title('Adaline - Learning rate 0.01')
# setup and display scatter plot for adaline with eta 0.0001
ADA2 = AdalineGD(n_iter=10, eta=0.0001).fit(TRAIN_MAT, TARGET_VEC)
SUBPLOTS[1].plot(range(1, len(ADA2.cost) + 1), np.log10(ADA2.cost), marker='o')
SUBPLOTS[1].set_xlabel('Epochs')
SUBPLOTS[1].set_ylabel('log(Sum-squared-error)')
SUBPLOTS[1].set_title('Adaline - Learning rate 0.0001')
plt.show()
# implement standardization to transform data into pseudo-normal dist
TRAIN_STD = np.copy(TRAIN_MAT)
TRAIN_STD[:, 0] = (TRAIN_MAT[:, 0] - TRAIN_MAT[:, 0].mean()) / TRAIN_MAT[:, 0].std()
TRAIN_STD[:, 1] = (TRAIN_MAT[:, 1] - TRAIN_MAT[:, 1].mean()) / TRAIN_MAT[:, 1].std()
# retrain adaline with eta 0.01 and standardization so it converges
ADA3 = AdalineGD(n_iter=15, eta=0.01)
ADA3.fit(TRAIN_STD, TARGET_VEC)
# setup and display scatter plot for retrain decision boundaries
plot_decision_regions(TRAIN_STD, TARGET_VEC, classifier=ADA3)
plt.title('Adaline - Gradient Descent')
plt.xlabel('sepal length (standardized)')
plt.ylabel('petal length (standardized)')
plt.legend(loc='upper left')
plt.show()
# setup and display scatter plot for retrain error
plt.plot(range(1, len(ADA3.cost) + 1), ADA3.cost, marker='o')
plt.xlabel('Epochs')
plt.ylabel('Sum-squared-error')
plt.show()
# retrain adaline with stochastic gradient descent (not batch)
ADA4 = AdalineGD(n_iter=15, eta=0.01, rdm_state=1, stochastic=True)
ADA4.fit(TRAIN_STD, TARGET_VEC)
plot_decision_regions(TRAIN_STD, TARGET_VEC, classifier=ADA4)
plt.title('Adaline - Gradient Descent')
plt.xlabel('sepal length (standardized)')
plt.ylabel('petal length (standardized)')
plt.legend(loc='upper left')
plt.show()
# setup and display scatter plot for retrain error
plt.plot(range(1, len(ADA4.cost) + 1), ADA4.cost, marker='o')
plt.xlabel('Epochs')
plt.ylabel('Sum-squared-error')
plt.show()
# model update on individual samples (e.g. online learning)
# ADA4.partial_fit(TRAIN_STD[0, :], TARGET_VEC[0])
