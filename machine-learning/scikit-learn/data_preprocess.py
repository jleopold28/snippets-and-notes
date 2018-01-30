from io import StringIO
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sklearn.preprocessing as preproc
import sklearn.cross_validation as cv
import sklearn.linear_model as lm
import sklearn.neighbors as nb
import sklearn.ensemble as ens
import sklearn.feature_selection as fs


# create and store dataframe
CSV_DATA = '''A,B,C,D
1.0,2.0,3.0,4.0
5.0,6.0,,8.0
10.0,11.0,12.0,'''
DATAFRAME = pd.read_csv(StringIO(CSV_DATA))
print(DATAFRAME)
# check for missing values per column
print(DATAFRAME.isnull().sum())
# remove rows with missing values
print(DATAFRAME.dropna())
# remove columns with missing values
print(DATAFRAME.dropna(axis=1))
# drop rows where are all columns have NaN
print(DATAFRAME.dropna(how='all'))
# keep rows that have have at least four non-NaN
print(DATAFRAME.dropna(thresh=4))
# drop rows where NaN appears in a specific column ('C')
print(DATAFRAME.dropna(subset=['C']))

# use mean imputer to estimate missing data (also median or most_frequent)
IMPUTER_FIT = preproc.Imputer(missing_values='NaN',
                              strategy='mean',
                              axis=0).fit(DATAFRAME)
IMPUTED_DATA = IMPUTER_FIT.transform(DATAFRAME.values)
print(IMPUTED_DATA)

# create and store new dataframe
DATAFRAME = pd.DataFrame([
    ['green', 'M', 10.1, 'class1'],
    ['red', 'L', 13.5, 'class2'],
    ['blue', 'XL', 15.3, 'class1']])
DATAFRAME.columns = ['color', 'size', 'price', 'classlabel']
print(DATAFRAME)
# map ordinal sizes onto ints
SIZE_MAP = {'M': 1, 'L': 2, 'XL': 3}
DATAFRAME['size'] = DATAFRAME['size'].map(SIZE_MAP)
print(DATAFRAME)
# map class labels to ints
CLASS_MAP = {label: elem_id for elem_id, label in
             enumerate(np.unique(DATAFRAME['classlabel']))}
print(CLASS_MAP)
DATAFRAME['classlabel'] = DATAFRAME['classlabel'].map(CLASS_MAP)
print(DATAFRAME)
# setup class labelencoder from sklearn
CLASS_LE = preproc.LabelEncoder()
CLASS_MAP = CLASS_LE.fit_transform(DATAFRAME['classlabel'].values)
print(CLASS_MAP)
# inverse map back to labels
print(CLASS_LE.inverse_transform(CLASS_MAP))
# use onehotencoder to transform colors into non-ordinal mapping
DATA = DATAFRAME[['color', 'size', 'price']].values
DATA[:, 0] = preproc.LabelEncoder().fit_transform(DATA[:, 0])
OHE = preproc.OneHotEncoder(categorical_features=[0])
print(OHE.fit_transform(DATA).toarray())
# or use dummies from pandas
print(pd.get_dummies(DATAFRAME[['price', 'color', 'size']]))

# gather in wine data
DF_WINE = pd.read_csv('https://archive.ics.uci.edu/'
                      'ml/machine-learning-databases/wine/wine.data',
                      header=None)
DF_WINE.columns = ['Class label', 'Alcohol', 'Malic acid', 'Ash',
                   'Alcalinity of ash', 'Magnesium', 'Total phenols',
                   'Flavanoids', 'Nonflavanoid phenols', 'Proanthocyanins',
                   'Color intensity', 'Hue', 'OD280/OD315 of diluted wines',
                   'Proline']
print('Class labels', np.unique(DF_WINE['Class label']))
DF_WINE.head()
# use cross validate to split into train and test
DATA, TARGET = DF_WINE.iloc[:, 1:].values, DF_WINE.iloc[:, 0].values
DATA_TRAIN, DATA_TEST, TARGET_TRAIN, TARGET_TEST = cv.train_test_split(DATA, TARGET, test_size=0.3, random_state=0)
# normalize the data
MMS = preproc.MinMaxScaler()
DATA_TRAIN_NORM = MMS.fit_transform(DATA_TRAIN)
DATA_TEST_NORM = MMS.transform(DATA_TEST)
# standardize the data
STDSC = preproc.StandardScaler()
DATA_TRAIN_STD = STDSC.fit_transform(DATA_TRAIN)
DATA_TEST_STD = STDSC.transform(DATA_TEST)
# execute l1 regularization on the data and yield a sparse solution
# 'C' is inverse of regularization parameter 'lambda'
# feature weights go to zero as 'C' goes to zero (strong regularization param)
LOGREG = lm.LogisticRegression(penalty='l1', C=0.1)
LOGREG.fit(DATA_TRAIN_STD, TARGET_TRAIN)
print('Training accuracy:', LOGREG.score(DATA_TRAIN_STD, TARGET_TRAIN))
print('Test accuracy:', LOGREG.score(DATA_TEST_STD, TARGET_TEST))
# intercept elems: model 1 vs 2 and 3, model 1 and 3, model 3 vs 1 and 2
print(LOGREG.intercept_)
# three rows of weight coef (one vector per class) containing thirteen weights
print(LOGREG.coef_)
# using a theoretical selective backward selection
KNN = nb.KNeighborsClassifier(n_neighbors=2)
# SBS = SBS(KNN, k_features=1)
# SBS.fit(DATA_TRAIN_STD, TARGET_TRAIN)
# knn fit on total training data
KNN.fit(DATA_TRAIN_STD, TARGET_TRAIN)
print('Training accuracy:', KNN.score(DATA_TRAIN_STD, TARGET_TRAIN))
print('Test accuracy:', KNN.score(DATA_TEST_STD, TARGET_TEST))
# assess feature importance with random forest
FEAT_LABELS = DF_WINE.columns[1:]
FRST = ens.RandomForestClassifier(n_estimators=10000,
                                  random_state=0,
                                  n_jobs=-1)
FRST.fit(DATA_TRAIN, TARGET_TRAIN)
IMPORTANCES = FRST.feature_importances_
INDICES = np.argsort(IMPORTANCES)[::-1]
for index in range(DATA_TRAIN.shape[1]):
    print("%2d) %-*s %f" % (index + 1,
                            30,
                            FEAT_LABELS[INDICES[index]],
                            IMPORTANCES[INDICES[index]]))
# plot bar graph of feature importances (normalized to sum to 1.0)
plt.title('Feature Importances')
plt.bar(range(DATA_TRAIN.shape[1]),
        IMPORTANCES[INDICES],
        color='lightblue',
        align='center')
plt.xticks(range(DATA_TRAIN.shape[1]),
           FEAT_LABELS[INDICES],
           ROTATION=90)
plt.xlim([-1, DATA_TRAIN.shape[1]])
plt.tight_layout()
plt.show()
# example on using transform to reduce dataset to features above 0.15
DATA_SELECT = fs.SelectFromModel(FRST,
                                 threshold=0.1,
                                 prefit=True).transform(DATA_TRAIN)
print(DATA_SELECT.shape)
