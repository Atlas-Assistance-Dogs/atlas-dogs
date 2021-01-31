public with sharing class AddCourses{
	@AuraEnabled
	public static void addSelectedCourses(List<String> roles, List<Id> selectedCourses){

		String criteria;
		List<Course_Master__c> lst = new List<Course_Master__c>();

		if (!roles.contains('Client') && !roles.contains('Trainer') && roles.contains('Facilitator')){


			criteria = ' Facilitator__c = true';

			//lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Facilitator_Course__c = true AND Active__c = true LIMIT 1 ];
		}

		if (!roles.contains('Client') && roles.contains('Trainer') && !roles.contains('Facilitator')){

			criteria = ' Trainer__c = true';


			//lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Trainer_Course__c = true AND Active__c = true  ];
		}

		if (roles.contains('Client') && !roles.contains('Trainer') && !roles.contains('Facilitator')){

			criteria = ' Client__c = true ';


			//lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Client_Course__c = true AND Active__c = true  ];
		}

		if (roles.contains('Facilitator') && roles.contains('Client') && !roles.contains('Trainer')){

			criteria = ' Client__c = true AND Facilitator__c = true ';

		}

		if (roles.contains('Facilitator') && roles.contains('Trainer') && !roles.contains('Client')){

			criteria = ' Trainer__c = true AND Facilitator__c = true ';

		}

		if (roles.contains('Client') && roles.contains('Trainer') && !roles.contains('Facilitator')){

			criteria = ' Trainer__c = true AND Client__c = true ';

		}

		if (roles.contains('Client') && roles.contains('Trainer') && roles.contains('Facilitator')){

			criteria = ' Trainer__c = true AND Client__c = true AND Facilitator__c = true ';

		}


		// List<Account> accountList = [ SELECT Id FROM Account WHERE Client__c = true AND Facilitator__c = true ANd Id = '001g000002JR2BgAAL' LIMIT 1];

		String query = 'SELECT Id FROM Account WHERE ' + criteria;

		List<Account> accountList = Database.query(query);

		List<Course_Master__c> assignedCoursesList = [SELECT Id
		                                              FROM Course_Master__c
		                                              WHERE ID IN :selectedCourses];

		List<Courses_Taken__c> ListToUpdate = new List<Courses_Taken__c>();

		for (Account acc : accountList){

			for (Course_Master__c course : assignedCoursesList){

				Courses_Taken__c c = new Courses_Taken__c();
				c.Course__c = course.Id;
				c.Account__c = acc.Id;
				c.Assigned_Date__c = system.today();

				ListToUpdate.add(c);
			}

		}
		insert ListToUpdate;
		return;
	}
}