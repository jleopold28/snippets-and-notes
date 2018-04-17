import pandas as pd
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import sklearn.preprocessing as preproc
import sklearn.model_selection as ms
import sklearn.decomposition as decomp
import sklearn.linear_model as lm
import sklearn.pipeline as pl
import sklearn.svm as svm
import sklearn.tree as tree
import sklearn.metrics as met


# import breast cancer wisconsin dataset
df = pd.read_csv('https://archive.ics.uci.edu/ml/machine-learning-databases/'
                 'breast-cancer-wisconsin/wdbc.data',
                 header=None)
# transform class labels from strings into integers
FEAT = df.loc[:, 2:].values
LABEL = df.loc[:, 1].values
LABEL_ENCODER = preproc.LabelEncoder()
LABEL = LABEL_ENCODER.fit_transform(LABEL)
# split into 0.8 training and 0.2 test
FEAT_TRAIN, FEAT_TEST, LABEL_TRAIN, LABEL_TEST = ms.train_test_split(FEAT,
                                                                     LABEL,
                                                                     test_size=0.20,
                                                                     random_state=1)
# chain transformation and fitting steps
PIPE_LR = pl.Pipeline([('scl', preproc.StandardScaler()),
                       ('pca', decomp.PCA(n_components=2)),
                       ('clf', lm.LogisticRegression(random_state=1))])
PIPE_LR.fit(FEAT_TRAIN, LABEL_TRAIN)
print('Test Accuracy: %.3f' % PIPE_LR.score(FEAT_TEST, LABEL_TEST))
# assess model performance: holdout and k-fold cross validation methods
# holdout method: first separate data into training (fit), validation (model selection/tune hyperparameters), and test
# k-fold: perform holdout k times on k subsets of the data
KFOLD = ms.StratifiedKFold(n_splits=10,
                           random_state=1).split(FEAT_TRAIN, LABEL_TRAIN)
scores = []
for k, (train, test) in enumerate(KFOLD):
    PIPE_LR.fit(FEAT_TRAIN[train], LABEL_TRAIN[train])
    score = PIPE_LR.score(FEAT_TRAIN[test], LABEL_TRAIN[test])
    scores.append(score)
    print('Fold: %s, Class dist.: %s, Acc: %.3f' % (k + 1,
                                                    np.bincount(LABEL_TRAIN[train]),
                                                    score))
print('CV accuracy: %.3f +/- %.3f' % (np.mean(scores), np.std(scores)))
# use intrinsic scorer
scores = ms.cross_val_score(estimator=PIPE_LR,
                            X=FEAT_TRAIN,
                            y=LABEL_TRAIN,
                            cv=10,
                            n_jobs=1)
print('CV accuracy scores: %s' % scores)
print('CV accuracy: %.3f +/- %.3f' % (np.mean(scores), np.std(scores)))
# diagnose bias and variance problems with learning curves
PIPE_LR = pl.Pipeline([('scl', preproc.StandardScaler()),
                       ('clf', lm.LogisticRegression(penalty='l2',
                                                     random_state=0))])
train_sizes, train_scores, test_scores = ms.learning_curve(estimator=PIPE_LR,
                                                           X=FEAT_TRAIN,
                                                           y=LABEL_TRAIN,
                                                           train_sizes=np.linspace(0.1, 1.0, 10),
                                                           cv=10,
                                                           n_jobs=1)
train_mean = np.mean(train_scores, axis=1)
train_std = np.std(train_scores, axis=1)
test_mean = np.mean(test_scores, axis=1)
test_std = np.std(test_scores, axis=1)
# display learning curves
plt.plot(train_sizes, train_mean, color='blue', marker='o', markersize=5,
         label='training accuracy')
plt.fill_between(train_sizes, train_mean + train_std, train_mean - train_std,
                 alpha=0.15, color='blue')
plt.plot(train_sizes, test_mean, color='green', linestyle='--', marker='s',
         markersize=5, label='validation accuracy')
plt.fill_between(train_sizes, test_mean + test_std, test_mean - test_std,
                 alpha=0.15, color='green')
