# !/usr/bin/python

import os
import re
import glob
import sys


def update_fields(path):
    with open(path) as original:
        lines = original.readlines()

    with open(path, 'w') as updated:
        for line in lines:
            line = re.sub(r'([A-Za-z])_([A-Z])', r'\1\2', line)
            updated.write(line)


update_fields('/Users/deb/Development/atlas-dogs2/force-app/main/default/permissionsets/Atlas_Super_User.permissionset-meta.xml')
update_fields('/Users/deb/Development/atlas-dogs2/force-app/main/default/profiles/Admin.profile-meta.xml')
