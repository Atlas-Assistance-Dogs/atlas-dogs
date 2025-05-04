# atlas-dog

This project creates a Salesforce managed package used to manage Teams, Clients, Dogs, Trainers, Team Facilitators, 
and Volunteers for Atlas Assistance Dogs.
The project us using SFDX to manage the code within github and develop and test using Salesforce scratch organizations.
It also makes use of CumulusCi to scaffold the organizations used to develop and test the package.

This project contains several custom objects and many custom fields, primarily on the Contact object within Salesforce.
Each contact can have several positions within Atlas, represented by a multi-select picklist called Positions.

To allow individual users to access only the contacts they are allowed to see, the package defines
groups related to the position(s) a contact, and when installed in an organization, users assigned
to these groups are given shared access to the contacts.

## Development

To work on this project in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.
4. To push all meta data to a scratch org: `sf project deploy start -d force-app -d unpackaged/post`

## Test

To run apex tests, set your default org (this is an example for the dev org):

`sf config set target-org=atlas-dog__dev`

Then you can run the Apex unit tests from Visual Studio Code.

To assign the VolunteerUser permission set to another user on the default org:

`sf org assign permset -n AtlasVolunteer -o ttest@example.com`
