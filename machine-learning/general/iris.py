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
TRAIN_MATRIX = DATAFRAME.iloc[0:100, [0, 2]].values
# setup and display scatter plot
plt.scatter(TRAIN_MATRIX[:50, 0], TRAIN_MATRIX[:50, 1],
            color='red', marker='o', label='setosa')
plt.scatter(TRAIN_MATRIX[50:100, 0], TRAIN_MATRIX[50:100, 1],
            color='blue', marker='x', label='versicolor')
plt.xlabel('sepal length')
plt.ylabel('petal length')
plt.legend(loc='upper left')
plt.show()
# train
PERCEP = Perceptron(eta=0.1, n_iter=10)
PERCEP.fit(TRAIN_MATRIX, TARGET_VEC)
# setup and display number of errors for each epoch
plt.plot(range(1, len(PERCEP.errors) + 1), PERCEP.errors, marker='o')
plt.xlabel('Epochs')
plt.ylabel('Number of misclassifications')
plt.show()
# plot decision regions for this classification
plot_decision_regions(TRAIN_MATRIX, TARGET_VEC, classifier=PERCEP)
plt.xlabel('sepal length [cm]')
plt.ylabel('petal length [cm]')
plt.legend(loc='upper left')
plt.show()
