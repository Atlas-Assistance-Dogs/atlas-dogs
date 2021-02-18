public with sharing class CourseAssigned {
  @AuraEnabled(cacheable=true)
  public static List<Courses_Taken__c> getAssignedCourse(Id recordId) {
    system.debug('print recordId' + recordId);
    List<Courses_Taken__c> returnList = new List<Courses_Taken__c>(
      [
        SELECT
          Id,
          Course_Description__c,
          Course__c,
          Status__c,
          Course__r.Course_SIS_Section_SIS_Course_Name__c
        FROM Courses_Taken__c
        WHERE Account__c = :recordId
      ]
    );
    system.debug('returnList' + returnList);
    return returnList;
  }

  @AuraEnabled(cacheable=true)
  public static List<Course_Master__c> getMasterCourses() {
    return [
      SELECT Id, Course_SIS_Section_SIS_Course_Name__c, Name
      FROM Course_Master__c
      WHERE Active__c = TRUE
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Course_Master__c> getCommonCourses() {
    return [
      SELECT Id, Course_SIS_Section_SIS_Course_Name__c
      FROM Course_Master__c
      WHERE Active__c = TRUE AND Common_Course__c = TRUE
    ];
  }

  @AuraEnabled(cacheable=true)
  public static List<Course_Master__c> getCourses(String typeOfUser) {
    system.debug('typeOfUser' + typeOfUser);
    List<Course_Master__c> commonCourseList = new List<Course_Master__c>(
      [
        SELECT Id, Course_SIS_Section_SIS_Course_Name__c
        FROM Course_Master__c
        WHERE Active__c = TRUE AND Common_Course__c = TRUE
      ]
    );
    List<Course_Master__c> courseList = new List<Course_Master__c>();
    List<Course_Master__c> finalList = new List<Course_Master__c>();

    if (typeOfUser == 'Facilitator' || typeOfUser == 'Lead Facilitator') {
      courseList = [
        SELECT Id, Course_SIS_Section_SIS_Course_Name__c
        FROM Course_Master__c
        WHERE Active__c = TRUE AND Facilitator_Course__c = TRUE
      ];

      courseList.addAll(commonCourseList);
    } else if (typeOfUser == 'Volunteer' || typeOfUser == 'Board Member') {
      courseList = commonCourseList;
    } else if (typeOfUser == 'Trainer') {
      courseList = [
        SELECT Id, Course_SIS_Section_SIS_Course_Name__c
        FROM Course_Master__c
        WHERE
          Active__c = TRUE
          AND Trainer_Course__c = TRUE
          AND Common_Course__c = TRUE
      ];
      courseList.addAll(commonCourseList);
    } else if (typeOfUser == 'Client') {
      courseList = [
        SELECT Id, Course_SIS_Section_SIS_Course_Name__c
        FROM Course_Master__c
        WHERE
          Active__c = TRUE
          AND Client_Course__c = TRUE
          AND Common_Course__c = TRUE
      ];
      courseList.addAll(commonCourseList);
    }

    system.debug('courseList' + courseList);
    return courseList;
  }

  @AuraEnabled
  public static void updateRecords(Id accId, List<String> sobList) {
    system.debug('sobList' + sobList);
    system.debug('accId' + accId);

    Account updateAccount = new Account();

    List<Courses_Taken__c> createList = new List<Courses_Taken__c>();
    List<Course_Master__c> cmasterList = [
      SELECT Id, Expected_Completion__c, Course_SIS_Section_SIS_Course_Name__c
      FROM Course_Master__c
      WHERE id IN :sobList
    ];
    List<Courses_Taken__c> checkList = new List<Courses_Taken__c>(
      [
        SELECT Id, Status__c, Course__c, Account__c
        FROM Courses_Taken__c
        WHERE Account__c = :accId
      ]
    );
    Map<Id, String> mapCTList = new Map<Id, String>();
    Map<Id, String> mapAssignedCourses = new Map<Id, String>();
    String concatAssignedCourses;
    system.debug('checkList' + checkList);
    for (Courses_Taken__c chcourseTaken : checkList) {
      mapCTList.put(chcourseTaken.Course__c, chcourseTaken.Status__c);
    }
    system.debug('mapCTList' + mapCTList);
    if (!sobList.isEmpty()) {
      for (Course_Master__c ct : cmasterList) {
        if (!mapCTList.containsKey(ct.Id)) {
          Courses_Taken__c createCoursesTaken = new Courses_Taken__c();
          createCoursesTaken.Course__c = ct.Id;
          createCoursesTaken.Status__c = 'Assigned';
          Date todaysDate = date.today();
          Integer daysCount = (Integer) ct.Expected_Completion__c * 7;
          createCoursesTaken.Expected_Completion_Date__c = todaysDate.adddays(
            daysCount
          );
          createCoursesTaken.Assigned_Date__c = date.today();
          createList.add(createCoursesTaken);
          createCoursesTaken.Account__c = accId;
          if (mapAssignedCourses.containsKey(accId)) {
            string body =
              '<p style=\"square;\">' +
              ct.Course_SIS_Section_SIS_Course_Name__c +
              ' </p>';
            concatAssignedCourses =
              concatAssignedCourses +
              '<br>' +
              ct.Course_SIS_Section_SIS_Course_Name__c;
            mapAssignedCourses.put(accId, concatAssignedCourses);
          } else {
            system.debug(
              ' ct.Course_SIS_Section_SIS_Course_Name__c' +
              ct.Course_SIS_Section_SIS_Course_Name__c
            );
            string body =
              '<p style=\"square;\">' +
              ct.Course_SIS_Section_SIS_Course_Name__c +
              ' </p>';
            concatAssignedCourses = body;
            mapAssignedCourses.put(accId, concatAssignedCourses);
          }
        }
      }
    }
    system.debug('insert' + createList);
    if (!createList.isEmpty())
      insert createList;
    system.debug('After Insert');
    updateAccount.id = accId;
    updateAccount.Assigned_Courses__c = mapAssignedCourses.get(accId);
    update updateAccount;
  }
}
