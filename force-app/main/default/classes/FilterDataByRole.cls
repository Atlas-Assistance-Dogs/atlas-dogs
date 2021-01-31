public with sharing class FilterDataByRole{
	@AuraEnabled(cacheable = true)
	public static List<Account> fetchAccounts(){

		return [SELECT Id, Name
		        From Account
		        Where Facilitator__c = true
		        WITH SECURITY_ENFORCED
		        ORDER BY Name];
	}

	@AuraEnabled(cacheable = true)
	public static List<Course_Master__c> fetchCourses(String roles){
		List<Course_Master__c> lst = new List<Course_Master__c>();
		// List<String> roleList = roles.slice(',');
		List<String> queryList = new List<String>();
		String queryString;
		String finalQuery;

		if (roles != null){
			if (roles.contains('Facilitator')){
				queryList.add('Facilitator_Course__c = true ');
			}
			if (roles.contains('Client')){
				queryList.add('Client_Course__c = true ');
			}
			if (roles.contains('Trainer')){
				queryList.add('Trainer_Course__c = true ');
			}

			if (queryList.size() > 0){
				queryString = String.join(queryList, ' OR ');
			}
			system.debug('***********************' + queryString);

			finalQuery = ' SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Active__c = true AND ( ' + queryString + ' ) ' + ' ORDER BY Name';

			system.debug('***********Final************' + finalQuery);
			lst = Database.query(finalQuery);

		}

		if (lst.size() > 0){
			return lst;
		} else{
			return null;
		}

		/*
		 if ( roles != null ) {
		 System.debug('Roles' + roles);

		 if(roles.contains('Facilitator')){
		 System.debug('Roles 2' + roles);
		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Facilitator_Course__c = true AND Active__c = true WITH SECURITY_ENFORCED ORDER BY Name ];
		 }

		 if(roles.contains('Trainer')){
		 System.debug('Roles 3' + roles);
		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Trainer_Course__c = true AND Active__c = true WITH SECURITY_ENFORCED ORDER BY Name ];
		 }

		 if(roles.contains('Client')){

		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c Where Client_Course__c = true AND Active__c = true WITH SECURITY_ENFORCED ORDER BY Name ];
		 }

		 if(roles.contains('Facilitator') && roles.contains('Client')){
		 System.debug('Roles 4' + roles);

		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c
		 Where (Facilitator_Course__c = true OR Client_Course__c = true ) AND Active__c = true
		 ORDER BY Name ];
		 }

		 if(roles.contains('Facilitator') && roles.contains('Trainer')){


		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c
		 Where ( Facilitator_Course__c = true OR Trainer_Course__c = true ) AND Active__c = true
		 ORDER BY Name ];
		 }

		 if(roles.contains('Client') && roles.contains('Trainer')){


		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c
		 Where Client_Course__c = true AND Trainer_Course__c = true AND Active__c = true
		 ORDER BY Name ];
		 }

		 if(roles.contains('Client') && roles.contains('Trainer') && roles.contains('Facilitator')){

		 lst = [SELECT Id, Name, Course_Code__c, Course_Name__c From Course_Master__c
		 Where ( Client_Course__c = true OR Trainer_Course__c = true OR Facilitator_Course__c = true ) AND Active__c = true
		 ORDER BY Name ];
		 }

		 return lst;

		 } else {
		 return null;
		 }
		 */
	}

	@AuraEnabled(cacheable = true)
	public static List<Courses_Taken__c> fetchCourseDetails(Id course){

		return [SELECT Id, Course_Name__c, Account__c, Account_Name__c, Assigned_Date__c, Expected_Completion_Date__c, Course_Completion_Date__c, Course__r.Facilitator_Course__c
		        From Courses_Taken__c
		        Where Course__c = :course AND Course__r.Facilitator_Course__c = true];

		/*return [SELECT Id, Course_Name__c, Account__c, Account__r.Name, Assigned_Date__c, Expected_Completion_Date__c, Course_Completion_Date__c, Course_Name__r.Facilitator_Course__c
		 From Courses_Taken__c Where Course_Name__c = 'a1Bg0000004hoiYEAQ' AND Course_Name__r.Facilitator_Course__c = true];*/
	}

	//repSelectedCourses({lstConIds: this.selectedRecords, selectedAccount : this.account, selectedCourses: this._selectedCourses })
	@AuraEnabled
	public static void repSelectedCourses(List<Id> lstCourseIds){

		List<Courses_Taken__c> lst = [Select Id, Status__c
		                              from Courses_Taken__c
		                              where Id IN :lstCourseIds];
		// List<Courses_Taken__c> lst = [Select Id, Status__c from Courses_Taken__c where Id = 'a1Cc000000524VAEAY'];
		List<Courses_Taken__c> listToUpdate = new List<Courses_Taken__c>();

		if (lst != null){

			for (Courses_Taken__c c : lst){

				c.Status__c = 'Replaced';
				listToUpdate.add(c);

			}

			update listToUpdate;

		}

		return;
	}

	@AuraEnabled
	public static void addNewCourses(String accountId, List<Id> courseIds){

		// Add neww course to the Account here, need AccountId and courseId;

		Account acc = [SELECT Id, Name
		               FROM Account
		               WHERE ID = :accountId
		               LIMIT 1];
		//Account acc = [SELECT Id, Name FROM Account WHERE ID = '001g000002I37jlAAB' LIMIT 1];


		List<Course_Master__c> assignedCoursesList = [SELECT Id
		                                              FROM Course_Master__c
		                                              WHERE ID IN :courseIds];

		List<Courses_Taken__c> ListToAdd = new List<Courses_Taken__c>();

		for (Course_Master__c course : assignedCoursesList){

			Courses_Taken__c cr = new Courses_Taken__c();
			cr.Course__c = course.Id;
			cr.Account__c = acc.Id;
			cr.Assigned_Date__c = system.today();

			ListToAdd.add(cr);
		}

		insert ListToAdd;

		return;
	}
}