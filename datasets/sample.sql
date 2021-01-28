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
	"Facilitator_Interview_End_DateTime__c" VARCHAR(255), 
	"Facilitator_Interview_Notes__c" VARCHAR(255), 
	"Facilitator_Interview_Start_Date_Time__c" VARCHAR(255), 
	"Facilitator_Onboarding_Remainder_Date__c" VARCHAR(255), 
	"Facilitator_Preliminary_Interview_Date__c" VARCHAR(255), 
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
	"Facilitator_application_receipt_date__c" VARCHAR(255), 
	"Facilitator_application_received__c" VARCHAR(255), 
	"Facilitator_provision_details__c" VARCHAR(255), 
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
	"Volunteer_Role__c" VARCHAR(255), 
	"Volunteer_Status__c" VARCHAR(255), 
	"Volunteer__c" VARCHAR(255), 
	"Volunteer_provision_details__c" VARCHAR(255), 
	"Volunteer_remainder_date__c" VARCHAR(255), 
	"Volunteer_role_with_no_data_access__c" VARCHAR(255), 
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
	"MicrochipNumber__c" VARCHAR(255), 
	"ParentId" VARCHAR(255), 
	"Previous_Level__c" VARCHAR(255), 
	"Trainer_Name__c" VARCHAR(255), 
	"npe01__One2OneContact__c" VARCHAR(255), 
	"npsp__Batch__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Account" VALUES(1,'','','','','','','','False','','False','False','','','','','','','','','','','','','','','','','','False','','False','','','John','False','','Smith','False','','False','Smith Household','','','False','','','False','','','False','False','','','','','','','False','','','','False','','0.0','','','','','','','0.0','','0.0','','','','0.0','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','0.0','0.0','0.0','','False','','','','','','False','','','','','','','','','','','','','','','');
