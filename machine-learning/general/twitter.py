import re
import tweepy
import ruamel.yaml as yaml


# set credentials
creds = yaml.safe_load(open('/home/matt/.twitter/creds').read())
# create auth object
auth = tweepy.OAuthHandler(creds['consumer_key'], creds['consumer_secret'])
# modify auth object for access token
auth.set_access_token(creds['access_token'], creds['access_token_secret'])
# construct api
api = tweepy.API(auth)

# grab user timeline info
user_timeline = api.user_timeline(id='crazykaz88', count=20)
# iterate results
print([tweet.text for tweet in user_timeline])

# grab subject timeline info
subject_timeline = api.search(q='AJC', lang='en')
# iterate results
print([(tweet.user.screen_name, 'Tweeted: ', tweet.text) for tweet in subject_timeline])
# dump to csv in analysis format
csv = "id,tweet\n"
for tweet in subject_timeline:
    preproc = re.sub(r'RT ', '', tweet.text)
    preproc = re.sub(r'@[A-Za-z0-9_]+', '', preproc)
    # id and then tweet content with link replaced by newline
    csv += tweet.id_str + ',"' + re.sub(r'\shttps.*', "\"\n", preproc)
print(csv)
# TODO: grab more info; problem with ellipses and runons (probably because of when link missing at end)
