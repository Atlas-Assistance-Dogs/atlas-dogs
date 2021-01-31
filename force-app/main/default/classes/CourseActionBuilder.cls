public with sharing class CourseActionBuilder{
	static Integer PAGE_SIZE = 10;
	@AuraEnabled(cacheable = true)
	public static pagedResult getAllAccounts(String searchKey, Integer pageNumber){

		String searchId = searchKey.trim();
		String searchCriteria = (String.isBlank(searchId) ? '%' : '%' + searchId + '%');

		Integer pageSize = courseActionBuilder.PAGE_SIZE;
		Integer offset = (pageNumber - 1) * pageSize;

		pagedResult result = new pagedResult();
		result.pageNumber = pageNumber;
		result.pageSize = pageSize;
		result.totalItemCount = Database.countQuery('SELECT count() FROM Account');

		String query = 'SELECT Id, Name From Account Where Name Like :searchCriteria WITH SECURITY_ENFORCED ORDER BY Name LIMIT :pageSize OFFSET :offset';
		List<Account> records = Database.query(query);
		//return records;

		result.records = records;

		return result;
	}

	@AuraEnabled(cacheable = true)
	public static List<Account> getSelectedAccounts(String role){

		return [SELECT Id, Name, (SELECT Id, Name
		                          FROM Course_Taken__r)
		        FROM Account
		        Where Facilitator__c = true AND Id = '001g000002I38BgAAJ'
		        LIMIT 1];
	}

	@AuraEnabled(cacheable = true)
	public static List<Courses_Taken__c> fetchCourse(String courseId){

		return [SELECT Id, Name
		        FROM Courses_Taken__c
		        WHERE Id = :courseId
		        LIMIT 1];
	}

	//AddSelectedCourseToRole
	/*   @AuraEnabled(cacheable=true)
	 public static Integer getAccountsCount(){
	 return [ SELECT Id, Name, First_Name__c, Last_Name__c, Email__c, Board_Member__c, Lead_Facilitator__c, Facilitator__c, Trainer__c, Client__c
	 From Account LIMIt 10];

	 } */
	@AuraEnabled(cacheable = true)
	public static List<Courses_Taken__c> showAssignedCourses(Id account){

		return [SELECT Id, Account_Name__c, Course_Name__c, Course_SIS__c, Section_SIS__c, Course_Description__c, Term_SIS__c, Assigned_Date__c, Expected_Completion_Date__c, Course_Completion_Date__c, Status__c
		        FROM Courses_Taken__c
		        where Account__c = :account];
	}

	@AuraEnabled(cacheable = true)
	public static List<Courses_Taken__c> assignedCoursesForRole(String role){

		List<Courses_Taken__c> lstCourses = new List<Courses_Taken__c>();

		String facilitatorQuery = ' SELECT Id, Account_Name__c, Course_Name__c, Assigned_Date__c, Expected_Completion_Date__c ' + 
								  ' Course_SIS__c, Term_SIS__c, Section_SIS__c ' + 
								  ' FROM Courses_Taken__c ' + 
								  ' WHERE Course__c.Facilitator_Course__c = true ' + 
								  ' AND Common_Course__c = true';


		lstCourses = Database.query(facilitatorQuery);
		return lstCourses;
	}

	@AuraEnabled(cacheable = true)
	public static List<Course_Master__c> getCourses(){

		/*String criteria  = '';

		 if(roles.contains('Facilitator')){
		 criteria = criteria + ' Facilitator_Course__c = true ' ;

		 if(roles.contains('Client')){
		 criteria = criteria + ' AND Client_Course__c = true ' ;
		 }
		 }
		 else if(roles.contains('Client')){
		 criteria = criteria + ' Client_Course__c = true ' ;
		 } */

		/* List<Course_Master__c> result = new List<Course_Master__c>();

		 if(roles.contains('Facilitator') && roles.contains('Client') ){

		 result =  [SELECT Id, Course_Code__c,Course_Name__c FROM Course_Master__c WHERE Active__c = true AND ( Facilitator_Course__c = true OR Client_Course__c = true)];

		 }
		 else  if(roles.contains('Facilitator') && !roles.contains('Client') ){

		 result =  [SELECT Id, Course_Code__c,Course_Name__c FROM Course_Master__c WHERE Active__c = true AND Facilitator_Course__c = true];

		 }
		 else  if(!roles.contains('Facilitator') && roles.contains('Client') ){

		 result = [SELECT Id, Course_Code__c,Course_Name__c FROM Course_Master__c WHERE Active__c = true AND Client_Course__c = true];

		 }

		 return result;


		 String query = 'SELECT Id, Course_Code__c,Course_Name__c FROM Course_Master__c WHERE Active__c = true AND ' + criteria;

		 return Database.query(query); */


		return [SELECT Id, Course_Code__c, Course_Name__c
		        FROM Course_Master__c
		        WHERE Active__c = true];
	}

	/* return [ SELECT
	 Id, Name, Course_Code__c, Course_Name__c,Active__c,
	 Common_Course__c, Client_Course__c,
	 Facilitator_Course__c, Trainerr_Course__c
	 FROM Course_Master__c Where ]; */
}