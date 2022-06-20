import glob,os

path = '/Volumes/home/Research/DataBase/16_YB13SVani_yuan/Modelxy_2x2'

for xyfile in sorted(glob.glob(f'{path}/0???km_2x2.xy')):

    file=xyfile.rsplit('/')[-1]
    depth=int(file.rsplit('km')[0])
    
    if depth<=410:
        
        cmd = '''
        csh Global_anisotropy.gmt %(file)s %(depth)i
        ''' %locals()
        os.system(cmd)
        print(f'============finish {depth}')    