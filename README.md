# atlas-dog

Add a brief description of this project here, in Markdown format.
It will be shown on the main page of the project's GitHub repository.

## Development

To work on this project in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev` to deploy this project.
3. Run `cci org browser dev` to open the org in your browser.
4. To push all meta data to a scratch org: `sf project deploy start -d force-app -d unpackaged/post`

## Test

To run apex tests, set your default org (this is an example for the dev org):

`sf config:set target-org=atlas-dog__dev`

Then you can run the Apex unit tests from Visual Studio Code.

To assign the VolunteerUser permission set to another user on the default org:

`sf org assign permset -n AtlasVolunteer -o ttest@example.com`
