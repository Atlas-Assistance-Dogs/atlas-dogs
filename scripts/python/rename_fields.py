# !/usr/bin/python

import os, re, glob
import sys

pwd = os.curdir
os.chdir('force-app/main/default/objects')

for object_dir in os.listdir():
    new_object = re.sub(r'([A-Za-z])_([A-Z])', r'\1\2', object_dir)
    if object_dir != new_object:
        print(new_object)
        os.rename(object_dir, new_object)
    fields = glob.glob(new_object + '/fields/*')
    for field_path in fields:
        newname = re.sub(r'([A-Za-z])_([A-Z])', r'\1\2', field_path)
        if newname != field_path:
            print(field_path, newname)
            os.rename(field_path, newname)
 
        with open(newname) as original:
            lines = original.readlines()

        with open(newname, 'w') as updated:
            for line in lines:
                line = re.sub(r'([A-Za-z])_([A-Z])', r'\1\2', line)
                updated.write(line)

os.chdir(pwd)
