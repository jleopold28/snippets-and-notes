import re
import numpy as np
import pandas as pd
import sklearn.feature_extraction.text as text
import sklearn.model_selection as ms
import sklearn.pipeline as pl
import sklearn.linear_model as lm
import nltk
import nltk.stem.porter as port

# init
df = pd.read_csv('./movie_data.csv')
# construct bag of words model (sparse feature vectors of documents)
# use 1-gram model (one word per item/token)
count = text.CountVectorizer()
DOCS = np.array(['The sun is shining',
                 'The weather is sweet',
                 'The sun is shining and the weather is sweet'])
bag = count.fit_transform(DOCS)
# print vocab contents and feature vectors (aka raw term frequencies)
print(count.vocabulary_)
print(bag.toarray())
# convert into term frequency-inverse document frequency; gives us a sense of useful discriminatory information (like feature selection)
tfidf = text.TfidfTransformer()
np.set_printoptions(precision=2)
print(tfidf.fit_transform(count.fit_transform(DOCS)).toarray())


# cleanup by removing punctuation
def preprocessor(doc):
    doc = re.sub('<[^>]*>', '', doc)
    emoticons = re.findall('(?::|;|=)(?:-)?(?:\)|\(|D|P)',
                           doc)
    doc = (re.sub('[\W]+', ' ', doc.lower()) +
           ' '.join(emoticons).replace('-', ''))
    return doc


df['review'] = df['review'].apply(preprocessor)


# tokenize document by word and reduce to root words
def tokenizer(text):
    return text.split()


def tokenizer_porter(text):
    return [port.PorterStemmer().stem(word) for word in text.split()]


# init stopwords to ignore (is, and, etc.)
nltk.download('stopwords')
STOP = nltk.corpus.stopwords.words('english')
# store data in dataframe
data_train = df.loc[:25000, 'review'].values
target_train = df.loc[:25000, 'sentiment'].values
data_test = df.loc[25000:, 'review'].values
target_test = df.loc[25000:, 'sentiment'].values
# prep tfidf
tfidf = text.TfidfVectorizer(strip_accents=None,
                             lowercase=False,
                             preprocessor=None)
param_grid = [{'vect__ngram_range': [(1, 1)],
               'vect__stop_words': [STOP, None],
               'vect__tokenizer': [tokenizer, tokenizer_porter],
               'clf__penalty': ['l1', 'l2'],
               'clf__C': [1.0, 10.0, 100.0]},
              {'vect__ngram_range': [(1, 1)],
               'vect__stop_words': [STOP, None],
               'vect__tokenizer': [tokenizer, tokenizer_porter],
               'vect__use_idf':[False],
               'vect__norm':[None],
               'clf__penalty': ['l1', 'l2'],
               'clf__C': [1.0, 10.0, 100.0]}]
# pipeline (this takes forever so comment out)
lr_tfidf = pl.Pipeline([('vect', tfidf),
                        ('clf', lm.LogisticRegression(random_state=0))])
gs_lr_tfidf = ms.GridSearchCV(lr_tfidf, param_grid, scoring='accuracy',
                              cv=5, verbose=1, n_jobs=-1)
# gs_lr_tfidf.fit(data_train, target_train)
# print best parameter set
# print('Best parameter set: %s ' % gs_lr_tfidf.best_params_)
# print('CV Accuracy: %.3f' % gs_lr_tfidf.best_score_)
# clf = gs_lr_tfidf.best_estimator_
# print('Test Accuracy: %.3f' % clf.score(data_test, target_test))
# preprocessor_two


# cleanup by removing punctuation
def preprocessor_two(doc):
    doc = re.sub('<[^>]*>', '', doc)
    emoticons = re.findall('(?::|;|=)(?:-)?(?:\)|\(|D|P)',
                           doc)
    doc = (re.sub('[\W]+', ' ', doc.lower()) +
           ' '.join(emoticons).replace('-', ''))
    preprocessed = [word for word in doc.split() if word not in STOP]
    return preprocessed


# generator function to read in and return one document
def stream_docs(path):
    with open(path, 'r', encoding='utf-8') as csv:
        next(csv)  # skip header
        for line in csv:
            doc, label = line[:-3], int(line[-2])
            yield doc, label


# test with first movie review
next(stream_docs(path='./movie_data.csv'))


# take document stream from stream_docs and return specific number of documents
def get_minibatch(doc_stream, size):
    docs, labels = [], []
    try:
        for _ in range(size):
            doc, label = next(doc_stream)
            docs.append(doc)
            labels.append(label)
    except StopIteration:
        return None, None
    return docs, labels


# use data independent hasher
vect = text.HashingVectorizer(decode_error='ignore', n_features=2**21,
                              preprocessor=None, tokenizer=preprocessor_two)
clf = lm.SGDClassifier(loss='log', random_state=1, max_iter=1)
doc_stream = stream_docs(path='./movie_data.csv')
# perform out of core learning
classes = np.array([0, 1])
for _ in range(45):
    data_train, target_train = get_minibatch(doc_stream, size=1000)
    if not data_train:
        break
    data_train = vect.transform(data_train)
    clf.partial_fit(data_train, target_train, classes=classes)
# use last 5000 documents for evaluation
data_test, target_test = get_minibatch(doc_stream, size=5000)
data_test = vect.transform(data_test)
print('Accuracy: %.3f' % clf.score(data_test, target_test))
# use last 5000 documents to update model
clf = clf.partial_fit(data_test, target_test)
