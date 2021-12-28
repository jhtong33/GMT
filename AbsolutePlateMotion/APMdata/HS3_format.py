import numpy as np
import pandas as pd

df = pd.read_csv('GPSdata/local_HS3_ENvel_1grid.xyz',sep='\s+', names = ['lon','lat','angle','mm'])

newdf = {'lon':[],
         'lat':[],
         'Evel':[],
         'Nvel':[] }
for i in range(len(df)):
    lon   = df['lon'].values[i]
    lat   = df['lat'].values[i]
    angle = df['angle'].values[i]
    mm    = df['mm'].values[i]
    
    Nvel  = mm*np.cos(angle*np.pi/180)
    Evel  = mm*np.sin(angle*np.pi/180)
    
    # print(lon,lat,Nvel,Evel)
    
    newdf['lon'].append(lon)
    newdf['lat'].append(lat)
    newdf['Evel'].append(Evel)
    newdf['Nvel'].append(Nvel)
    
newdf = pd.DataFrame(newdf)
newdf.to_csv('GPSdata/local_HS3_ENvel_1grid_new.txt',sep=' ', index=False)