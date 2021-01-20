#!/bin/bash

# Make sure that you have set an org as default dev hub. Usually your production environment will be your devhub environment.
#sfdx force:config:set defaultdevhubusername=productionUsernameHere

echo "Creating scratch org"
sfdx force:org:create -s -f config/project-scratch-def.json -a atlas -d 30
sfdx force:org:open

# Before running below line, copy content from inner folders in the github location - 
# https://github.com/SalesforceFoundation/NPSP/tree/master/unpackaged/pre
# and create a single folder "npsp-dependencies" with account, opportunity object files and a combined package.xml
echo "Deploying pre dependency for NPSP packages"
sfdx force:mdapi:deploy -w 100 -d  ./npsp-dependencies/account_record_types -u atlas
sfdx force:mdapi:deploy -w 100 -d  ./npsp-dependencies/opportunity_record_types -u atlas

echo "(1/6) NPSP Installing Contacts & Organizations 3.15.0.2"
echo "y" | sfdx force:package:install -p 04t1E000000cn2oQAA -w 15 -u atlas

echo "(2/6) NPSP Installing Households 3.13.0.2"
echo "y" | sfdx force:package:install -p 04t1E000000yAh8QAE -w 15 -u atlas

echo "(3/6) NPSP Installing Affiliations 3.9.0.2"
echo "y" | sfdx force:package:install -p 04t2E000003kXEEQA2 -w 15 -u atlas

echo "(4/6) NPSP Installing Relationships 3.11.0.2"
echo "y" | sfdx force:package:install -p 04t2E000003ZS9yQAG -w 15 -u atlas

echo "(5/6) NPSP Installing Recurring Donations 3.20.0.2"
echo "y" | sfdx force:package:install -p 04t1E000000japAQAQ -w 15 -u atlas

echo "(6/6) NPSP Installing Nonprofit Success Pack 3.190.0.29"
echo "y" | sfdx force:package:install -p 04t1Y000000ksIoQAI -w 15 -u atlas

echo "if any installation failed, retry it by running corresponding command."

echo "pushing package code"

sfdx force:source:push -f