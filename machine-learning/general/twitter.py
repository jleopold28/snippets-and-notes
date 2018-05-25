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
subject_timeline = api.search(q='Shadow-Soft', lang='en')
# iterate results
print([(tweet.user.screen_name, 'Tweeted: ', tweet.text) for tweet in subject_timeline])
