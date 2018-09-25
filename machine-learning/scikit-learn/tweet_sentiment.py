# after twitter mine and before elastic post-proc
import re
import numpy as np
import pandas as pd
import sklearn.feature_extraction.text as text
import sklearn.linear_model as lm
import nltk


# init stopwords to ignore (is, and, etc.)
STOP = nltk.corpus.stopwords.words('english')


# cleanup by removing punctuation
def preprocessor_two(doc):
    doc = re.sub('<[^>]*>', '', doc)
    emoticons = re.findall('(?::|;|=)(?:-)?(?:\)|\(|D|P)',
                           doc)
    doc = (re.sub('[\W]+', ' ', doc.lower()) +
           ' '.join(emoticons).replace('-', ''))
    # this is expensive and remember to not .split() doc if inserting back in
    # doc = [port.PorterStemmer().stem(word) for word in doc.split()]
    return [word for word in doc.split() if word not in STOP]


# generator function to read in and return one document
def stream_docs(path):
    with open(path, 'r', encoding='utf-8') as csv:
        next(csv)  # skip header
        for line in csv:
            doc, label = line[:-3], int(line[-2])
            yield doc, label


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

# begin analysis on tweets
# init
df = pd.read_csv('tweets.csv')
tweets = df['tweet'].values
# predict on transformed tweets matrix
classes = clf.predict(vect.transform(tweets))
df = df.assign(classification=classes)
print(df)
