/*
 Methods related to getting and filtering courses
 */
public inherited sharing class CourseController {
    // Add selected courses to all users with the indicated positions
    @AuraEnabled
    public static void addSelectedCourses(
        List<String> positions,
        List<Id> selectedCourses
    ) {
        String query =
            'SELECT Id FROM Contact WHERE Positions__c INCLUDES (' +
            String.join(positions, ';') +
            ')';

        List<Contact> contactList = Database.query(query);

        List<Course__c> assignedCoursesList = [
            SELECT Id
            FROM Course__c
            WHERE ID IN :selectedCourses
        ];

        List<Course_Assignment__c> ListToUpdate = new List<Course_Assignment__c>();

        for (Contact cont : contactList) {
            for (Course__c course : assignedCoursesList) {
                Course_Assignment__c c = new Course_Assignment__c();
                c.Course__c = course.Id;
                c.Contact__c = cont.Id;
                c.Assigned_Date__c = system.today();

                ListToUpdate.add(c);
            }
        }
        insert ListToUpdate;
        return;
    }

    // Get the assignments for a course
    @AuraEnabled(cacheable=true)
    public static List<Course_Assignment__c> getCourseAssignmentsForCourse(
        Id courseId
    ) {
        return [SELECT Id, Name FROM Course_Assignment__c WHERE Id = :courseId];
    }

    // Get the courses assigned to contact
    @AuraEnabled(cacheable=true)
    public static List<Course_Assignment__c> getAssignedCourses(Id contact) {
        return [
            SELECT
                Id,
                Contact__c,
                Course_Name__c,
                Course_SIS__c,
                Section_SIS__c,
                Course_Description__c,
                Course__r.Course_SIS_Section_SIS_Course_Name__c,
                Term_SIS__c,
                Assigned_Date__c,
                Expected_Completion_Date__c,
                Completion_Date__c,
                Status__c
            FROM Course_Assignment__c
            WHERE Contact__c = :contact
        ];
    }

    // Get the courses assignments for a position
    @AuraEnabled(cacheable=true)
    public static List<Course_Assignment__c> assignedCoursesForPosition(
        String position
    ) {
        return [
            SELECT
                Id,
                Contact__c,
                Course_Name__c,
                Assigned_Date__c,
                Expected_Completion_Date__c,
                Course_SIS__c,
                Term_SIS__c,
                Section_SIS__c
            FROM Course_Assignment__c
            WHERE Course__r.Positions__c INCLUDES (:position)
        ];
    }

    // Get the active courses
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getActiveCourses() {
        return [
            SELECT
                Id,
                Course_Name__c,
                Course_SIS_Section_SIS_Course_Name__c,
                Section_SIS__c,
                Term_SIS__c,
                Active__c
            FROM Course__c
            WHERE Active__c = TRUE
        ];
    }

    // Get the active courses
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getCourses() {
        return [
            SELECT Id, Course_Name__c, Course_SIS_Section_SIS_Course_Name__c
            FROM Course__c
        ];
    }

    // Get the active courses
    @AuraEnabled(cacheable=true)
    public static List<Course__c> getCoursesForPositions(
        List<String> positions
    ) {
        String positionString = String.join(positions, ';');
        return [
            SELECT Id, Course_Name__c, Course_SIS_Section_SIS_Course_Name__c
            FROM Course__c
            WHERE Active__c = TRUE AND Positions__c INCLUDES (:positionString)
        ];
    }

    // Asssign new courses to the contact if needed
    @AuraEnabled
    public static void updateRecords(Id contactId, List<String> sobList) {
        system.debug('sobList' + sobList);
        system.debug('contactId' + contactId);

        List<Course_Assignment__c> createList = new List<Course_Assignment__c>();
        List<Course__c> cmasterList = [
            SELECT
                Id,
                Expected_Completion__c,
                Course_SIS_Section_SIS_Course_Name__c
            FROM Course__c
            WHERE id IN :sobList
        ];
        List<Course_Assignment__c> checkList = [
            SELECT Id, Status__c, Course__c, Contact__c
            FROM Course_Assignment__c
            WHERE Contact__c = :contactId
        ];
        Map<Id, String> mapCTList = new Map<Id, String>();
        Map<Id, String> mapAssignedCourses = new Map<Id, String>();
        String concatAssignedCourses;
        system.debug('checkList' + checkList);
        for (Course_Assignment__c chcourseTaken : checkList) {
            mapCTList.put(chcourseTaken.Course__c, chcourseTaken.Status__c);
        }
        system.debug('mapCTList' + mapCTList);
        if (!sobList.isEmpty()) {
            for (Course__c ct : cmasterList) {
                if (!mapCTList.containsKey(ct.Id)) {
                    Course_Assignment__c createCoursesTaken = new Course_Assignment__c();
                    createCoursesTaken.Course__c = ct.Id;
                    createCoursesTaken.Status__c = 'Assigned';
                    Date todaysDate = date.today();
                    Integer daysCount = (Integer) ct.Expected_Completion__c * 7;
                    createCoursesTaken.Expected_Completion_Date__c = todaysDate.adddays(
                        daysCount
                    );
                    createCoursesTaken.Assigned_Date__c = date.today();
                    createList.add(createCoursesTaken);
                    createCoursesTaken.Contact__c = contactId;
                    if (mapAssignedCourses.containsKey(contactId)) {
                        string body =
                            '<p style=\"square;\">' +
                            ct.Course_SIS_Section_SIS_Course_Name__c +
                            ' </p>';
                        concatAssignedCourses =
                            concatAssignedCourses +
                            '<br>' +
                            ct.Course_SIS_Section_SIS_Course_Name__c;
                        mapAssignedCourses.put(
                            contactId,
                            concatAssignedCourses
                        );
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
                        mapAssignedCourses.put(
                            contactId,
                            concatAssignedCourses
                        );
                    }
                }
            }
        }
        system.debug('insert' + createList);
        if (!createList.isEmpty())
            insert createList;
        system.debug('After Insert');

        /* this last bit was to update the assigned courses to the contact.
		 shouldn't be needed anymore.  So this method can be alot simpler
		 Contact contct = [SELECT Id, Name FROM Contact WHERE id = :contactId];
		 contct.Assigned_Courses__c = mapAssignedCourses.get(contactId);
		 update contct;
		 */
    }

    // Mark the course assignments as replaced
    @AuraEnabled
    public static void repSelectedCourses(List<Id> lstCourseIds) {
        List<Course_Assignment__c> lst = [
            SELECT Id, Status__c
            FROM Course_Assignment__c
            WHERE Id IN :lstCourseIds
        ];

        List<Course_Assignment__c> listToUpdate = new List<Course_Assignment__c>();

        if (lst != null) {
            for (Course_Assignment__c c : lst) {
                c.Status__c = 'Replaced';
                listToUpdate.add(c);
            }

            update listToUpdate;
        }

        return;
    }

    // Assign courses to a contact
    @AuraEnabled
    public static void assignCoursesToContact(
        String contactId,
        List<Id> courseIds
    ) {
        Contact cont = [
            SELECT Id, Name
            FROM Contact
            WHERE ID = :contactId
            LIMIT 1
        ];

        List<Course__c> assignedCoursesList = [
            SELECT Id
            FROM Course__c
            WHERE ID IN :courseIds
        ];

        List<Course_Assignment__c> ListToAdd = new List<Course_Assignment__c>();

        for (Course__c course : assignedCoursesList) {
            Course_Assignment__c cr = new Course_Assignment__c();
            cr.Course__c = course.Id;
            cr.Contact__c = cont.Id;
            cr.Assigned_Date__c = system.today();

            ListToAdd.add(cr);
        }

        insert ListToAdd;

        return;
    }
}
