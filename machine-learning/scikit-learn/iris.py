import numpy as np
import matplotlib.pyplot as plt
from sklearn import datasets
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Perceptron
from sklearn.metrics import accuracy_score
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
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
# combine data and plot decision boundaries
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
# retrain with logistic regression
LOGREG = LogisticRegression(C=1000.0, random_state=0)
LOGREG.fit(TRAIN_STD, TARGET_TRAIN)
plot_decision_regions(TEST_COMBINED_STD,
                      TARGET_COMBINED,
                      classifier=LOGREG,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [standardized]')
plt.ylabel('petal width [standardized]')
plt.legend(loc='upper left')
plt.show()
# display prediction probabilities of first sample
print(LOGREG.predict_proba(TRAIN_STD[:3, :]))
# maximize decision boundary margin with support vector machine
SVM = SVC(kernel='linear', C=1.0, random_state=0)
SVM.fit(TRAIN_STD, TARGET_TRAIN)
plot_decision_regions(TEST_COMBINED_STD,
                      TARGET_COMBINED,
                      classifier=SVM,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [standardized]')
plt.ylabel('petal width [standardized]')
plt.legend(loc='upper left')
plt.show()
# example stochastic gradient descent initializations
# from sklearn.linear_model import SGDClassifier
# PERCEP = SGDCLassifier(loss='perceptron')
# LOGREG = SGDCLassifier(loss='log')
# SVM = SGDCLassifier(loss='hinge')
# create logical xor data
np.random.seed(0)
DATA_XOR = np.random.randn(200, 2)
TARGET_XOR = np.logical_xor(DATA_XOR[:, 0] > 0, DATA_XOR[:, 1] > 0)
TARGET_XOR = np.where(TARGET_XOR, 1, -1)
# higher dimension data projection to create gaussian kernelized svm hyperplane
SVM2 = SVC(kernel='rbf', random_state=0, gamma=0.10, C=10.0)
SVM2.fit(DATA_XOR, TARGET_XOR)
plot_decision_regions(DATA_XOR, TARGET_XOR, classifier=SVM2)
plt.legend(loc='upper left')
plt.show()
# apply this procedure to iris with reasonable gamma
SVM3 = SVC(kernel='rbf', random_state=0, gamma=0.2, C=10.0)
SVM3.fit(TRAIN_STD, TARGET_TRAIN)
plot_decision_regions(TEST_COMBINED_STD,
                      TARGET_COMBINED,
                      classifier=SVM3,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [standardized]')
plt.ylabel('petal width [standardized]')
plt.legend(loc='upper left')
plt.show()
# example of gamma that would greatly overfit data
SVM4 = SVC(kernel='rbf', random_state=0, gamma=100.0, C=10.0)
# retrain with a decision tree
TREE = DecisionTreeClassifier(criterion='entropy', max_depth=3, random_state=0)
TREE.fit(DATA_TRAIN, TARGET_TRAIN)
# display scatter plot results on decision boundaries
DATA_COMBINED = np.vstack((DATA_TRAIN, DATA_TEST))
TARGET_COMBINED = np.hstack((TARGET_TRAIN, TARGET_TEST))
plot_decision_regions(DATA_COMBINED,
                      TARGET_COMBINED,
                      classifier=TREE,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [cm]')
plt.ylabel('petal width [cm]')
plt.legend(loc='upper left')
plt.show()
# retrain with random forest ensemble
FRST = RandomForestClassifier(criterion='entropy',
                              n_estimators=10,
                              random_state=1,
                              n_jobs=2)
FRST.fit(DATA_TRAIN, TARGET_TRAIN)
# display scatter plot results on decision boundaries
plot_decision_regions(DATA_COMBINED,
                      TARGET_COMBINED,
                      classifier=FRST,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [cm]')
plt.ylabel('petal width [cm]')
plt.legend(loc='upper left')
plt.show()
# retrain with k nearest neighbors
KNN = KNeighborsClassifier(n_neighbors=5, p=2, metric='minkowski')
KNN.fit(TRAIN_STD, TARGET_TRAIN)
# display scatter plot results on decision boundaries
plot_decision_regions(TEST_COMBINED_STD,
                      TARGET_COMBINED,
                      classifier=KNN,
                      test_elem_id=range(105, 150))
plt.xlabel('petal length [standardized]')
plt.ylabel('petal width [standardized]')
plt.legend(loc='upper left')
plt.show()
