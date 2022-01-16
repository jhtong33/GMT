# %%
import obspy
from obspy import UTCDateTime 
from obspy.clients.fdsn.client import Client
client = Client("IRIS")
from http.client import IncompleteRead

# %%
# t1 = UTCDateTime("2010-10-01T00:00:00")
t1 = UTCDateTime("2018-01-01T00:00:00")
t2 = UTCDateTime("2020-12-31T23:59:59")

# %%
cat = client.get_events(starttime=t1, endtime=t2, minlatitude=27,maxlatitude=47,minlongitude=30,maxlongitude=60,
            minmagnitude=4)
cat.write('2018-2020LargeRangeEvents.txt',format='ZMAP')