BEGIN TRANSACTION;
CREATE TABLE "CategoryRule__c" (
	id INTEGER NOT NULL, 
	"Category__c" VARCHAR(255), 
	"Object__c" VARCHAR(255), 
	"Position__c" VARCHAR(255), 
	PRIMARY KEY (id)
);
INSERT INTO "CategoryRule__c" VALUES(1,'Dog','Dog','');
INSERT INTO "CategoryRule__c" VALUES(2,'Client','Team','');
INSERT INTO "CategoryRule__c" VALUES(3,'TeamDog','Team','');
INSERT INTO "CategoryRule__c" VALUES(4,'ADSiM','Contact','');
INSERT INTO "CategoryRule__c" VALUES(5,'Standalone','Contact','');
INSERT INTO "CategoryRule__c" VALUES(6,'Board','Contact','Board Member');
INSERT INTO "CategoryRule__c" VALUES(7,'Na','Contact','');
INSERT INTO "CategoryRule__c" VALUES(8,'Facilitator','Contact','Team Facilitator');
INSERT INTO "CategoryRule__c" VALUES(9,'Facilitator','Contact','Team Facilitator Lead');
INSERT INTO "CategoryRule__c" VALUES(10,'Puppy','Contact','Puppy Raiser');
INSERT INTO "CategoryRule__c" VALUES(11,'Staff','Contact','Staff');
INSERT INTO "CategoryRule__c" VALUES(12,'Trainer','Contact','Trainer');
INSERT INTO "CategoryRule__c" VALUES(13,'Volunteer','Contact','Volunteer');
COMMIT;
