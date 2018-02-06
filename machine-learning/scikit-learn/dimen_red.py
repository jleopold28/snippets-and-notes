import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sklearn.model_selection as ms
import sklearn.preprocessing as preproc
import sklearn.linear_model as lm
import sklearn.decomposition as decomp
import sklearn.discriminant_analysis as da
import sklearn.datasets as ds
import kpca


# grab wine dataframe
DF_WINE = pd.read_csv('https://archive.ics.uci.edu/'
                      'ml/machine-learning-databases/wine/wine.data',
                      header=None)
# principal component analysis (pca)
# split into train and test sets
DATA, TARG = DF_WINE.iloc[:, 1:].values, DF_WINE.iloc[:, 0].values
DATA_TRAIN, DATA_TEST, TARG_TRAIN, TARG_TEST = ms.train_test_split(DATA, TARG, test_size=0.3, random_state=0)
# standardize the data
SCALE = preproc.StandardScaler()
DATA_TRAIN_STD = SCALE.fit_transform(DATA_TRAIN)
DATA_TEST_STD = SCALE.transform(DATA_TEST)
# construct covariance matrix
COVAR_MAT = np.cov(DATA_TRAIN_STD.T)
# calculate eigenvalues (magnitude of maximum variance)
# and eigenvectors (principal components/direction of max var)
EIG_VAL, EIG_VEC = np.linalg.eig(COVAR_MAT)
print("\nEigenvalues \n%s" % EIG_VAL)
# calculate variance explained ratio of eigenvalues
EIG_TOT = sum(EIG_VAL)
VAR_EXP = [(eig / EIG_TOT) for eig in sorted(EIG_VAL, reverse=True)]
CUM_VAR_EXP = np.cumsum(VAR_EXP)
# plot ratio versus component
plt.bar(range(1, 14), VAR_EXP, alpha=0.5,
        align='center', label='Individual explained variance')
plt.step(range(1, 14), CUM_VAR_EXP,
         where='mid', label='cumulative explained variance')
plt.ylabel('Explained variance ratio')
plt.xlabel('Principal components')
plt.legend(loc='best')
plt.show()
# sort the pairs of eigenvalues and eigenvectors to rank by variance
EIG_PAIR = [(np.abs(EIG_VAL[index]), EIG_VEC[:, index])
            for index in range(len(EIG_VAL))]
print(EIG_PAIR.sort(reverse=True))
# construct projection matrix from top two eigenvectors
PROJECT_MAT = np.hstack((EIG_PAIR[0][1][:, np.newaxis],
                         EIG_PAIR[1][1][:, np.newaxis]))
print("Projection Matrix W:\n", PROJECT_MAT)
# transform a sample 1x13 onto 1x2 via the 2x13 projection matrix
print(DATA_TRAIN_STD[0].dot(PROJECT_MAT))
# transform entire 124x13 training datset onto 124x2 principal components
DATA_TRAIN_PCA = DATA_TRAIN_STD.dot(PROJECT_MAT)
# plot the transformed dataset
COLORS = ['r', 'b', 'g']
MARKERS = ['s', 'x', 'o']
for label, color, marker in zip(np.unique(TARG_TRAIN), COLORS, MARKERS):
    plt.scatter(DATA_TRAIN_PCA[TARG_TRAIN == 1, 0],
                DATA_TRAIN_PCA[TARG_TRAIN == 1, 1],
                c=color, label=label, marker=marker)
plt.xlabel('PC 1')
plt.ylabel('PC 2')
plt.legend(loc='lower left')
plt.show()
# transform dataset via pca
PCA = decomp.PCA(n_components=2)
# classify transformed data via logistic regression
LOGREG = lm.LogisticRegression()
DATA_TRAIN_PCA = PCA.fit_transform(DATA_TRAIN_STD)
DATA_TEST_PCA = PCA.transform(DATA_TEST_STD)
LOGREG.fit(DATA_TRAIN_PCA, TARG_TRAIN)
# reinit pca with all eigens to find explained variance ratios
PCA2 = decomp.PCA(n_components=None)
DATA_TRAIN_PCA2 = PCA2.fit_transform(DATA_TRAIN_STD)
print(PCA2.explained_variance_ratio_)

# linear discriminant analysis (lda)
# compute mean vector for features wrt class
np.set_printoptions(precision=4)
MEAN_VECS = []
for label in range(1, 4):
    MEAN_VECS.append(np.mean(DATA_TRAIN_STD[TARG_TRAIN == label], axis=0))
    print("MV %s: %s\n" % (label, MEAN_VECS[label-1]))
# construct within-class scatter matrix by summing scatter matrix per class
SCATTER_W = np.zeros((13, 13))
for label, mean_vec in zip(range(1, 4), MEAN_VECS):
    CLASS_SCATTER = np.zeros((13, 13))
    mean_vec_trans = mean_vec.reshape(13, 1)
    for row in DATA_TRAIN[TARG_TRAIN == label]:
        CLASS_SCATTER += (row.reshape(13, 1) - mean_vec_trans)
    SCATTER_W += CLASS_SCATTER
print("Within-class scatter matrix: %sx%s" % (SCATTER_W.shape[0],
                                              SCATTER_W.shape[1]))