plt.grid()
plt.xlabel('Number of training samples')
plt.ylabel('Accuracy')
plt.legend(loc='lower right')
plt.ylim([0.9, 1.0])
plt.show()  # evidence of slight overfit due to gap between curves
# create validation curves for C (the inverse regularization param of logreg)
param_range = [0.001, 0.01, 0.1, 1.0, 10.0, 100.0]
train_scores, test_scores = ms.validation_curve(estimator=PIPE_LR,
                                                X=FEAT_TRAIN,
                                                y=LABEL_TRAIN,
                                                param_name='clf__C',
                                                param_range=param_range,
                                                cv=10)
train_mean = np.mean(train_scores, axis=1)
train_std = np.std(train_scores, axis=1)
test_mean = np.mean(test_scores, axis=1)
test_std = np.std(test_scores, axis=1)
# plot validation curves
plt.plot(param_range, train_mean, color='blue', marker='o', markersize=5,
         label='training accuracy')
plt.fill_between(param_range, test_mean + train_std, train_mean - train_std,
                 alpha=0.15, color='blue')
plt.plot(param_range, test_mean, color='green', linestyle='--', marker='s',
         markersize=5, label='validation accuracy')
plt.fill_between(param_range, test_mean + test_std, test_mean - test_std,
                 alpha=0.15, color='green')
plt.grid()
plt.xscale('log')
plt.legend(loc='lower right')
plt.xlabel('Parameter C')
plt.ylabel('Accuracy')
plt.ylim([0.9, 1.0])
plt.show()
# sweet spot appears to be 0.1
# use grid search to find the optimal combination of hyperparameter values
PIPE_SVC = pl.Pipeline([('scl', preproc.StandardScaler()),
                        ('svc', svm.SVC(random_state=1))])
param_range = [0.0001, 0.001, 0.01, 0.1, 1.0, 10.0, 100.0, 1000.0]
param_grid = [{'svc__C': param_range,
               'svc__kernel': ['linear']},
              {'svc__C': param_range,
               'svc__gamma': param_range,
               'svc__kernel': ['rbf']}]
grid_search = ms.GridSearchCV(estimator=PIPE_SVC,
                              param_grid=param_grid,
                              scoring='accuracy',
                              cv=10,
                              n_jobs=-1)
grid_search = grid_search.fit(FEAT_TRAIN, LABEL_TRAIN)
print('Grid Search Best Score: %.6f' % grid_search.best_score_)
print('Grid Search Best Params:')
print(grid_search.best_params_)
# set hyperparamter to best value and then fit
clf = grid_search.best_estimator_
clf.fit(FEAT_TRAIN, LABEL_TRAIN)
print('Test accuracy: %.3f' % clf.score(FEAT_TRAIN, LABEL_TRAIN))
# use nested cross-validation to select between training algorithms
# first svm with 5 outer 2 inner loops
grid_search = ms.GridSearchCV(estimator=PIPE_SVC,
                              param_grid=param_grid,
                              scoring='accuracy',
                              cv=2,
                              n_jobs=-1)
scores = ms.cross_val_score(grid_search, FEAT_TRAIN, LABEL_TRAIN,
                            scoring='accuracy', cv=5)
print('CV accuracy: %.3f +/- %.3f' % (np.mean(scores), np.std(scores)))
# second decision tree with 2 outer 5 inner loops
grid_search = ms.GridSearchCV(estimator=tree.DecisionTreeClassifier(random_state=0),
                              param_grid=[{'max_depth': [1, 2, 3, 4, 5, 6, 7, None]}],
                              scoring='accuracy',
                              cv=5)
scores = ms.cross_val_score(grid_search, FEAT_TRAIN, LABEL_TRAIN,
                            scoring='accuracy', cv=2)
print('CV accuracy: %.3f +/- %.3f' % (np.mean(scores), np.std(scores)))
# using other performance evaluation metrics
# create confusion matrix
PIPE_SVC.fit(FEAT_TRAIN, LABEL_TRAIN)
label_pred = PIPE_SVC.predict(FEAT_TEST)
conf_mat = met.confusion_matrix(y_true=LABEL_TEST, y_pred=label_pred)
print(conf_mat)
# convert array representation into matrix visual
figure, axis = plt.subplots(figsize=(2.5, 2.5))
axis.matshow(conf_mat, cmap=plt.cm.Blues, alpha=0.3)
for i in range(conf_mat.shape[0]):
    for j in range(conf_mat.shape[1]):
        axis.text(x=j, y=i, s=conf_mat[i, j], va='center', ha='center')
