import os
import pandas as pd
import numpy as np

df = pd.DataFrame()

# import imdb review data
labels = {'pos': 1, 'neg': 0}
for data in ('test', 'train'):
    for label in ('pos', 'neg'):
        path = './aclImdb/%s/%s' % (data, label)
        for file in os.listdir(path):
            with open(os.path.join(path, file), 'r') as infile:
                text = infile.read()
                df = df.append([[text, labels[label]]], ignore_index=True)
# setup cols
df.columns = ['review', 'sentiment']
# permute dataframe and dump to csv
np.random.seed(0)
df = df.reindex(np.random.permutation(df.index))
df.to_csv('./movie_data.csv')
# check csv
print(pd.read_csv('./movie_data.csv').head(3))
