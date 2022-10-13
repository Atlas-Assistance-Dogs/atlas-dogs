# !/usr/bin/python

import os, sys

oldname = 'PuppyLogsCmp'
newname = 'AllRelatedPuppyLogsCmp'

pwd = os.curdir
#print(os.listdir(pwd))
os.chdir('force-app/main/default/aura')
#print(os.curdir)
os.rename(oldname,newname)

os.chdir(newname)

for filename in os.listdir():
    idx = filename.index('.')
    name = filename[:idx]
    extension = filename[idx:]
    os.rename(filename, newname + extension)

os.chdir(pwd)
