# Import the needed packages
import pandas as pd
import numpy as np
import requests

# Spotify Client ID and Secret
CLIENT_ID = "secret"
CLIENT_SEC = "secret"

# Read in streaming history files
folder_dir = "April23\MyData\\"

df_history0 = pd.read_json(folder_dir + 'StreamingHistory0.json')
df_history1 = pd.read_json(folder_dir + 'StreamingHistory1.json')
df_history2 = pd.read_json(folder_dir + 'StreamingHistory2.json')
df_history3 = pd.read_json(folder_dir + 'StreamingHistory3.json')
df_history4 = pd.read_json(folder_dir + 'StreamingHistory4.json')
df_history5 = pd.read_json(folder_dir + 'StreamingHistory5.json')
df_history6 = pd.read_json(folder_dir + 'StreamingHistory6.json')
df_history7 = pd.read_json(folder_dir + 'StreamingHistory7.json')

# Combine the streaming history into one large dataframe
df_streamed = pd.concat([df_history4, df_history5, df_history6, df_history7])

# Create a unique id for each song
df_streamed['unique_id'] = df_streamed['artistName'] + ":" + df_streamed['trackName']

# Read in edited library for tracklist
df_library = pd.read_json(folder_dir + 'YourLibrary.json')

# Create the same unique id for each song
df_library['unique_id'] = df_library['artist'] + ":" + df_library['track']

# Create a column with just the track URI from "spotify:track:URI"
uri_split = df_library["uri"].str.split(":", expand = True)
df_library['track_uri'] = uri_split[2]

# Create the dataframe that is going to be used for visualizing
df_tableau = df_streamed.copy()

# Add column that says if a song is in my current library
df_tableau['in_library'] = np.where(df_tableau['unique_id'].isin(df_library['unique_id'].tolist()),1,0)

# Left join with library on unique_id to include album and track uri
df_tableau = pd.merge(df_tableau, df_library[['album','unique_id','track_uri']],how='left',on=['unique_id'])

# Generate access token
# Authentication URL
AUTH_URL = 'https://accounts.spotify.com/api/token'

auth_response = requests.post(AUTH_URL, {
    'grant_type': 'client_credentials',
    'client_id' : CLIENT_ID,
    'client_secret' : CLIENT_SEC
    })

auth_response_data = auth_response.json()

# Save the access token
access_token = auth_response_data['access_token']

headers = {'Authorization': 'Bearer {token}'.format(token=access_token)}

# Base URL for all Spotify API endpoints
BASE_URL = 'https://api.spotify.com/v1/'

# Create a black dict for storing track URI, artist URI, and genres
dict_genre = {}

track_uris = df_library['track_uri'].to_list()

# Loop through track URIs and pull artist URI using the API,
# then use artist URI to pull genres associated with that artist
# store all these in a dictionary
for t_uri in track_uris:
    
    dict_genre[t_uri] = {'artist_uri': "", "genres":[]}
    
    r = requests.get(BASE_URL + 'tracks/' + t_uri, headers=headers).json()
    a_uri = r['artists'][0]['uri'].split(':')[2]
    dict_genre[t_uri]['artist_uri'] = a_uri
    
    s = requests.get(BASE_URL + 'artists/' + a_uri, headers=headers).json()
    dict_genre[t_uri]['genres'] = s['genres']

# Convert dictionary into dataframe with track_uri as the first column
df_genre = pd.DataFrame.from_dict(dict_genre, orient='index')
df_genre.insert(0, 'track_uri', df_genre.index)
df_genre.reset_index(inplace=True, drop=True)

# Separate the genre to their own line for each track/artist
df_genre_expanded = df_genre.explode('genres')
# Save df_tableau and df_genre_expanded as csv files that we can load into Tableau
#df_tableau.to_csv('MySpotifyDataTable23_1.csv')
df_genre_expanded.to_csv('GenresExpandedTable.csv')

print('done')
