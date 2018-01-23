import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Perceptron
from sklearn.metrics import accuracy_score
from decision_boundaries import plot_decision_regions


# setup iris data
IRIS = datasets.load_iris()
DATA_VEC = IRIS.data[:, [2, 3]]
TARGET_VEC = IRIS.target
# split into train and test
DATA_TRAIN, DATA_TEST, TARGET_TRAIN, TARGET_TEST = train_test_split(DATA_VEC, TARGET_VEC, test_size=0.3, random_state=0, stratify=TARGET_VEC)
# preprocess data
SCALE = StandardScaler()
SCALE.fit(DATA_TRAIN)
TRAIN_STD = SCALE.transform(DATA_TRAIN)
TEST_STD = SCALE.transform(DATA_TEST)
# use perceptron to train on data
PERCEP = Perceptron(max_iter=40, eta0=0.1, random_state=0)
PERCEP.fit(TRAIN_STD, TARGET_TRAIN)
# make predictions and output accuracy benchmarks
TARGET_PRED = PERCEP.predict(TEST_STD)
print('Misclassified samples: %d' % (TARGET_TEST != TARGET_PRED).sum())
print('Accuracy: %.2f' % accuracy_score(TARGET_TEST, TARGET_PRED))
#
TEST_COMBINED_STD = np.vstack((TRAIN_STD, TEST_STD))
TARGET_COMBINED = np.hstack((TARGET_TRAIN, TARGET_TEST))
plot_decision_regions(train_vec=TEST_COMBINED_STD,
                      target_vec=TARGET_COMBINED,
                      classifier=PERCEP,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [standardized]')
plt.ylabel('petal width [standardized]')
plt.legend(loc='upper left')
plt.show()
