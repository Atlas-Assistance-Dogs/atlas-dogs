/* This can be run using Anonymous Apex:
sfdx force:apex:execute -f datasets/recipes/cleanup.apex -u atlas-dog__qa
*/
list<PublicAccessTest__c> pats = [select id from PublicAccessTest__c];
delete pats;
list<Log__c> logs = [select id from Log__c];
delete logs;
list<DogRelationship__c> humans = [select id from DogRelationship__c];
delete humans;
list<Team__c> teams = [select id from Team__c];
delete teams;
list<ProgramAssignment__c> pas = [select id from ProgramAssignment__c];
delete pas;
list<ContinuingEducationUnit__c> ceus = [select id from ContinuingEducationUnit__c];
delete ceus;
list<BackgroundCheck__c> bgc = [select id from BackgroundCheck__c];
delete bgc;
list<npe4__Relationship__c> relationships = [select id from npe4__Relationship__c];
delete relationships;
list<npe03__Recurring_Donation__c> donations = [select id from npe03__Recurring_Donation__c];
delete donations;
list<Contact> contacts = [select id from contact];
delete contacts;
list<Dog__c> dogs = [select id from Dog__c];
delete dogs;
list<npsp__Address__c> addresses = [select id from npsp__Address__c];
delete addresses;
list<GW_Volunteers__Volunteer_Job__c> jobs = [select id from GW_Volunteers__Volunteer_Job__c];
delete jobs;
list<Lead> leads = [select id from Lead];
delete leads;
list<Account> accounts = [select id from Account];
delete accounts;
list<Campaign> campaigns = [select id from Campaign];
delete campaigns;
list<npo02__Household__c> households = [select id from npo02__Household__c];
delete households;
list<npsp__Batch__c> batches = [select id from npsp__Batch__c];
delete batches;