import glob,os

path = '/Volumes/home/Research/DataBase/14_Cedric_Anatolia_Anisotropy2021/Models/'

for xyfile in sorted(glob.glob(f'{path}/*-Anisotropic.txt')):

    file=xyfile.rsplit('/')[-1]
    depth=int(file.rsplit('-')[0])
    print(file,depth)
    
    if depth <100:
        dep = '0'+str(depth)
    else : dep = str(depth)
    cmd = '''
    csh Reginal_anisotropy.gmt %(dep)s
    ''' %locals()
    os.system(cmd)
    print(f'============finish {dep}')