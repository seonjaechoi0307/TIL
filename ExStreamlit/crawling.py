import gdown
import pandas as pd

url = 'https://drive.google.com/uc?id=1iQgkt_DDp6WDxpQo62kuKd4vuepSPH0E'
gdown.download(url, 'new_realstate.csv', quiet=False)

df = pd.read_csv('new_realstate.csv')