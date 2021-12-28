import pandas as pd
import numpy as np

df = pd.read_csv('PnAnisotropy_YanLu2017_plot.txt',sep='\s+')

newdf ={'Lon' : [], 
    'Lat' : [],
    'Vpn' : [],
    'NAni'    : [],
    'EAni'    : []}
    
for i in range(len(df['Long'])):
    newdf['Lon'].append(df['Long'][i])
    newdf['Lat'].append(df['Lat'][i])
    newdf['Vpn'].append(df['Vpn'][i])
    total_Ani = df['Ani'][i]
    Direction = df['Direc'][i]
    Nani = total_Ani*np.cos(Direction*np.pi/180)
    Eani = total_Ani*np.sin(Direction*np.pi/180)
    
    newdf['NAni'].append(Nani )
    newdf['EAni'].append(Eani )
    
dff = pd.DataFrame(newdf)
dff.to_csv('qwqwq.csv',index=False)
    