# however, the class labels are not uniformly distributed
print("Class label distribution: %s" % np.bincount(TARG_TRAIN)[1:])
# so compute the normalized scatter matrix aka covariance matrix
SCATTER_W = np.zeros((13, 13))
for label, mean_vec in zip(range(1, 4), MEAN_VECS):
    CLASS_SCATTER = np.cov(DATA_TRAIN_STD[TARG_TRAIN == label].T)
    SCATTER_W += CLASS_SCATTER
print("Scaled within-class scatter matrix: %sx%s" % (SCATTER_W.shape[0],
                                                     SCATTER_W.shape[1]))
# construct between-class scatter matrix
SCATTER_B = np.zeros(13, 13)
MEAN_OVERALL = np.mean(DATA_TRAIN_STD, axis=0).reshape(13, 1)
for index, mean_vec in enumerate(MEAN_VECS):
    n = DATA_TRAIN[TARG_TRAIN == index + 1, :].shape[0]
    mean_vec = mean_vec.reshape(13, 1)
    SCATTER_B += n * (mean_vec - MEAN_OVERALL).dot((mean_vec - MEAN_OVERALL).T)
print("Between-class scatter matrix: %sx%s" % (SCATTER_B.shape[0],
                                               SCATTER_B.shape[1]))
# computer eigenvalues and eigenvectors of combined matrices
EIG_VALS, EIG_VECS = np.linalg.eig(np.linalg.inv(SCATTER_W).dot(SCATTER_B))
# choose eigenvectors corresponding to largest eigenvalues
EIG_PAIRS = [(np.abs(EIG_VALS[index]), EIG_VECS[:, index])
             for index in range(len(EIG_VALS))]
SORTED_EIG_PAIRS = sorted(EIG_PAIRS, key=lambda k: k[0], reverse=True)
print("Eigenvalues in decreasing order:\n")
for val in EIG_PAIRS:
    print(val[0])
# construct transformation matrix where the eigenvectors are the columns
TRANSF_MAT = np.hstack((EIG_PAIRS[0][1][:, np.newaxis].real,
                        EIG_PAIRS[1][1][:, np.newaxis].real))
print("Matrix W:\n", TRANSF_MAT)
# project samples onto new feature subspace
DATA_TRAIN_LDA = DATA_TRAIN_STD.dot(TRANSF_MAT)
COLORS = ['r', 'b', 'g']
MARKERS = ['s', 'x', 'o']
for label, color, marker in zip(np.unique(TARG_TRAIN), COLORS, MARKERS):
    plt.scatter(DATA_TRAIN_LDA[TARG_TRAIN == 1, 0] * (-1),
                DATA_TRAIN_LDA[TARG_TRAIN == 1, 1] * (-1),
                c=color, label=label, marker=marker)
plt.xlabel('LD 1')
plt.ylabel('LD 2')
plt.legend(loc='lower right')
plt.show()
# use lda directly
LDA = da.LinearDiscriminantAnalysis(n_components=2)
DATA_TRAIN_LDA = LDA.fit_transform(DATA_TRAIN_STD, TARG_TRAIN)
# classify transformed data via logistic regression
LOGREG = lm.LogisticRegression()
LOGREG.fit(DATA_TRAIN_LDA, TARG_TRAIN)
DATA_TRAIN_LDA = LDA.transform(DATA_TRAIN_STD)

# kernel principal component analysis
# create nonlinear dataset and plot
DATA, TARG = ds.make_moons(n_samples=100, random_state=123)
plt.scatter(DATA[TARG == 0, 0], DATA[TARG == 0, 1],
            color='red', marker='^', alpha=0.5)
plt.scatter(DATA[TARG == 1, 0], DATA[TARG == 1, 1],
            color='blue', marker='o', alpha=0.5)
plt.show()
# fit with rbf kpca
DATA_KPCA, EIG_VALS = kpca.rbf_kernel_pca(DATA, gamma=15, n_components=2)
# create another nonlinear dataset and plot
DATA, TARG = ds.make_circles(n_samples=1000, random_state=123,
                             noise=0.1, factor=0.2)
plt.scatter(DATA[TARG == 0, 0], DATA[TARG == 0, 1],
            color='red', marker='^', alpha=0.5)
plt.scatter(DATA[TARG == 1, 0], DATA[TARG == 1, 1],
            color='blue', marker='o', alpha=0.5)
plt.show()
# fit with rbf kpca
DATA_KPCA, EIG_VALS = kpca.rbf_kernel_pca(DATA, gamma=15, n_components=2)
# pick arbitrary data point and project it
DATA_POINT = DATA[25]
print(DATA_POINT)
POINT_PROJECT = DATA_KPCA[25]
print(POINT_PROJECT)
POINT_REPROJ = kpca.project_data(DATA_POINT, DATA, gamma=15,
                                 alphas=DATA_KPCA, lambdas=EIG_VALS)
print(POINT_REPROJ)
# use kpca directly
SCIKIT_KPCA = decomp.KernelPCA(n_components=2, kernel='rbf', gamma=15)
DATA_SKERNELPCA = SCIKIT_KPCA.fit_transform(DATA)
