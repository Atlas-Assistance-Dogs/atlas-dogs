// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
// sfdx force:apex:execute -f scripts/apex/cleanup-data.apex

List<Log__c> logs = [SELECT Id from Log__c];
delete logs;

List<PuppyLog__c> puppyLogs = [SELECT Id from PuppyLog__c];
delete puppyLogs;

List<DogRelationship__c> drs = [SELECT Id FROM DogRelationship__c];
delete drs;

List<PublicAccessTest__c> pats = [SELECT Id FROM PublicAccessTest__c];
delete pats;

List<Team__c> teams = [SELECT Id FROM Team__c];
delete teams;

List<ProgramAssignment__c> pas = [SELECT Id FROM ProgramAssignment__c];
delete pas;

List<ContinuingEducationUnit__c> ceus = [SELECT Id FROM ContinuingEducationUnit__c];
delete ceus;

List<BackgroundCheck__c> bgcs = [SELECT Id FROM BackgroundCheck__c];
delete bgcs;

List<npe4__Relationship__c> rels = [SELECT Id FROM npe4__Relationship__c];
delete rels;

List<npe03__Recurring_Donation__c> rds = [SELECT Id FROM npe03__Recurring_Donation__c];
delete rds;

List<Contact> contacts = [SELECT Id FROM Contact LIMIT 900];
delete contacts;

contacts = [SELECT Id FROM Contact LIMIT 900];
delete contacts;

List<Dog__c> dogs = [SELECT Id FROM Dog__c];
delete dogs;

List<npsp__Address__c> addresses = [SELECT Id FROM npsp__Address__c];
delete addresses;

List<GW_Volunteers__Volunteer_Job__c> jobs = [SELECT Id FROM GW_Volunteers__Volunteer_Job__c];
delete jobs;

List<Lead> leads = [SELECT Id FROM Lead];
delete leads;

List<Program__c> programs = [SELECT Id FROM Program__c];
delete programs;

List<Entitlement> entitlements = [SELECT Id FROM Entitlement];
delete entitlements;

List<Account> accounts = [SELECT Id FROM Account];
delete accounts;

List<Campaign> campaigns = [SELECT Id FROM Campaign];
delete campaigns;

List<CategoryRule__c> rules = [SELECT Id FROM CategoryRule__c];
delete rules;