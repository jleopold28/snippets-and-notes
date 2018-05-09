import re
import numpy as np
import pandas as pd
import sklearn.feature_extraction.text as text
import nltk.corpus as corp
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
print(tfidf.fit_transform(count.fit_transform(DOCS)).to_array())


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
def tokenizer(doc):
    return [port.PorterStemmer().stem(word) for word in doc.split()]


# init stopwords to ignore (is, and, etc.)
STOP = corp.stopwords.words('english')
