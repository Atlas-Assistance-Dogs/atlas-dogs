# !/usr/bin/python

import os, sys

oldname = 'filterByRoleComponent'
newname = 'filterByRole'

pwd = os.curdir
print(os.listdir(pwd))
os.chdir('force-app/main/default/lwc')
print(os.curdir)
os.rename(oldname,newname)

os.chdir(newname)

for filename in os.listdir():
    idx = filename.index('.')
    name = filename[:idx]
    extension = filename[idx:]
    os.rename(filename, newname + extension)

os.chdir(pwd)
