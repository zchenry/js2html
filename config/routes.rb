Rails.application.routes.draw do
  root 'converter#convert'
  get 'get_tweet_likes', to: 'converter#get_tweet_likes'
  get 'get_tweet_favs', to: 'converter#get_tweet_favs'
end
