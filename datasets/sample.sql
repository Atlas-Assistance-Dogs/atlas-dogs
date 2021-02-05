BEGIN TRANSACTION;
CREATE TABLE "Account" (
	id INTEGER NOT NULL, 
	"Assigned_Volunteer_Roles__c" VARCHAR(255), 
	"Background_Check_Latest_Date__c" VARCHAR(255), 
	"Background_Check_Requested_Date__c" VARCHAR(255), 
	"Background_check_latest_result__c" VARCHAR(255), 
	"Background_check_notes__c" VARCHAR(255), 
	"Board_Member_Accepted_Date__c" VARCHAR(255), 
	"Board_Member_Status__c" VARCHAR(255), 
	"Board_Member__c" VARCHAR(255), 
	"Client_Status_PKlst__c" VARCHAR(255), 
	"Client__c" VARCHAR(255), 
	"Convicted_Of_Crime__c" VARCHAR(255), 
	"Crime_Conviction_Notes__c" VARCHAR(255), 
	"DOB__c" VARCHAR(255), 
	"Email__c" VARCHAR(255), 
	"Facilitator_Application_Receipt_Date__c" VARCHAR(255), 
	"Facilitator_Application_Received__c" VARCHAR(255), 
	"Facilitator_Interview_End_DateTime__c" VARCHAR(255), 
	"Facilitator_Interview_Notes__c" VARCHAR(255), 
	"Facilitator_Interview_Start_Date_Time__c" VARCHAR(255), 
	"Facilitator_Onboarding_Remainder_Date__c" VARCHAR(255), 
	"Facilitator_Preliminary_Interview_Date__c" VARCHAR(255), 
	"Facilitator_Provision_Details__c" VARCHAR(255), 
	"Facilitator_Provisional_Agreement_Date__c" VARCHAR(255), 
	"Facilitator_Reminder_Date__c" VARCHAR(255), 
	"Facilitator_Status__c" VARCHAR(255), 
	"Facilitator_WS_Country__c" VARCHAR(255), 
	"Facilitator_WS_Location_Address1__c" VARCHAR(255), 
	"Facilitator_WS_Location_City__c" VARCHAR(255), 
	"Facilitator_WS_State__c" VARCHAR(255), 
	"Facilitator_WS_Zip__c" VARCHAR(255), 
	"Facilitator_Workshop_Schedule__c" VARCHAR(255), 
	"Facilitator__c" VARCHAR(255), 
	"Facitator_Agreement_Recieved_Date__c" VARCHAR(255), 
	"First_Name__c" VARCHAR(255), 
	"Handler_Exists__c" VARCHAR(255), 
	"Interview_Date_for_Board__c" VARCHAR(255), 
	"Last_Name__c" VARCHAR(255), 
	"Lead_Facilitator__c" VARCHAR(255), 
	"MI__c" VARCHAR(255), 
	"Media_Release_Form_Submitted__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Phone_Other__c" VARCHAR(255), 
	"Phone_Secondary__c" VARCHAR(255), 
	"Preferred_Phone_Test_Capable__c" VARCHAR(255), 
	"RecordTypeId" VARCHAR(255), 
	"Rejection_Note_after_Vol_Role_Interview__c" VARCHAR(255), 
	"Secondary_Phone_Text_Capable__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Suffix__c" VARCHAR(255), 
	"Trainer__c" VARCHAR(255), 
	"Volunteer_Emergency_Contact_Submitted__c" VARCHAR(255), 
	"Volunteer_Forms_Submission_Date__c" VARCHAR(255), 
	"Volunteer_Interview_Date_End_Time__c" VARCHAR(255), 
	"Volunteer_Interview_Date_Start_time__c" VARCHAR(255), 
	"Volunteer_Interview_Notes__c" VARCHAR(255), 
	"Volunteer_Provision_Details__c" VARCHAR(255), 
	"Volunteer_Remainder_Date__c" VARCHAR(255), 
	"Volunteer_Role_With_No_Data_Access__c" VARCHAR(255), 
	"Volunteer_Role__c" VARCHAR(255), 
	"Volunteer_Status__c" VARCHAR(255), 
	"Volunteer__c" VARCHAR(255), 
	"npe01__SYSTEMIsIndividual__c" VARCHAR(255), 
	"npe01__SYSTEM_AccountType__c" VARCHAR(255), 
	"npo02__AverageAmount__c" VARCHAR(255), 
	"npo02__Best_Gift_Year_Total__c" VARCHAR(255), 
	"npo02__Best_Gift_Year__c" VARCHAR(255), 
	"npo02__FirstCloseDate__c" VARCHAR(255), 
	"npo02__Formal_Greeting__c" VARCHAR(255), 
	"npo02__HouseholdPhone__c" VARCHAR(255), 
	"npo02__Informal_Greeting__c" VARCHAR(255), 
	"npo02__LargestAmount__c" VARCHAR(255), 
	"npo02__LastCloseDate__c" VARCHAR(255), 
	"npo02__LastMembershipAmount__c" VARCHAR(255), 
	"npo02__LastMembershipDate__c" VARCHAR(255), 
	"npo02__LastMembershipLevel__c" VARCHAR(255), 
	"npo02__LastMembershipOrigin__c" VARCHAR(255), 
	"npo02__LastOppAmount__c" VARCHAR(255), 
	"npo02__MembershipEndDate__c" VARCHAR(255), 
	"npo02__MembershipJoinDate__c" VARCHAR(255), 
	"npo02__NumberOfClosedOpps__c" VARCHAR(255), 
	"npo02__NumberOfMembershipOpps__c" VARCHAR(255), 
	"npo02__OppAmount2YearsAgo__c" VARCHAR(255), 
	"npo02__OppAmountLastNDays__c" VARCHAR(255), 
	"npo02__OppAmountLastYear__c" VARCHAR(255), 
	"npo02__OppAmountThisYear__c" VARCHAR(255), 
	"npo02__OppsClosed2YearsAgo__c" VARCHAR(255), 
	"npo02__OppsClosedLastNDays__c" VARCHAR(255), 
	"npo02__OppsClosedLastYear__c" VARCHAR(255), 
	"npo02__OppsClosedThisYear__c" VARCHAR(255), 
	"npo02__SYSTEM_CUSTOM_NAMING__c" VARCHAR(255), 
	"npo02__SmallestAmount__c" VARCHAR(255), 
	"npo02__TotalMembershipOppAmount__c" VARCHAR(255), 
	"npo02__TotalOppAmount__c" VARCHAR(255), 
	"npsp__Funding_Focus__c" VARCHAR(255), 
	"npsp__Grantmaker__c" VARCHAR(255), 
	"npsp__Matching_Gift_Administrator_Name__c" VARCHAR(255), 
	"npsp__Matching_Gift_Amount_Max__c" VARCHAR(255), 
	"npsp__Matching_Gift_Amount_Min__c" VARCHAR(255), 
	"npsp__Matching_Gift_Annual_Employee_Max__c" VARCHAR(255), 
	"npsp__Matching_Gift_Comments__c" VARCHAR(255), 
	"npsp__Matching_Gift_Company__c" VARCHAR(255), 
	"npsp__Matching_Gift_Email__c" VARCHAR(255), 
	"npsp__Matching_Gift_Info_Updated__c" VARCHAR(255), 
	"npsp__Matching_Gift_Percent__c" VARCHAR(255), 
	"npsp__Matching_Gift_Phone__c" VARCHAR(255), 
	"npsp__Matching_Gift_Request_Deadline__c" VARCHAR(255), 
	"npsp__Number_of_Household_Members__c" VARCHAR(255), 
	"Client_Name__c" VARCHAR(255), 
	"Facilitator_Name__c" VARCHAR(255), 
	"Level__c" VARCHAR(255), 
	"Microchip_Number__c" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Previous_Level__c" VARCHAR(255), 
	"Trainer_Name__c" VARCHAR(255), 
	"npe01__One2OneContact__c" VARCHAR(255), 
	"npsp__Batch__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','VolunteerbBKG','False','','Check Pass','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(2,'','','','','','','Onboarding','False','','False','False','','1980-05-28','davidw@test.com','','False','','','','','','','','','On boarding','','','','','','','False','','David','False','','Warner','False','','False','Henry Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(3,'','','','','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-05-30','True','2020-06-03T10:00:00.000+0000','','2020-06-03T09:16:00.000+0000','','','','','','Scheduled Interview','','','','','','','True','','Sadia','False','','Samir','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(4,'','','','','','','Onboarding','False','','False','False','','','kavshan2019@gmail.com','2020-05-30','True','2020-06-06T11:15:00.000+0000','gfgf','2020-06-05T10:43:00.000+0000','','','gfg','2020-05-30','','Training course and workshop pending completion','','','','','','','True','','Guha','False','','Shan','False','','False','Guha','','','False','','','False','','','False','True','2020-05-30','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(5,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-22','True','2020-05-21T17:38:00.000+0000','wwyyw','2020-05-29T17:38:00.000+0000','','','wwww','2020-05-22','','Training course and workshop pending completion','','','','','','','False','','Nicole','False','','Thomas','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-05-22','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(6,'Client Certification','2020-11-10','','Fail','5274','','Onboarding','False','','False','False','','2020-11-06','kavshan2019@gmail.com','','False','','','','','','','','','','','','','','','','False','','Jim','False','','Harry','False','','True','Jimharry','','','True','','','False','','','False','True','2020-11-09','2020-11-19T00:16:00.000+0000','2020-11-18T23:45:00.000+0000','453658','','2021-02-10','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(7,'','','','','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','','False','','','','','','','','','','','','','','','','True','','Rohan','False','','Revanth','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(8,'','','','','','','','False','','False','False','','','jen@atlasdog.org','','False','','','','','','','','','','','','','','','','False','','dsada','False','','dsadsa','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(9,'','','','','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-06-12','True','2020-06-26T08:15:00.000+0000','','2020-06-26T08:07:00.000+0000','','','','','2020-09-09','Scheduled Interview','','','','','','','True','','Aparna','False','','Aravind','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(10,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','Volunteer BkG Check Failed','False','','But Considered','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(11,'','2020-04-25','','Pass','','','Preliminary Interview Setup','True','','False','False','','','immadir@yahoo.com','2020-04-26','True','','','','','','Sharepoint
Salesforce','','2020-05-21','Training course and workshop pending completion','United States','11501 Dublin Blvd,','Dublin','California','','2020-05-29T06:50:00.000+0000','True','2020-04-25','Meher','False','2020-05-05','JEssy','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-04-26','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(12,'','2020-04-27','2020-04-27','Pass','','2020-04-27','Board Interview Committee Feedback Pending','True','','False','False','','','immadir@yahoo.com','2020-04-27','True','','Interview notes
1)
2)
3)','','','2020-05-14T23:45:00.000+0000','Sharepoint
Visio
Salesforce','','2020-04-27','Provisionally active','United States','2826 Arronia Ct','Pleasanton','California','94588','2020-05-27T23:00:00.000+0000','True','2020-04-27','Jen','False','2020-04-29','Kolar','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','False','True','2020-04-27','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(13,'','','','','','','Not a good fit','True','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','JenII','False','2020-04-28','Kolar II','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(14,'','2020-06-10','2020-06-10','Fail','dsad','','Onboarding','False','','False','False','','','kolarj@gmail.com','2020-06-10','True','2020-06-12T06:15:00.000+0000','yes, we accept her for now','2020-06-12T03:14:00.000+0000','','','stuff here','2020-06-10','','Provisionally active','','','','','','','True','2020-06-10','Jen latest','False','','test','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-10','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(15,'','2020-05-01','2020-05-01','Pass','','2020-04-22','Provisionally on boarded as volunteer until next board meeting','True','','False','False','','','immadir@yahoo.com','2020-05-01','True','','Interview notes for Jone Kenny','','','2020-05-27T19:31:00.000+0000','Sharepoint
Salesforces
Visio','','2020-04-24','Provisionally active','United States','2826 Arronia Ct','Pleasanton','California','94588','2020-06-25T19:42:00.000+0000','True','2020-05-01','Jon','False','2020-04-29','Kenny','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-04-26','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(16,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-22','True','2020-05-22T20:03:00.000+0000','wtwetw','2020-05-22T20:03:00.000+0000','','','weteqt','2020-05-22','','Training course and workshop pending completion','','','San Jose','CA','94588','','False','','Naga','False','','Raju','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-05-22','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(17,'','2020-12-30','','Fail',',nm. m','','Onboarding','False','','False','False','','','123@123.com','','False','','','','','','','','','','','','','','','','True','','123211','False','','HIUJ232323','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-12-30','2020-12-31T02:08:00.000+0000','2021-01-01T02:08:00.000+0000','ghmkjghj','','2021-03-30','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(18,'','2020-08-23','','Pass','','','Onboarding','False','','False','False','','','rameshi@atlasdog.org','','False','','','','','','','','','Provisionally selected','','','','','','','False','','Joe','False','','Root','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-08-17','2020-08-23T05:15:00.000+0000','2020-08-23T05:15:00.000+0000','wt','','2020-11-21','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(19,'','','','','','','','False','','False','False','','','aa@aa.com','','False','','','','','','','','','','','','','','','','False','','Ram Volunteer','False','','RV','False','','True','Anonymous Household','','','False','','','False','Interview Pending','','False','True','2021-01-17','2021-01-21T17:00:00.000+0000','2021-04-07T23:36:45.000+0000','kjh','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(20,'','','','','','','Onboarding','False','','False','False','','2010-06-12','iamswapna@gmail.com','2020-06-06','True','2020-06-13T06:15:00.000+0000','ghgh','2020-06-13T05:59:00.000+0000','','','','2020-06-05','2020-09-04','Provisionally selected','','','','','','','True','','Akhil','False','','Alana','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-05','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(21,'','2020-05-19','2020-05-19','Pass','','','','False','','True','False','','','immadir@gmail.com','2020-05-28','True','2020-05-29T08:00:00.000+0000','No Decision','2020-05-29T07:05:00.000+0000','','','Sharepoint','2020-05-28','2020-11-19','Provisionally selected','','','','','','','True','2020-05-19','Ram3','False','','UP3','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','True','True','2020-05-13','','','','','2020-11-19','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(22,'','','','','','','','False','','False','False','','','immadir@yahoo.com','2020-05-29','True','2020-05-27T20:00:00.000+0000','twrwtrw','2020-05-29T19:00:00.000+0000','','','example','2020-05-29','','Training course and workshop pending completion','','','','','','','True','','Admin','False','','Test1','False','','False','Admin','','','False','','','False','Interview Schedule','','False','True','2020-05-22','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(23,'','','','','','','Onboarding','False','','False','False','','','test@test.com','','False','','','','','','','','','','','','','','','','False','','Test','False','','Again','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(24,'ADI Accreditation; Academy; Branding and Marketing','2020-11-05','2020-05-04','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-11-03','True','2020-11-05T03:30:00.000+0000','dsada','2020-11-05T03:15:00.000+0000','','2020-05-12T13:45:00.000+0000','dsda','2020-11-03','2020-05-03','Provisionally selected','','','','','','2020-05-06T14:49:00.000+0000','True','2020-06-19','Jennifer','False','','Kolar','False','','True','Kolar Household','','','True','','','False','','','False','True','2020-09-09','2021-01-17T03:09:00.000+0000','2021-01-17T05:15:00.000+0000','dsadsa','','2021-02-04','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(25,'','','','','','','Preliminary Interview Setup','False','','False','False','','','iamswapna@gmail.com','2020-05-29','True','2020-05-31T00:01:00.000+0000','','2020-05-30T00:01:00.000+0000','','','','','2020-08-29','Scheduled Interview','','','','','','','False','','Amika','False','','Asha','False','','False','Berl Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(26,'','','','','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-06-01','True','2020-06-24T10:15:00.000+0000','gfgf','2020-06-24T09:30:00.000+0000','','','fdf','2020-06-01','2020-09-01','Not Ready','','','','','','','True','','Nadia','False','','Shan','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-01','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(27,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','tes1','False','','test2','False','','False','test1','','','False','','','False','Interview Schedule','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(28,'','2020-04-27','2020-04-27','Pass','','','','False','','False','False','','','immadir@yahoo.com','2020-04-27','True','','weew','','','2020-04-28T20:00:00.000+0000','weew','','','Training course and workshop pending completion','United States','458 Peters Ave','Pleasanton','California','94588','2020-04-30T20:01:00.000+0000','True','','Susan','False','','Luna','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-04-27','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(29,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-22','True','2020-05-29T20:07:00.000+0000','ewtwet','2020-05-29T20:07:00.000+0000','','','wrwywr','2020-05-22','','Training course and workshop pending completion','','','','','','','True','','Rebecca','False','','Jacob','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-05-22','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(30,'','2020-05-01','','Pass','','','Onboarding','False','Selected','False','False','','1990-05-01','molly@atlasdog.org','2020-05-21','True','2020-05-22T23:30:00.000+0000','ewtew','2020-05-22T23:15:00.000+0000','','2020-04-15T19:00:00.000+0000','eqtete','2020-05-21','','Training course and workshop pending completion','','Online','','','','2020-05-11T19:00:00.000+0000','True','','Joe','True','','Johnson','False','','False','Jones Household','','','True','','','False','','','False','True','2020-04-01','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(31,'','','','','','','Onboarding','False','','False','False','','','xyz@abc.com','2020-10-15','True','2020-10-20T11:30:00.000+0000','','2020-10-20T10:35:00.000+0000','','','','','','Scheduled Interview','','','','','','','False','','sunny','False','','tst02','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(32,'','2020-05-04','2020-05-04','Pass','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-04','True','','Sample provision','','','2020-05-26T20:00:00.000+0000','twtlwe','','','Training course and workshop pending completion','United States','11501 Dublin Blvd','Dublin','California','94566','2020-05-27T20:00:00.000+0000','False','','Check','False','','Field Check','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-05-04','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(33,'Operations Master Docs; State Registration','2020-11-18','','Pass','','','','False','','False','False','','','jen@jen.com','','False','','','','','','','','','','','','','','','','False','','Jen','False','','Test','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-11-18','2020-11-20T00:44:00.000+0000','2020-11-20T00:44:00.000+0000','cvxv','sytuff','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(34,'','','','','','','Onboarding','False','','False','False','','','mail2sunny120@gmail.com','2020-10-15','True','2020-10-19T11:15:00.000+0000','','2020-10-19T10:20:00.000+0000','','','','','','Scheduled Interview','','','','','','','False','','sunny','False','','tst01','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(35,'','2020-06-04','2020-06-04','Fail','test','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-06-04','True','2020-06-12T13:00:00.000+0000','gffg','2020-06-12T11:43:00.000+0000','','','fdgfg','2020-06-04','','Not Selected','','','','','','','True','2020-06-04','Rajini','False','','G','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-04','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(36,'','','','','','','Onboarding','False','','False','False','','','abc@xyz.com','','False','','','','','','','','','','','','','','','','False','','sunny','False','','tst03','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(37,'','2020-08-20','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','Provisionally selected','','','','','','','False','','Bob','False','','Ketan','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-08-18','2020-08-22T16:25:00.000+0000','2020-08-22T16:25:00.000+0000','ree','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(38,'','2020-05-01','','Pass','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-22','True','2020-05-28T17:57:00.000+0000','','2020-05-28T17:57:00.000+0000','','','','','','Scheduled Interview','','','','','','','True','','Ajay','False','','Immadi','False','','False','Ajay Immadi','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(39,'Branding and Marketing; Client Operations','2020-09-09','2020-04-27','Pass','','','Onboarding','True','','False','False','','','immadir@yahoo.com','2020-04-27','True','','Sample Prelim Interview Notes','','','2020-04-30T16:44:00.000+0000','Share Point
Visio
SalesForce','','2020-04-27','Provisionally active','United States','458 Peters Ave','Pleasanton','California','94588','2020-05-29T18:00:00.000+0000','True','2020-04-27','Bob','False','','Ketan','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-09-09','2020-09-17T02:06:00.000+0000','2020-09-18T02:06:00.000+0000','dsad','wewee','2020-11-21','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(40,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','San Jose','CA','94588','','False','','Jerry','False','','Thorne','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(41,'','','','','','','','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','False','','Volunteer1','False','','Flow Test1','False','','True','Anonymous Household','','','False','','','False','Interview Pending','','False','True','2020-09-15','2020-09-27T03:16:00.000+0000','2020-09-27T03:30:00.000+0000','wtwte','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(42,'Technology Infrastructure','2020-09-08','2020-06-01','Pass','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-10-20','True','2020-11-08T01:10:00.000+0000','mnm','2020-11-01T00:10:00.000+0000','','','nbn','2020-10-20','2020-09-14','Not Selected','','','','','','','True','2020-10-20','Aarush','False','','Ashish','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-09-08','2020-12-02T04:09:00.000+0000','2020-12-03T04:09:00.000+0000','sd','Test, AHNS:FKSFk:DFKsdf','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(43,'','2020-10-22','','Fail','jhbjb','','Onboarding','False','','False','False','','','kavshan2019@gmail.com','','False','','','','','','','','','','','','','','','','False','','EFG','False','','HIJ','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-10-22','2020-10-29T11:52:00.000+0000','2020-10-29T12:30:00.000+0000','nmkjnk','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(44,'Branding and Marketing','2020-10-22','','Pass','','','Onboarding','False','','False','False','','','kavshan2019@gmail.com','','False','','','','','','','','','','','','','','','','False','','Sri','False','','Shan','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-10-22','2020-10-23T11:47:00.000+0000','2020-10-23T11:48:00.000+0000','jhgj','n,mn','2021-01-22','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(45,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','Ram','False','','FileUpload','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(46,'','','','','','','','False','','True','False','','','immadir@gmail.com','','False','','','','','','','','','','','','','','','','False','','Ram','False','','Client','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(47,'','','','','','','','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','False','','Ajay','False','','Immadi','False','','False','Ajay Immadi','','','False','','','False','Interview Schedule','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(48,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-05-21','True','2020-05-23T00:00:00.000+0000','fgqe','2020-05-22T23:30:00.000+0000','','','gw','2020-05-21','','Training course and workshop pending completion','','','','','','','False','','Haubert','False','','Haubert','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-05-21','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(49,'','2020-06-09','2020-06-09','Pass','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-06-09','True','2020-06-19T07:30:00.000+0000','Test','2020-06-19T05:45:00.000+0000','','','Test','2020-06-09','2020-09-09','Not Ready','','','','','','','True','2020-06-09','Rama','False','','Ram','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-01','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(50,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','File3','False','','UL3','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(51,'','2020-06-04','2020-06-04','Pass','','','Onboarding','False','','True','False','','2020-06-17','iamswapna@gmail.com','2020-06-04','True','2020-06-11T10:30:00.000+0000','jllk','2020-06-11T09:36:00.000+0000','','','kjkj','2020-06-04','','Provisionally active','','','','','','','True','2020-06-04','Kavitha','False','','Shan','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-04','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(52,'Client Certification','2021-01-17','','Pass','','','','False','','False','False','','','test@test.com','','False','','','','','','','','','','','','','','','','True','','1','False','','test','False','','True','Anonymous Household','','','False','','','False','Interview Pending','','False','True','2021-01-17','2021-01-19T02:17:12.000+0000','2021-01-19T02:47:12.000+0000','xvcxvxcb','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(53,'','','','','','','Onboarding','False','','False','False','','','iamswapna@gmail.com','2020-05-29','True','2020-05-30T13:30:00.000+0000','Interested in 2nd Interview','2020-05-30T12:36:00.000+0000','','','','','2020-08-29','Provisionally selected','','','','','','','True','','Aki','False','','Ram','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(54,'Academy; ADI Accreditation; Branding and Marketing; Client Certification','','','','','','','True','','False','False','','','immadir@yahoo.com','2020-05-14','True','','rereyeye','','','2020-05-21T15:51:00.000+0000','rtrwtw','','2020-11-15','Not considering','','','San Jose','CA','94588','','True','','Ram','False','','Facilitator1','False','','True','Ram Facilitator1','','','False','','','False','Interview Pending','','False','True','2020-12-27','2021-01-18T19:37:00.000+0000','2021-01-28T19:37:00.000+0000','ryhfttu','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(55,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','False','','Ram','False','','Trainer1','False','','False','Anonymous Household','','','False','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(56,'','','','','','','','False','','False','False','','','','','False','','','','','','','','','','','','','','','','True','','Ram','False','','C3','False','','False','Ram C2','','','False','','','False','Interview Pending','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(57,'','','','','','','Onboarding','True','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','False','','Nancy','False','','P','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(58,'','2020-08-24','2020-07-02','Pass','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-07-04','True','2020-07-10T14:30:00.000+0000','selected role','2020-07-10T14:03:00.000+0000','','','Share point
Salesforce','2020-07-04','','Training course and workshop pending completion','','','','','','','False','2020-07-02','Clint','False','','Taylor','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-07-02','2020-08-23T04:38:00.000+0000','2020-08-23T04:38:00.000+0000','wetew','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(59,'','2020-06-19','2020-06-19','Fail','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-06-19','True','2020-06-22T23:45:00.000+0000','ew','2020-06-22T23:27:00.000+0000','','','ww','2020-06-19','','Not Selected','','','','','','','True','','Vasan','False','','Nan','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-19','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(60,'Community Outreach and Education; State Registration; Volunteer & Staff Operations','2020-09-02','','Pass','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-09-02','True','2020-09-26T17:43:00.000+0000','TRWTWR','2020-09-26T17:33:00.000+0000','','','','2020-09-02','','Provisionally selected','','','','','','','True','','Brinda','False','','K','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-09-01','2020-09-26T17:49:00.000+0000','2020-09-26T17:49:00.000+0000','eqerq','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(61,'Volunteer & Staff Operations','2020-10-16','','Pass','','','','False','','False','False','','2005-05-05','immadir@yahoo.com','2020-05-22','True','2020-05-29T17:33:00.000+0000','wrwry','2020-05-29T17:33:00.000+0000','','','etwywr','2020-05-22','','Training course and workshop pending completion','','','','','','','False','','Ajay','False','','Immadi','False','','True','Ajay Immadi','','','False','','','False','Interview Pending','','True','True','2020-10-16','2021-01-08T00:20:54.000+0000','2021-01-08T00:50:54.000+0000','wrtw','dgfdhfhf','2020-11-16','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(62,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','2020-06-28','True','2020-07-11T04:30:00.000+0000','It went good , ready to onboard','2020-07-11T04:18:00.000+0000','','','erweew
wetw
Sharepoint','2020-06-26','','Scheduled Interview','','','','','','','False','','Arjinder','False','','Kaur','False','','False','Anonymous Household','','','False','','','False','','','False','True','2020-06-26','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(63,'Branding and Marketing','2020-10-21','','Fail','','','Onboarding','False','','False','False','','2020-10-07','kavshan2019@gmail.com','','False','','','','','','','','','','','','','','','','False','','Kavitha','False','','Shan','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-10-19','2020-10-29T07:57:00.000+0000','2020-10-29T08:00:00.000+0000','gh','jghj','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(64,'Branding and Marketing','2020-10-07','','Pass','All Good','2020-10-23','Onboarding','True','','False','False','None','2020-10-19','kavshan2019@gmail.com','','False','','','','','','','','','','','','','','','','False','','Allan','True','2020-10-23','Wheeler','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-10-22','2020-10-22T04:59:00.000+0000','2020-10-22T04:59:00.000+0000','xbcvbn','mn','','','Branding and Marketing','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(65,'','','','','','','Onboarding','False','','False','False','','','kolarj@gmail.com','2020-10-20','True','2020-10-21T23:00:00.000+0000','','2020-10-21T22:13:00.000+0000','','','','','','Scheduled Interview','','','','','','','False','','Jen','False','','Kolar','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(66,'Branding and Marketing','2020-12-31','','Fail','hgjgjhg','','Onboarding','False','','False','False','','','sg@dggf.com','','False','','','','','','','','','','','','','','','','False','','dfgfd','False','','dfgdf','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-12-31','2021-01-02T04:29:00.000+0000','2021-01-02T04:29:00.000+0000','ghg','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(67,'Client Certification','2020-12-31','','Pass','','','','False','','False','False','','2020-12-24','abc@abcd.com','','False','','','','','','','','','','','','','','','','False','','Tom','False','','Jerry','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-12-31','2021-01-13T01:48:00.000+0000','2021-01-13T01:48:00.000+0000','mhgjkh','jkjhkhjkjhkhjk hgkjhjkh hjkghjkhkjh hgjkhgjkhg','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(68,'','','','','','','Onboarding','False','','False','False','','','sd@dgh.com','','False','','','','','','','','','','','','','','','','False','','fgh','False','','gfhfg','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(69,'','','','','','','Onboarding','False','','False','False','','2020-12-31','abc@dfg.com','','False','','','','','','','','','','','','','','','','False','','ABC','False','','EFG','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(70,'','','','','','','Onboarding','False','','False','False','','','11@11.com','','False','','','','','','','','','','','','','','','','False','','a','False','','t','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(71,'','','','','','','Onboarding','False','','False','False','','','12@12.com','','False','','','','','','','','','','','','','','','','False','','a','False','','t','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(72,'Client Certification','2020-12-31','','Pass','','','Onboarding','False','','False','False','','2020-12-30','abc@abcd.com','','False','','','','','','','','','','','','','','','','False','','Anne','False','','Elsa','False','','True','Anonymous Household','','','False','','','False','','','False','True','2020-12-31','2021-01-01T02:26:00.000+0000','2021-01-01T02:26:00.000+0000','ghgj','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(73,'','','','','','','Onboarding','False','','False','False','','','ater@gmail.com','','False','','','','','','','','','','','','','','','','False','','As','False','','T','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(74,'','','','','','','','False','','False','False','','','11@11.com','','False','','','','','','','','','','','','','','','','False','','aa','False','','aaa','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(75,'','','','','','','Onboarding','False','','True','False','','','abc@adgg.com','','False','','','','','','','','','','','','','','','','False','','Porter','False','','HG','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(76,'','','','','','','','False','','False','False','','','kolarj@gmail.com','','False','','','','','','','','','','','','','','','','False','','Jennifer','False','','Kolar','False','','False','Kolar Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(77,'','','','','','','','False','','False','False','','','sdklsajlk@jlkdjl.com','','False','','','','','','','','','','','','','','','','False','','NewAccountFirst','False','','NewAccountLast','False','','False','NewContactLast Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(78,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','True','','Nilo','False','','Vas','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(79,'','','','','','','Onboarding','False','','False','False','','1980-01-01','mail2sunny120@gmail.com','2020-07-08','True','2020-07-10T10:59:00.000+0000','test review','2020-07-08T11:00:00.000+0000','','','','2020-07-08','','Provisionally selected','','','','','','','True','','Sunil','False','','Tst002','False','','False','SGTst002','','','False','','','False','','','False','True','2020-07-08','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(80,'','','','','','','Onboarding','False','','False','False','','2000-07-01','mail2sunny120@gmail.com','','True','','','','','','','','','','','','','','','','False','','Sunil','False','','LeadFac001','True','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(81,'','','','','','','Onboarding','False','','False','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','True','','Todd','False','','Tucker','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(82,'','','','','','','Onboarding','False','','False','False','','','file@u.com','','False','','','','','','','','','','','','','','','','True','','Ash','False','','T','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(83,'','','','','','','Onboarding','False','','False','False','','','f@fu.com','','False','','','','','','','','','','','','','','','','True','','F','False','','T','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(84,'','','','','','','Onboarding','False','','False','False','','','f@fu.com','','False','','','','','','','','','','','','','','','','True','','F','False','','U','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(85,'','','','','','','Onboarding','True','','False','False','','1973-07-01','mail2sunny120@gmail.com','','False','','','','','','','2020-07-08','','','','','','','','','True','','Sunil','False','','XYZ001','False','','False','Anonymous Household','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(86,'','','','','','','','False','','False','False','','','immadir@yahoo.com','2020-05-22','True','2020-05-25T17:30:00.000+0000','wwtw','2020-05-25T17:09:00.000+0000','','','wewe','2020-05-22','','Training course and workshop pending completion','','','','','','','False','','Jon','True','','Doe','False','','False','Jon Doe','','','False','','','False','Interview Pending','','True','True','2020-05-22','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(87,'','','','','','','','False','','True','False','','2011-10-13','rameshi@atlasdog.org','','False','','','','','','','','','','','','','','','','False','','Ram','False','','HA1','False','','False','Case Household','2019863244','5683659752','True','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(88,'','','','','','','','False','','True','False','','','immadir@yahoo.com','','False','','','','','','','','','','','','','','','','False','','Molly','False','','Hello','False','','False','Ram C1','','','False','','','False','Interview Pending','','True','False','','','','','','','','','','True','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
INSERT INTO "Account" VALUES(89,'','','','','','','','False','','False','False','','','sample@test.org','','False','','','','','','','','','','','','','','','','False','','Test','False','','Dog','False','','False','Test Account','','','False','','','False','','','False','False','','','','','','','','','','False','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
CREATE TABLE "Account_rt_mapping" (
	record_type_id VARCHAR(18) NOT NULL, 
	developer_name VARCHAR(255), 
	PRIMARY KEY (record_type_id)
);
INSERT INTO "Account_rt_mapping" VALUES('01217000002mR0cAAE','Client');
INSERT INTO "Account_rt_mapping" VALUES('01217000002mR0dAAE','Facilitator');
INSERT INTO "Account_rt_mapping" VALUES('01217000002mQoKAAU','HH_Account');
INSERT INTO "Account_rt_mapping" VALUES('01217000002mQoLAAU','Organization');
INSERT INTO "Account_rt_mapping" VALUES('01217000002mR0eAAE','Trainer');
INSERT INTO "Account_rt_mapping" VALUES('01217000002mR0fAAE','Volunteer');
CREATE TABLE "Contact" (
	id INTEGER NOT NULL, 
	"Address_EC__c" VARCHAR(255), 
	"Date_Started__c" VARCHAR(255), 
	"Email_EC__c" VARCHAR(255), 
	"Emergency_Contact_Name__c" VARCHAR(255), 
	"Emergency_Contact_Phone_Number__c" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"First_Name_EC__c" VARCHAR(255), 
	"Gender__c" VARCHAR(255), 
	"Handler_Address1__c" VARCHAR(255), 
	"Handler_Address2__c" VARCHAR(255), 
	"Handler_City__c" VARCHAR(255), 
	"Handler_Country__c" VARCHAR(255), 
	"Handler_Email__c" VARCHAR(255), 
	"Handler_First_NAme__c" VARCHAR(255), 
	"Handler_Home_Phone__c" VARCHAR(255), 
	"Handler_Last_Name__c" VARCHAR(255), 
	"Handler_MI__c" VARCHAR(255), 
	"Handler_Mailing_Address1__c" VARCHAR(255), 
	"Handler_Mailing_Address2__c" VARCHAR(255), 
	"Handler_Mailing_City__c" VARCHAR(255), 
	"Handler_Mailing_Country__c" VARCHAR(255), 
	"Handler_Mailing_State__c" VARCHAR(255), 
	"Handler_Mailing_Zip_Code__c" VARCHAR(255), 
	"Handler_Mobile_Phone__c" VARCHAR(255), 
	"Handler_Other_Phone__c" VARCHAR(255), 
	"Handler_State__c" VARCHAR(255), 
	"Handler_Suffix__c" VARCHAR(255), 
	"Handler_Zip_Code__c" VARCHAR(255), 
	"How_they_heard_about_Atlas__c" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Notes__c" VARCHAR(255), 
	"PEC_Address1__c" VARCHAR(255), 
	"PEC_Address2__c" VARCHAR(255), 
	"PEC_City__c" VARCHAR(255), 
	"PEC_Country__c" VARCHAR(255), 
	"PEC_First_Name__c" VARCHAR(255), 
	"PEC_Home_Phone__c" VARCHAR(255), 
	"PEC_Last_Name__c" VARCHAR(255), 
	"PEC_MI__c" VARCHAR(255), 
	"PEC_Mobile_Number__c" VARCHAR(255), 
	"PEC_Other_Phone__c" VARCHAR(255), 
	"PEC_Relatiion_Ship__c" VARCHAR(255), 
	"PEC_State__c" VARCHAR(255), 
	"PEC_Suffix__c" VARCHAR(255), 
	"PEC_Zip__c" VARCHAR(255), 
	"Phone_EC__c" VARCHAR(255), 
	"Preferred_Communication_Method__c" VARCHAR(255), 
	"Preferred_Pronoun_Other__c" VARCHAR(255), 
	"Preferred_Pronoun__c" VARCHAR(255), 
	"RecordTypeId" VARCHAR(255), 
	"Referral_Details__c" VARCHAR(255), 
	"SEC_City__c" VARCHAR(255), 
	"SEC_Email__c" VARCHAR(255), 
	"SEC_First_Name__c" VARCHAR(255), 
	"SEC_Home_Phone__c" VARCHAR(255), 
	"SEC_Last_Name__c" VARCHAR(255), 
	"SEC_MI__c" VARCHAR(255), 
	"SEC_Mobile_Phone__c" VARCHAR(255), 
	"SEC_Other_Phone__c" VARCHAR(255), 
	"SEC_Suffix__c" VARCHAR(255), 
	"SEC_Zip__c" VARCHAR(255), 
	"SEC__c" VARCHAR(255), 
	"npe01__AlternateEmail__c" VARCHAR(255), 
	"npe01__HomeEmail__c" VARCHAR(255), 
	"npe01__PreferredPhone__c" VARCHAR(255), 
	"npe01__Preferred_Email__c" VARCHAR(255), 
	"npe01__Primary_Address_Type__c" VARCHAR(255), 
	"npe01__Private__c" VARCHAR(255), 
	"npe01__Secondary_Address_Type__c" VARCHAR(255), 
	"npe01__SystemAccountProcessor__c" VARCHAR(255), 
	"npe01__WorkEmail__c" VARCHAR(255), 
	"npe01__WorkPhone__c" VARCHAR(255), 
	"npo02__AverageAmount__c" VARCHAR(255), 
	"npo02__Best_Gift_Year_Total__c" VARCHAR(255), 
	"npo02__Best_Gift_Year__c" VARCHAR(255), 
	"npo02__FirstCloseDate__c" VARCHAR(255), 
	"npo02__Household_Naming_Order__c" VARCHAR(255), 
	"npo02__LargestAmount__c" VARCHAR(255), 
	"npo02__LastCloseDate__c" VARCHAR(255), 
	"npo02__LastMembershipAmount__c" VARCHAR(255), 
	"npo02__LastMembershipDate__c" VARCHAR(255), 
	"npo02__LastMembershipLevel__c" VARCHAR(255), 
	"npo02__LastMembershipOrigin__c" VARCHAR(255), 
	"npo02__LastOppAmount__c" VARCHAR(255), 
	"npo02__MembershipEndDate__c" VARCHAR(255), 
	"npo02__MembershipJoinDate__c" VARCHAR(255), 
	"npo02__Naming_Exclusions__c" VARCHAR(255), 
	"npo02__NumberOfClosedOpps__c" VARCHAR(255), 
	"npo02__NumberOfMembershipOpps__c" VARCHAR(255), 
	"npo02__OppAmount2YearsAgo__c" VARCHAR(255), 
	"npo02__OppAmountLastNDays__c" VARCHAR(255), 
	"npo02__OppAmountLastYear__c" VARCHAR(255), 
	"npo02__OppAmountThisYear__c" VARCHAR(255), 
	"npo02__OppsClosed2YearsAgo__c" VARCHAR(255), 
	"npo02__OppsClosedLastNDays__c" VARCHAR(255), 
	"npo02__OppsClosedLastYear__c" VARCHAR(255), 
	"npo02__OppsClosedThisYear__c" VARCHAR(255), 
	"npo02__SmallestAmount__c" VARCHAR(255), 
	"npo02__Soft_Credit_Last_Year__c" VARCHAR(255), 
	"npo02__Soft_Credit_This_Year__c" VARCHAR(255), 
	"npo02__Soft_Credit_Total__c" VARCHAR(255), 
	"npo02__Soft_Credit_Two_Years_Ago__c" VARCHAR(255), 
	"npo02__SystemHouseholdProcessor__c" VARCHAR(255), 
	"npo02__TotalMembershipOppAmount__c" VARCHAR(255), 
	"npo02__TotalOppAmount__c" VARCHAR(255), 
	"npsp__Deceased__c" VARCHAR(255), 
	"npsp__Do_Not_Contact__c" VARCHAR(255), 
	"npsp__Exclude_from_Household_Formal_Greeting__c" VARCHAR(255), 
	"npsp__Exclude_from_Household_Informal_Greeting__c" VARCHAR(255), 
	"npsp__Exclude_from_Household_Name__c" VARCHAR(255), 
	"npsp__First_Soft_Credit_Amount__c" VARCHAR(255), 
	"npsp__First_Soft_Credit_Date__c" VARCHAR(255), 
	"npsp__Largest_Soft_Credit_Amount__c" VARCHAR(255), 
	"npsp__Largest_Soft_Credit_Date__c" VARCHAR(255), 
	"npsp__Last_Soft_Credit_Amount__c" VARCHAR(255), 
	"npsp__Last_Soft_Credit_Date__c" VARCHAR(255), 
	"npsp__Number_of_Soft_Credits_Last_N_Days__c" VARCHAR(255), 
	"npsp__Number_of_Soft_Credits_Last_Year__c" VARCHAR(255), 
	"npsp__Number_of_Soft_Credits_This_Year__c" VARCHAR(255), 
	"npsp__Number_of_Soft_Credits_Two_Years_Ago__c" VARCHAR(255), 
	"npsp__Number_of_Soft_Credits__c" VARCHAR(255), 
	"npsp__Soft_Credit_Last_N_Days__c" VARCHAR(255), 
	"npsp__is_Address_Override__c" VARCHAR(255), 
	"AccountId" VARCHAR(255), 
	"ReportsToId" VARCHAR(255), 
	"npo02__Household__c" VARCHAR(255), 
	"npsp__Batch__c" VARCHAR(255), 
	"npsp__Current_Address__c" VARCHAR(255), 
	"npsp__Primary_Affiliation__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Contact_rt_mapping" (
	record_type_id VARCHAR(18) NOT NULL, 
	developer_name VARCHAR(255), 
	PRIMARY KEY (record_type_id)
);
CREATE TABLE "ContentVersion" (
	id INTEGER NOT NULL, 
	"ContentLocation" VARCHAR(255), 
	"IsAssetEnabled" VARCHAR(255), 
	"IsMajorVersion" VARCHAR(255), 
	"Origin" VARCHAR(255), 
	"SharingOption" VARCHAR(255), 
	"SharingPrivacy" VARCHAR(255), 
	"Title" VARCHAR(255), 
	"Type__c" VARCHAR(255), 
	"UserType__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "ContentVersion" VALUES(1,'S','True','True','H','A','N','Atlas-Assitance-Dogs-inline-clr-final','','');
INSERT INTO "ContentVersion" VALUES(2,'S','True','True','H','A','N','AtlasDogLogo','','');
INSERT INTO "ContentVersion" VALUES(3,'S','True','True','H','A','N','Screen Shot 2020-12-16 at 10.34.38 AM','','');
CREATE TABLE "Course_Master__c" (
	id INTEGER NOT NULL, 
	"Active__c" VARCHAR(255), 
	"Client_Course__c" VARCHAR(255), 
	"Common_Course__c" VARCHAR(255), 
	"Course_Code__c" VARCHAR(255), 
	"Course_Name__c" VARCHAR(255), 
	"Course_SIS__c" VARCHAR(255), 
	"Expected_Completion__c" VARCHAR(255), 
	"Facilitator_Course__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Section_SIS__c" VARCHAR(255), 
	"Term_SIS__c" VARCHAR(255), 
	"Trainer_Course__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Course_Master__c" VALUES(1,'False','False','False','I2','History and Types of Service Dogs','I2','','False','I2*I2-1*1','I2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(2,'True','False','False','D9','Fitness and Conditioning','D9','12.0','False','D9*D9-1*1','D9-1','1','False');
INSERT INTO "Course_Master__c" VALUES(3,'False','False','False','D9','Fitness and Conditioning','D9','','False','D9*D9-2*1','D9-2','1','False');
INSERT INTO "Course_Master__c" VALUES(4,'False','False','False','S1','Choice of Dog Appropriate for Service Work','S1','','False','S1*S1-1*1','S1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(5,'False','False','False','S4C','Disability Skills Training - Medical Alert and Response Tasks','S4C','','True','S4C*S4C-1*1','S4C-1','1','False');
INSERT INTO "Course_Master__c" VALUES(6,'False','False','False','S4D','Disability Skills Training - Psychiatric and Cognitive Tasks','S4D','','False','S4D*S4D-1*1','S4D-1','1','False');
INSERT INTO "Course_Master__c" VALUES(7,'False','False','False','S5','Becoming a working team','S5','','False','S5*S5-1*1','S5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(8,'True','False','False','I1','Introduction to Atlas Assistance Dogs','I1','12.0','False','I1*I1-1*1','I1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(9,'False','False','False','I3','Positive training - myths and facts','I3','','False','I3*I3-1*1','I3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(10,'True','False','False','TO-P1','Common Learning Styles and Teaching Skills Testout','P1testout','12.0','False','P1testout*P1testout-1*1','P1testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(11,'True','False','False','TO-P2','Communication, Listening, Interpersonal Skills Testout','P3testout','12.0','False','P3testout*P3testout-1*1','P3testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(12,'True','False','False','TO-P3','Confidentiality and Professionalism Testout','P5testout','12.0','False','P5testout*P5testout-1*1','P5testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(13,'True','False','False','P1','Common Learning Styles and Teaching Skills','P1','12.0','False','P1*P1-1*1','P1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(14,'True','False','False','P1','Common Learning Styles and Teaching Skills','P1','12.0','False','P1*P1-2*1','P1-2','1','False');
INSERT INTO "Course_Master__c" VALUES(15,'True','False','False','P2','Ethical Principles and Behaviors When Training','P2','12.0','False','P2*P2-1*1','P2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(16,'True','False','False','P2','Ethical Principles and Behaviors When Training','P2','12.0','False','P2*P2-2*1','P2-2','1','False');
INSERT INTO "Course_Master__c" VALUES(17,'True','False','False','P3','Communication, Listening, Interpersonal Skills','P3','12.0','False','P3*P3-1*1','P3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(18,'True','False','False','P3','Communication, Listening, Interpersonal Skills','P3','12.0','False','P3*P3-2*1','P3-2','1','False');
INSERT INTO "Course_Master__c" VALUES(19,'True','False','False','P4','Planning and Setting Up Training Sessions','P4','12.0','False','P4*P4-1*1','P4-1','1','False');
INSERT INTO "Course_Master__c" VALUES(20,'True','False','False','P4','Planning and Setting Up Training Sessions','P4','12.0','False','P4*P4-2*1','P4-2','1','False');
INSERT INTO "Course_Master__c" VALUES(21,'True','False','False','P5','Confidentiality and Professionalism','P5','12.0','False','P5*P5-1*1','P5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(22,'True','False','False','P5','Confidentiality and Professionalism','P5','12.0','False','P5*P5-2*1','P5-2','1','False');
INSERT INTO "Course_Master__c" VALUES(23,'True','False','False','D1','Animal Learning Theory','D1','12.0','False','D1*D1-2*1','D1-2','1','False');
INSERT INTO "Course_Master__c" VALUES(24,'True','False','False','D1','Animal Learning Theory','D1','12.0','False','D1*D1-1*1','D1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(25,'True','False','False','D2','Dog Development and Physiology','D2','12.0','False','D2*D2-1*1','D2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(26,'True','False','False','D3','Puppy Socialization and Rearing','D3','12.0','False','D3*D3-1*1','D3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(27,'True','False','False','D4','Dog Body Language and Communication','D4','12.0','False','D4*D4-1*1','D4-1','1','False');
INSERT INTO "Course_Master__c" VALUES(28,'True','False','False','D4','Dog Body Language and Communication','D4','12.0','False','D4*D4-2*1','D4-2','1','False');
INSERT INTO "Course_Master__c" VALUES(29,'True','False','False','D5','Problem Solving of Common Behavioral Issues','D5','12.0','False','D5*D5-1*1','D5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(30,'True','False','False','D6','Dog Health, Maintenance, and Basic Preventative Care','D6','12.0','False','D6*D6-1*1','D6-1','1','False');
INSERT INTO "Course_Master__c" VALUES(31,'True','False','False','D6','Dog Health, Maintenance, and Basic Preventative Care','D6','12.0','False','D6*D6-2*1','D6-2','1','False');
INSERT INTO "Course_Master__c" VALUES(32,'True','False','False','D7','Methods and Use of Training Equipment','D7','12.0','False','D7*D7-1*1','D7-1','1','False');
INSERT INTO "Course_Master__c" VALUES(33,'True','False','False','D7','Methods and Use of Training Equipment','D7','12.0','False','D7*D7-2*1','D7-2','1','False');
INSERT INTO "Course_Master__c" VALUES(34,'True','False','False','D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions','D8','12.0','False','D8*D8-1*1','D8-1','1','False');
INSERT INTO "Course_Master__c" VALUES(35,'True','False','False','D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions','D8','12.0','False','D8*D8-2*1','D8-2','1','False');
INSERT INTO "Course_Master__c" VALUES(36,'True','False','False','TO-D1','Animal Learning Theory Testout','D1testout','12.0','False','D1testout*D1testout-1*1','D1testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(37,'True','False','False','TO-D2','Dog Development and Physiology Testout','D2testout','12.0','False','D2testout*D2testout-1*1','D2testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(38,'True','False','False','TO-D3','Puppy Socialization and Rearing Testout','D3testout','12.0','False','D3testout*D3testout-1*1','D3testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(39,'True','False','False','TO-D4','Dog Body Language and Communication Testout','D4testout','12.0','False','D4testout*D4testout-1*1','D4testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(40,'True','False','False','TO-D5','Problem Solving of Common Behavioral Issues Testout','D5testout','12.0','False','D5testout*D5testout-1*1','D5testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(41,'True','False','False','TO-D6','Dog Health, Maintenance, and Basic Preventative Care Testout','D6testout','12.0','False','D6testout*D6testout-1*1','D6testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(42,'True','False','False','TO-D7','Methods and Use of Training Equipment Testout','D7testout','12.0','False','D7testout*D7testout-1*1','D7testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(43,'True','False','False','TO-D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions Testout','D8testout','12.0','False','D8testout*D8testout-1*1','D8testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(44,'True','False','False','S2','The Americans with Disabilities Act and Relevant Laws','S2','12.0','False','S2*S2-1*1','S2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(45,'True','False','False','S2','The Americans with Disabilities Act and Relevant Laws','S2','12.0','False','S2*S2-2*1','S2-2','1','False');
INSERT INTO "Course_Master__c" VALUES(46,'True','False','False','S3A','Understanding Disabilities','S3A','12.0','False','S3A*S3A-1*1','S3A-1','1','False');
INSERT INTO "Course_Master__c" VALUES(47,'True','False','False','S3A','Understanding Disabilities','S3A','12.0','True','S3A*S3A-2*1','S3A-2','1','False');
INSERT INTO "Course_Master__c" VALUES(48,'True','False','False','S3B','How to Be a Successful Trainer When Working with Clients with Disabilities','S3B','12.0','True','S3B*S3B-1*1','S3B-1','1','False');
INSERT INTO "Course_Master__c" VALUES(49,'True','False','True','S4A','Disability Skills Training - Introduction and Foundational Skills','S4A','12.0','True','S4A*S4A-1*1','S4A-1','1','False');
INSERT INTO "Course_Master__c" VALUES(50,'True','False','False','S4A','Disability Skills Training - Introduction and Foundational Skills','S4A','12.0','True','S4A*S4A-2*1','S4A-2','1','False');
INSERT INTO "Course_Master__c" VALUES(51,'True','False','True','S3B','How to Be a Successful Trainer When Working with Clients with Disabilities','S3B','12.0','False','S3B*S3B-2*1','S3B-2','1','True');
INSERT INTO "Course_Master__c" VALUES(52,'True','False','False','S4B','Disability Skills Training - Balance and Mobility Tasks','S4B','12.0','True','S4B*S4B-1*1','S4B-1','1','False');
INSERT INTO "Course_Master__c" VALUES(53,'True','False','False','S6','Sweet Snoopers Scent Detection for Diabetes and Medical Alert Dogs','S6','12.0','False','S6*S6-1*1','S6-1','1','False');
INSERT INTO "Course_Master__c" VALUES(54,'True','False','False','S7','Developing Your Service Dog Program','S7','12.0','False','S7*S7-1*1','S7-1','1','False');
INSERT INTO "Course_Master__c" VALUES(55,'True','False','False','S8','Atlas'' Public Access Test','S8','12.0','False','S8*S8-1*1','S8-1','1','False');
INSERT INTO "Course_Master__c" VALUES(56,'True','False','False','F2','True Colors','F2','12.0','False','F2*F2-1*1','F2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(57,'True','False','False','S8','Atlas'' Public Access Test','S8','12.0','False','S8*S8-2*1','S8-2','1','False');
INSERT INTO "Course_Master__c" VALUES(58,'True','False','False','F1','Team Facilitator Program','F1','12.0','False','F1*F1-1*1','F1-1','1','False');
CREATE TABLE "Course__c" (
	id INTEGER NOT NULL, 
	"Course_Completed__c" VARCHAR(255), 
	"Course_Title2__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Contact__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Courses_Taken__c" (
	id INTEGER NOT NULL, 
	"Assigned_Date__c" VARCHAR(255), 
	"Course_Completion_Date__c" VARCHAR(255), 
	"Expected_Completion_Date__c" VARCHAR(255), 
	"Status__c" VARCHAR(255), 
	"Account__c" VARCHAR(255), 
	"Course__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "Dog__c" (
	id INTEGER NOT NULL, 
	"Activation_Date__c" VARCHAR(255), 
	"Active__c" VARCHAR(255), 
	"Breed__c" VARCHAR(255), 
	"Date_of_Birth__c" VARCHAR(255), 
	"Deceased__c" VARCHAR(255), 
	"Dog_Certified__c" VARCHAR(255), 
	"Dog_Status__c" VARCHAR(255), 
	"Gender__c" VARCHAR(255), 
	"Health_Check_Failed_Dog_Accepted__c" VARCHAR(255), 
	"Health_Check_Note__c" VARCHAR(255), 
	"Latest_Physical_Exam_Outcome__c" VARCHAR(255), 
	"Microchip_Number__c" VARCHAR(255), 
	"Most_Recent_Distemper_Vaccine__c" VARCHAR(255), 
	"Most_Recent_Hepatitis_Vaccine__c" VARCHAR(255), 
	"Most_Recent_Parainfluenza_Vaccine__c" VARCHAR(255), 
	"Most_Recent_Parvovirus_Vaccine__c" VARCHAR(255), 
	"Most_Recent_Physical_Exam__c" VARCHAR(255), 
	"Most_Recent_Rabies_Vaccine__c" VARCHAR(255), 
	"Name" VARCHAR(255), 
	"Spayed_Neutered__c" VARCHAR(255), 
	"Vet_Address1__c" VARCHAR(255), 
	"Vet_Address2__c" VARCHAR(255), 
	"Vet_City__c" VARCHAR(255), 
	"Vet_Clinic_Name__c" VARCHAR(255), 
	"Vet_Email__c" VARCHAR(255), 
	"Vet_Name__c" VARCHAR(255), 
	"Vet_Phone__c" VARCHAR(255), 
	"Vet_State__c" VARCHAR(255), 
	"Vet_Zip_Code__c" VARCHAR(255), 
	"Dog_Owner__c" VARCHAR(255), 
	"Replaced_by_dog__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Dog__c" VALUES(1,'2020-06-27','True','husky','2019-02-26','False','False','','Male','','','','wet4-4333','2020-05-27','2020-05-20','2020-06-07','2020-06-16','2020-06-30','2020-06-15','evi','True','','','','','','testVet','','','','','');
INSERT INTO "Dog__c" VALUES(2,'','False','Alcassian','2019-01-01','False','False','','Male','','','','','','','','','','','Ruby1','False','','','','Vet1','','Vet1','','','','','');
INSERT INTO "Dog__c" VALUES(3,'','False','Alcassian','2019-05-01','False','False','','Male','','','','m12345','2020-07-08','2020-07-08','2020-07-08','2020-07-08','2020-07-08','2020-07-08','Ruby','False','','','','RubysVet','','RubysVet','','','','','');
INSERT INTO "Dog__c" VALUES(4,'','True','','','False','False','','','','','','Chip124','','','','','','','Dog Test1','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(5,'','True','Cleitn','2018-04-18','False','False','','Male','','','','ClientName check','2020-05-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','Dog ClientName','False','wtw','wt2','Pleasanton','Client Name check','','Vet Client','','CA','','','');
INSERT INTO "Dog__c" VALUES(6,'','True','Test Breed','2018-04-18','False','False','','Male','','','','TEW4545232WET','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','Dog4','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(7,'','True','wtw','2018-04-18','False','False','','Male','','','','4t3438-02','','','','','','','Dog4','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(8,'','True','B11','2018-04-18','False','False','','Male','','sample notes2','','B24325','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','FB Test11','True','42t24','24t24','Plasawon','tt2y42','','V14252','','CA','','','');
INSERT INTO "Dog__c" VALUES(9,'','False','Health','2018-04-18','False','False','','Male','','Sample notes','','Healthcheck','','','','','2020-04-30','2020-04-17','Test for Health Care Test not Pass','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(10,'','True','wrtwrt','2018-04-18','False','False','','Male','','','','TEW4545232WET5','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-17','FB Test5','True','Wtwtw','rwtwt','Dublin','Flow Check Clinic','','Flow Check Clinic Vet','','CA','','','');
INSERT INTO "Dog__c" VALUES(11,'','True','eqrqt','2018-04-18','False','False','','Male','','Sample notes','','wtwramesr24','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','FB Test7','True','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(12,'','False','Golden Retriever','2004-05-07','False','False','','Female','','','','10','2020-04-25','2020-04-30','2020-04-15','2020-06-19','2020-07-14','2020-10-07','Saanvi','True','','','','','','Ramesh Immadi','','','','','');
INSERT INTO "Dog__c" VALUES(13,'','False','Test Breed','2019-02-01','False','False','','Male','','','','wew4-24riwrp','','','','','','','DOG DoB not qualified','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(14,'','True','FB Test4','2018-04-18','False','False','','Male','','','','FB w43tj404','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','FB Test4','True','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(15,'','True','wtw','2018-04-18','False','False','','Male','','','','12425STWW','','','','','','','Dog2','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(16,'','False','wtw','2018-04-18','False','False','','Male','','Sample text','','wet2t24','','','','','','2020-04-17','DOG Accepted on HC Failured','False','Arronia Ct','','Pleasanton','Flow Check Clinic','','vt3','','','','','');
INSERT INTO "Dog__c" VALUES(17,'2019-08-13','True','Happy','2018-04-18','False','True','','Male','','','','WTW13243','2020-04-22','2020-04-29','2020-04-07','2020-04-22','2020-04-30','2020-04-29','Test For Happy Case','True','Arronia Ct','','Pleasanton','Flow Check Clinic','','vet3','','','','','');
INSERT INTO "Dog__c" VALUES(18,'','True','FB BT3','2018-04-18','False','False','','Male','','','','FB Test3 34t4334034','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','FB Test3','True','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(19,'','True','FB Test2','2018-04-14','False','False','','Male','','','','FB @#$^%$$&$^$8568','','','','','','','FB Test1','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(20,'','False','24','2020-04-01','False','False','','Male','','','','2452442','','','','','','','DOG DoB not qualified 2','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(21,'','False','wtwe','2018-04-18','False','False','','Male','','','','eewte-34','2020-04-22','2020-04-30','2020-04-23','2020-04-22','2020-04-30','2020-04-29','Dog1401','True','2010 Crow Canyon Place','Suite #100','San Ramon','Flow Check Clinic','','vt3','','','','','');
INSERT INTO "Dog__c" VALUES(22,'2020-06-26','True','','','False','False','','Male','','','','1223242','2020-07-22','2020-12-16','2021-02-25','2020-10-21','','2020-09-09','RamClient Dog','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(23,'2020-04-17','True','labradoodle','2018-04-12','False','False','','Male','','','','tweRTEW','2020-04-30','2020-04-30','2020-04-30','2020-04-30','2020-04-30','2020-04-30','reid','True','','','','','','juj','','','','','');
INSERT INTO "Dog__c" VALUES(24,'','False','wt242','2020-04-01','False','False','','Male','','','','24242040','','','','','','','DoB failed','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(25,'','False','','2017-08-02','False','False','','','','','','WERW','','','','','','','Dog R','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(26,'','False','rwtwtrw','2017-01-02','False','False','Reject due to health check failure','Male','','','','245252','','','','','','','Gog2','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(27,'','False','Test Breed','2020-04-01','False','False','','Female','','','','240348971=wr','','','','','','','16 Dog with DoB validation Fail','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(28,'','False','Test Breed','2018-04-18','False','False','','Male','','Sample Notes','','-=--00942/*/2','','','','','2020-04-30','2020-04-17','16 Dog Health Check failed but accepted','False','Arronia Ct','','Pleasanton','Flow Check Clinic','','vt3','','','','','');
INSERT INTO "Dog__c" VALUES(29,'2020-04-16','True','Test Breed','2018-04-18','False','False','','Female','','','','erewqq938','2020-04-22','','2020-04-23','2020-04-22','2020-04-30','2020-04-29','SFDC 16 Dog Happy Scenario','True','2826 Arronia Ct','','Pleasanton','wtwr','','Flow Check Clinict','','','','','');
INSERT INTO "Dog__c" VALUES(30,'2020-06-27','True','4343','2018-04-18','False','False','','Male','','','','wet4-4391','2020-08-25','2021-04-30','2021-04-30','2021-04-22','2020-04-30','2021-04-29','16 Dog Happy','True','2826 Arronia Ct','','Pleasanton','Flow Check Clinic','','vt3','','','','','');
INSERT INTO "Dog__c" VALUES(31,'','False','','2018-04-18','False','True','','Male','','Sample notes saying not accepting','','eww212','','','','','','2020-07-16','16 Dog Health Check failed and not accepted','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(32,'2019-08-01','False','','2015-04-01','False','False','','Male','','','','2349577','2020-03-04','2020-04-01','2020-04-01','2020-04-01','','2020-04-01','Boop','True','','','','','','Dr Evans','','','','','');
INSERT INTO "Dog__c" VALUES(33,'2020-04-21','True','Golden','2016-04-01','False','False','','Male','','','','sjeotg345','2020-04-30','2020-04-30','2020-04-30','2020-04-30','2020-04-30','2020-04-30','Jolly','True','','','','','','Dr Kay','','','','','');
INSERT INTO "Dog__c" VALUES(34,'','False','wrtwr','2018-04-30','False','False','','Male','','','','','','','','','','','Test Dog420','True','','','','','','Vet Flow Test','','','','','');
INSERT INTO "Dog__c" VALUES(35,'','False','','2018-04-18','False','False','','Male','','Sample','','','','','','','','','SFDC 16 Health Check failed dog accepted','False','2826 Arronia Ct','','Pleasanton','wtwr','','Flow Check Clinict','','','','','');
INSERT INTO "Dog__c" VALUES(36,'','False','wet','2020-04-01','False','False','','Female','','','','3435924','','','','','','','SFDC 16 Dog DoB V not met','False','','','','','','','','','','','');
INSERT INTO "Dog__c" VALUES(37,'2020-04-16','True','Labrador Retreiver','2013-04-12','False','False','','Male','','','','243424','2020-04-24','2020-05-21','2021-04-01','2020-04-17','2020-05-22','2021-04-15','Theodore','True','','dsad','','Elliott Bay Animal Hospital','','Heather Weihl','','','','','');
INSERT INTO "Dog__c" VALUES(38,'','False','Golden Retriever','2019-12-01','False','False','','Male','','','','fo34adr','','','','','','','Ruffus','True','','','','','','','','','','','');
CREATE TABLE "Lead" (
	id INTEGER NOT NULL, 
	"Company" VARCHAR(255), 
	"FirstName" VARCHAR(255), 
	"Follow_Up_Date__c" VARCHAR(255), 
	"IsConverted" VARCHAR(255), 
	"IsUnreadByOwner" VARCHAR(255), 
	"LastName" VARCHAR(255), 
	"Status" VARCHAR(255), 
	"npe01__Preferred_Email__c" VARCHAR(255), 
	"npe01__Preferred_Phone__c" VARCHAR(255), 
	"npsp__CompanyCity__c" VARCHAR(255), 
	"npsp__CompanyCountry__c" VARCHAR(255), 
	"npsp__CompanyPostalCode__c" VARCHAR(255), 
	"npsp__CompanyState__c" VARCHAR(255), 
	"npsp__CompanyStreet__c" VARCHAR(255), 
	"npsp__Batch__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "npo02__Household__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"npo02__Addressee__c" VARCHAR(255), 
	"npo02__Always_Anonymous__c" VARCHAR(255), 
	"npo02__AverageAmount__c" VARCHAR(255), 
	"npo02__Best_Gift_Year_Total__c" VARCHAR(255), 
	"npo02__Best_Gift_Year__c" VARCHAR(255), 
	"npo02__FirstCloseDate__c" VARCHAR(255), 
	"npo02__Formal_Greeting__c" VARCHAR(255), 
	"npo02__HouseholdEmail__c" VARCHAR(255), 
	"npo02__HouseholdPhone__c" VARCHAR(255), 
	"npo02__Household_ID__c" VARCHAR(255), 
	"npo02__Informal_Greeting__c" VARCHAR(255), 
	"npo02__LargestAmount__c" VARCHAR(255), 
	"npo02__LastCloseDate__c" VARCHAR(255), 
	"npo02__LastMembershipAmount__c" VARCHAR(255), 
	"npo02__LastMembershipDate__c" VARCHAR(255), 
	"npo02__LastMembershipLevel__c" VARCHAR(255), 
	"npo02__LastMembershipOrigin__c" VARCHAR(255), 
	"npo02__LastOppAmount__c" VARCHAR(255), 
	"npo02__MailingCity__c" VARCHAR(255), 
	"npo02__MailingCountry__c" VARCHAR(255), 
	"npo02__MailingPostalCode__c" VARCHAR(255), 
	"npo02__MailingState__c" VARCHAR(255), 
	"npo02__MailingStreet__c" VARCHAR(255), 
	"npo02__MembershipEndDate__c" VARCHAR(255), 
	"npo02__MembershipJoinDate__c" VARCHAR(255), 
	"npo02__NumberOfClosedOpps__c" VARCHAR(255), 
	"npo02__NumberOfMembershipOpps__c" VARCHAR(255), 
	"npo02__OppAmount2YearsAgo__c" VARCHAR(255), 
	"npo02__OppAmountLastNDays__c" VARCHAR(255), 
	"npo02__OppAmountLastYear__c" VARCHAR(255), 
	"npo02__OppAmountThisYear__c" VARCHAR(255), 
	"npo02__OppsClosed2YearsAgo__c" VARCHAR(255), 
	"npo02__OppsClosedLastNDays__c" VARCHAR(255), 
	"npo02__OppsClosedLastYear__c" VARCHAR(255), 
	"npo02__OppsClosedThisYear__c" VARCHAR(255), 
	"npo02__SYSTEM_CUSTOM_NAMING__c" VARCHAR(255), 
	"npo02__SmallestAmount__c" VARCHAR(255), 
	"npo02__TotalMembershipOppAmount__c" VARCHAR(255), 
	"npo02__TotalOppAmount__c" VARCHAR(255), 
	"npsp__Number_of_Household_Members__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "npsp__Address__c" (
	id INTEGER NOT NULL, 
	"npsp__API_Response__c" VARCHAR(255), 
	"npsp__Address_Type__c" VARCHAR(255), 
	"npsp__Administrative_Area__c" VARCHAR(255), 
	"npsp__Ambiguous__c" VARCHAR(255), 
	"npsp__Congressional_District__c" VARCHAR(255), 
	"npsp__County_Name__c" VARCHAR(255), 
	"npsp__Default_Address__c" VARCHAR(255), 
	"npsp__Exclude_from_Updates__c" VARCHAR(255), 
	"npsp__Latest_End_Date__c" VARCHAR(255), 
	"npsp__Latest_Start_Date__c" VARCHAR(255), 
	"npsp__MailingCity__c" VARCHAR(255), 
	"npsp__MailingCountry__c" VARCHAR(255), 
	"npsp__MailingPostalCode__c" VARCHAR(255), 
	"npsp__MailingState__c" VARCHAR(255), 
	"npsp__MailingStreet2__c" VARCHAR(255), 
	"npsp__MailingStreet__c" VARCHAR(255), 
	"npsp__NCOA_Evaluation_Date__c" VARCHAR(255), 
	"npsp__NCOA_Result_Code__c" VARCHAR(255), 
	"npsp__Pre_Verification_Address__c" VARCHAR(255), 
	"npsp__Seasonal_End_Day__c" VARCHAR(255), 
	"npsp__Seasonal_End_Month__c" VARCHAR(255), 
	"npsp__Seasonal_Start_Day__c" VARCHAR(255), 
	"npsp__Seasonal_Start_Month__c" VARCHAR(255), 
	"npsp__State_Lower_District__c" VARCHAR(255), 
	"npsp__State_Upper_District__c" VARCHAR(255), 
	"npsp__Verification_Status__c" VARCHAR(255), 
	"npsp__Verified_Date__c" VARCHAR(255), 
	"npsp__Verified__c" VARCHAR(255), 
	"npsp__Household_Account__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "npsp__Batch__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"npsp__Batch_Status__c" VARCHAR(255), 
	"npsp__Description__c" VARCHAR(255), 
	"npsp__Number_of_Items__c" VARCHAR(255), 
	"npsp__Object_Name__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "npsp__Engagement_Plan_Template__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"npsp__Automatically_Update_Child_Task_Due_Date__c" VARCHAR(255), 
	"npsp__Default_Assignee__c" VARCHAR(255), 
	"npsp__Description__c" VARCHAR(255), 
	"npsp__Reschedule_To__c" VARCHAR(255), 
	"npsp__Skip_Weekends__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
CREATE TABLE "npsp__Level__c" (
	id INTEGER NOT NULL, 
	"Name" VARCHAR(255), 
	"npsp__Active__c" VARCHAR(255), 
	"npsp__Description__c" VARCHAR(255), 
	"npsp__Level_Field__c" VARCHAR(255), 
	"npsp__Maximum_Amount__c" VARCHAR(255), 
	"npsp__Minimum_Amount__c" VARCHAR(255), 
	"npsp__Previous_Level_Field__c" VARCHAR(255), 
	"npsp__Source_Field__c" VARCHAR(255), 
	"npsp__Target__c" VARCHAR(255), 
	"npsp__Engagement_Plan_Template__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
COMMIT;
