from elasticsearch import Elasticsearch
import pandas as pd

# init
es = Elasticsearch(['https://user:secret@host:443'])

"""
df to dict where key is row name, nested key is col name, and value is value
e.g.
col1  col2
a     1   0.50
b     2   0.75
{'a': {'col1': 1.0, 'col2': 0.5}, 'b': {'col1': 2.0, 'col2': 0.75}}
"""
dict = df.to_dict('index')

# create index for results
es.create_index('ajc-tweets')

# iterate through dataframe and dump
res = es.bulk_index(index='ajc-tweets', doc_type='tweet', body=dict)
print(res['result'])
