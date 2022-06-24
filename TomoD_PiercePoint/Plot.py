import pandas as pd
import os,glob
# RElook= ['BYUR','GUDG','TBLG','KIV','GNI','ONI','AKH']
# RElook= ['KIV']
stafile = '/Volumes/home/Research/DataBase/01_Armenia/Station_info_2.csv'
df = pd.read_csv(stafile)
# print(df)
for i in range(len(df['network'])):
    net = df['network'].values[i]
    sta = df['station'].values[i]
    stlat = df['lat'].values[i]
    stlon = df['lon'].values[i]
    print(sta)  

    stlat_text = stlat-1.2
    cmd = '''
    csh TomoD_PiercePoint.gmt %(sta)s %(stlat)f %(stlon)f %(stlat_text)f
    '''%locals()
    os.system(cmd)   