plt.xlabel('predicted label')
plt.ylabel('true label')
plt.show()
# calculate precision, recall, and f1
print('Precision: %.3f' % met.precision_score(y_true=LABEL_TEST,
                                              y_pred=label_pred))
print('Recall: %.3f' % met.recall_score(y_true=LABEL_TEST,
                                        y_pred=label_pred))
print('F1: %.3f' % met.precision_score(y_true=LABEL_TEST,
                                       y_pred=label_pred))
# use f1 score for gridsearch evaluation metric (positive label 0)
scorer = met.make_scorer(met.f1_score, pos_label=0)
grid_search = ms.GridSearchCV(estimator=PIPE_SVC,
                              param_grid=param_grid,
                              scoring=scorer,
                              cv=10)
# plot receiver operating characteristic
# this measures true positive and false positive rates
# purposefully challenge the classifier for educational purposes
# also measure area under curve of roc curve
pipe_lr = pl.Pipeline([('scl', preproc.StandardScaler()),
                       ('pca', decomp.PCA(n_components=2)),
                       ('clf', lm.LogisticRegression(penalty='l2',
                                                     random_state=0,
                                                     C=100.0))])
feat_train = FEAT_TRAIN[:, [4, 14]]
cross_val = list(ms.StratifiedKFold(n_splits=3,
                                    random_state=1).split(feat_train, LABEL_TRAIN))
figure = plt.figure(figsize=(7, 5))
mean_tpr = 0.0
mean_fpr = np.linspace(0, 1, 100)
all_tpr = []
for i, (train, test) in enumerate(cross_val):
    probs = pipe_lr.fit(feat_train[train],
                        LABEL_TRAIN[train]).predict_proba(feat_train[test])
    fpr, tpr, thresholds = met.roc_curve(LABEL_TRAIN[test],
                                         probs[:, 1],
                                         pos_label=1)
    mean_tpr += sp.interp(mean_fpr, fpr, tpr)
    mean_tpr[0] = 0.0
    roc_auc = met.auc(fpr, tpr)
    plt.plot(fpr, tpr, lw=1, label='ROC Fold %d (area = %0.2f)' % (i + 1, roc_auc))
plt.plot([0, 1],
         [0, 1],
         linestyle='--',
         color=(0.6, 0.6, 0.6),
         label='random guessing')
mean_tpr /= len(cross_val)
mean_tpr[-1] = 1.0
mean_auc = met.auc(mean_fpr, mean_tpr)
# plot roc curve and visualize auc
plt.plot(mean_fpr, mean_tpr, 'k--',
         label='mean ROC (area = %0.2f)' % mean_auc, lw=2)
plt.plot([0, 0, 1],
         [0, 1, 1],
         linestyle=':',
         color='black',
         label='perfect performance')
plt.xlim([-0.05, 1.05])
plt.ylim([-0.05, 1.05])
plt.xlabel('false positive rate')
plt.ylabel('true positive rate')
plt.legend(loc="lower right")
plt.tight_layout()
plt.show()
# calculate auc on test dataset after fitting
# this gives a metric of true positive versus false positive
pipe_lr = pipe_lr.fit(feat_train, LABEL_TRAIN)
label_pred = pipe_lr.predict(FEAT_TEST[:, [4, 14]])
print('ROC AUC: %.3f' % met.roc_auc_score(y_true=LABEL_TEST,
                                          y_score=label_pred))

print('Accuracy: %.3f' % met.accuracy_score(y_true=LABEL_TEST,
                                            y_pred=label_pred))
# determine micro average for multiclass one-vs-all classification
pre_scorer = met.make_scorer(score_func=met.precision_score,
                             pos_label=1,
                             greater_is_better=True,
                             average='micro')