CREATE TABLE "Account_rt_mapping" (
	record_type_id VARCHAR(18) NOT NULL, 
	developer_name VARCHAR(255), 
	PRIMARY KEY (record_type_id)
);
INSERT INTO "Account_rt_mapping" VALUES('0121F000002mtjxQAA','HH_Account');
INSERT INTO "Account_rt_mapping" VALUES('0121F000002mtjyQAA','Organization');
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
INSERT INTO "Contact" VALUES(1,'','','','','','John','','','','','','','','','','','','','','','','','','','','','','','','Smith','','','','','','Sarah Jane','','','','','','','','','','','','','','','','','','','','','','','','','','','','','Home','Personal','','False','','','','','0.0','','','','','0.0','','0.0','','','','0.0','','','','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','0.0','','','','','','0.0','0.0','False','False','False','False','False','','','','','','','','','','','','0.0','False','1','','','','','');
CREATE TABLE "Contact_rt_mapping" (
	record_type_id VARCHAR(18) NOT NULL, 
	developer_name VARCHAR(255), 
	PRIMARY KEY (record_type_id)
);
INSERT INTO "Contact_rt_mapping" VALUES('0121F000002mvdFQAQ','Contact');
INSERT INTO "Contact_rt_mapping" VALUES('0121F000002mvdGQAQ','Contacts');
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
INSERT INTO "ContentVersion" VALUES(1,'S','True','True','H','A','N','Screen Shot 2020-12-16 at 10.34.38 AM','','');
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
INSERT INTO "Course_Master__c" VALUES(8,'False','False','False','I2','History and Types of Service Dogs','I2','','False','a0s1F0000016lyd','I2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(9,'True','False','False','D9','Fitness and Conditioning','D9','12.0','False','a0s1F0000016lye','D9-1','1','False');
INSERT INTO "Course_Master__c" VALUES(10,'False','False','False','D9','Fitness and Conditioning','D9','','False','a0s1F0000016lyf','D9-2','1','False');
INSERT INTO "Course_Master__c" VALUES(11,'False','False','False','S1','Choice of Dog Appropriate for Service Work','S1','','False','a0s1F0000016lyg','S1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(12,'False','False','False','S4C','Disability Skills Training - Medical Alert and Response Tasks','S4C','','True','a0s1F0000016lyh','S4C-1','1','False');
INSERT INTO "Course_Master__c" VALUES(13,'False','False','False','S4D','Disability Skills Training - Psychiatric and Cognitive Tasks','S4D','','False','a0s1F0000016lyi','S4D-1','1','False');
INSERT INTO "Course_Master__c" VALUES(14,'False','False','False','S5','Becoming a working team','S5','','False','a0s1F0000016lyj','S5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(15,'True','False','False','I1','Introduction to Atlas Assistance Dogs','I1','12.0','False','a0s1F0000016lyk','I1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(16,'False','False','False','I3','Positive training - myths and facts','I3','','False','a0s1F0000016lyl','I3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(17,'True','False','False','TO-P1','Common Learning Styles and Teaching Skills Testout','P1testout','12.0','False','a0s1F0000016lym','P1testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(18,'True','False','False','TO-P2','Communication, Listening, Interpersonal Skills Testout','P3testout','12.0','False','a0s1F0000016lyn','P3testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(19,'True','False','False','TO-P3','Confidentiality and Professionalism Testout','P5testout','12.0','False','a0s1F0000016lyo','P5testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(20,'True','False','False','P1','Common Learning Styles and Teaching Skills','P1','12.0','False','a0s1F0000016lyp','P1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(21,'True','False','False','P1','Common Learning Styles and Teaching Skills','P1','12.0','False','a0s1F0000016lyq','P1-2','1','False');
INSERT INTO "Course_Master__c" VALUES(22,'True','False','False','P2','Ethical Principles and Behaviors When Training','P2','12.0','False','a0s1F0000016lyr','P2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(23,'True','False','False','P2','Ethical Principles and Behaviors When Training','P2','12.0','False','a0s1F0000016lys','P2-2','1','False');
INSERT INTO "Course_Master__c" VALUES(24,'True','False','False','P3','Communication, Listening, Interpersonal Skills','P3','12.0','False','a0s1F0000016lyt','P3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(25,'True','False','False','P3','Communication, Listening, Interpersonal Skills','P3','12.0','False','a0s1F0000016lyu','P3-2','1','False');
INSERT INTO "Course_Master__c" VALUES(26,'True','False','False','P4','Planning and Setting Up Training Sessions','P4','12.0','False','a0s1F0000016lyv','P4-1','1','False');
INSERT INTO "Course_Master__c" VALUES(27,'True','False','False','P4','Planning and Setting Up Training Sessions','P4','12.0','False','a0s1F0000016lyw','P4-2','1','False');
INSERT INTO "Course_Master__c" VALUES(28,'True','False','False','P5','Confidentiality and Professionalism','P5','12.0','False','a0s1F0000016lyx','P5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(29,'True','False','False','P5','Confidentiality and Professionalism','P5','12.0','False','a0s1F0000016lyy','P5-2','1','False');
INSERT INTO "Course_Master__c" VALUES(30,'True','False','False','D1','Animal Learning Theory','D1','12.0','False','a0s1F0000016lyz','D1-1','1','False');
INSERT INTO "Course_Master__c" VALUES(31,'True','False','False','D1','Animal Learning Theory','D1','12.0','False','a0s1F0000016lz0','D1-2','1','False');
INSERT INTO "Course_Master__c" VALUES(32,'True','False','False','D2','Dog Development and Physiology','D2','12.0','False','a0s1F0000016lz1','D2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(33,'True','False','False','D3','Puppy Socialization and Rearing','D3','12.0','False','a0s1F0000016lz2','D3-1','1','False');
INSERT INTO "Course_Master__c" VALUES(34,'True','False','False','D4','Dog Body Language and Communication','D4','12.0','False','a0s1F0000016lz3','D4-1','1','False');
INSERT INTO "Course_Master__c" VALUES(35,'True','False','False','D4','Dog Body Language and Communication','D4','12.0','False','a0s1F0000016lz4','D4-2','1','False');
INSERT INTO "Course_Master__c" VALUES(36,'True','False','False','D5','Problem Solving of Common Behavioral Issues','D5','12.0','False','a0s1F0000016lz5','D5-1','1','False');
INSERT INTO "Course_Master__c" VALUES(37,'True','False','False','D6','Dog Health, Maintenance, and Basic Preventative Care','D6','12.0','False','a0s1F0000016lz6','D6-1','1','False');
INSERT INTO "Course_Master__c" VALUES(38,'True','False','False','D6','Dog Health, Maintenance, and Basic Preventative Care','D6','12.0','False','a0s1F0000016lz7','D6-2','1','False');
INSERT INTO "Course_Master__c" VALUES(39,'True','False','False','D7','Methods and Use of Training Equipment','D7','12.0','False','a0s1F0000016lz8','D7-1','1','False');
INSERT INTO "Course_Master__c" VALUES(40,'True','False','False','D7','Methods and Use of Training Equipment','D7','12.0','False','a0s1F0000016lz9','D7-2','1','False');
INSERT INTO "Course_Master__c" VALUES(41,'True','False','False','D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions','D8','12.0','False','a0s1F0000016lzA','D8-1','1','False');
INSERT INTO "Course_Master__c" VALUES(42,'True','False','False','D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions','D8','12.0','False','a0s1F0000016lzB','D8-2','1','False');
INSERT INTO "Course_Master__c" VALUES(43,'True','False','False','TO-D1','Animal Learning Theory Testout','D1testout','12.0','False','a0s1F0000016lzC','D1testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(44,'True','False','False','TO-D2','Dog Development and Physiology Testout','D2testout','12.0','False','a0s1F0000016lzD','D2testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(45,'True','False','False','TO-D3','Puppy Socialization and Rearing Testout','D3testout','12.0','False','a0s1F0000016lzE','D3testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(46,'True','False','False','TO-D4','Dog Body Language and Communication Testout','D4testout','12.0','False','a0s1F0000016lzF','D4testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(47,'True','False','False','TO-D5','Problem Solving of Common Behavioral Issues Testout','D5testout','12.0','False','a0s1F0000016lzG','D5testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(48,'True','False','False','TO-D6','Dog Health, Maintenance, and Basic Preventative Care Testout','D6testout','12.0','False','a0s1F0000016lzH','D6testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(49,'True','False','False','TO-D7','Methods and Use of Training Equipment Testout','D7testout','12.0','False','a0s1F0000016lzI','D7testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(50,'True','False','False','TO-D8','Dog Training Approaches Including Planning and Carrying Out Training Sessions Testout','D8testout','12.0','False','a0s1F0000016lzJ','D8testout-1','1','False');
INSERT INTO "Course_Master__c" VALUES(51,'True','False','False','S2','The Americans with Disabilities Act and Relevant Laws','S2','12.0','False','a0s1F0000016lzK','S2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(52,'True','False','False','S2','The Americans with Disabilities Act and Relevant Laws','S2','12.0','False','a0s1F0000016lzL','S2-2','1','False');
INSERT INTO "Course_Master__c" VALUES(53,'True','False','False','S3A','Understanding Disabilities','S3A','12.0','False','a0s1F0000016lzM','S3A-1','1','False');
INSERT INTO "Course_Master__c" VALUES(54,'True','False','False','S3A','Understanding Disabilities','S3A','12.0','True','a0s1F0000016lzN','S3A-2','1','False');
INSERT INTO "Course_Master__c" VALUES(55,'True','False','False','S3B','How to Be a Successful Trainer When Working with Clients with Disabilities','S3B','12.0','True','a0s1F0000016lzO','S3B-1','1','False');
INSERT INTO "Course_Master__c" VALUES(56,'True','False','True','S4A','Disability Skills Training - Introduction and Foundational Skills','S4A','12.0','True','a0s1F0000016lzP','S4A-1','1','False');
INSERT INTO "Course_Master__c" VALUES(57,'True','False','False','S4A','Disability Skills Training - Introduction and Foundational Skills','S4A','12.0','True','a0s1F0000016lzQ','S4A-2','1','False');
INSERT INTO "Course_Master__c" VALUES(58,'True','False','True','S3B','How to Be a Successful Trainer When Working with Clients with Disabilities','S3B','12.0','False','a0s1F0000016lzR','S3B-2','1','True');
INSERT INTO "Course_Master__c" VALUES(59,'True','False','False','S4B','Disability Skills Training - Balance and Mobility Tasks','S4B','12.0','True','a0s1F0000016lzS','S4B-1','1','False');
INSERT INTO "Course_Master__c" VALUES(60,'True','False','False','S6','Sweet Snoopers Scent Detection for Diabetes and Medical Alert Dogs','S6','12.0','False','a0s1F0000016lzT','S6-1','1','False');
INSERT INTO "Course_Master__c" VALUES(61,'True','False','False','S7','Developing Your Service Dog Program','S7','12.0','False','a0s1F0000016lzU','S7-1','1','False');
INSERT INTO "Course_Master__c" VALUES(62,'True','False','False','S8','Atlas'' Public Access Test','S8','12.0','False','a0s1F0000016lzV','S8-1','1','False');
INSERT INTO "Course_Master__c" VALUES(63,'True','False','False','F2','True Colors','F2','12.0','False','a0s1F0000016lzW','F2-1','1','False');
INSERT INTO "Course_Master__c" VALUES(64,'True','False','False','S8','Atlas'' Public Access Test','S8','12.0','False','a0s1F0000016lzX','S8-2','1','False');
INSERT INTO "Course_Master__c" VALUES(65,'True','False','False','F1','Team Facilitator Program','F1','12.0','False','a0s1F0000016lzY','F1-1','1','False');
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
	"Account_Name__c" VARCHAR(255), 
	"Course_Name__c" VARCHAR(255), 
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
	"DogOwner__c" VARCHAR(255), 
	"Replaced_by_dog__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "Dog__c" VALUES(1,'','False','','','False','False','','','No','','Pass','','','','','','','','Sandy','False','','','','','','','','','','','');
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
