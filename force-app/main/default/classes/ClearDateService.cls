public with sharing class ClearDateService {

    // Update the date for the record tied to a file
    public static void clear(ContentVersion cv, Id recordId){
        if (String.isBlank(cv.Category__c) || String.isBlank(cv.Type__c))
            return;
        // note there is a limit of one cv above, so we can update all of them here
        if (cv.Category__c == 'Dog'){
            clearDogDate(cvs, cntLink.LinkedEntityId);
        } else{
            // this is related to a contact
            clearContactDate(cvs, cntLink.LinkedEntityId);
        }
    }

    //#region Generated

    private static clearContactDate(ContentVersion cv, Id recordId) {
        if (cv.Category__c == 'Standalone') return;
 
        string field;
        if (cv.Type__c == 'ContactForm') {
            field = 'ContactFormReceived__c';
        }
        else {
            field = string.format('{0}{1}Received__c', new List<Object>{ cv.Category__c, cv.Type__c.replace(' ', '') });
        }
        string query = string.format('SELECT Id, {0} FROM Contact WHERE Id = :recordId', new List<Object>{ field });
        List<Contact> contacts = Database.query(query);

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];

        if (cv.Category__c == 'ADSiM'){
            updateADSiMDate(cv, contact);
        }
    
        if (cv.Category__c == 'Board'){
            updateBoardDate(cv, contact);
        }
    
        if (cv.Category__c == 'Client'){
            updateClientDate(cv, contact);
        }
    
        if (cv.Category__c == 'Facilitator'){
            updateFacilitatorDate(cv, contact);
        }
    
        if (cv.Category__c == 'Puppy'){
            updatePuppyDate(cv, contact);
        }
    
        if (cv.Category__c == 'Staff'){
            updateStaffDate(cv, contact);
        }
    
        if (cv.Category__c == 'Trainer'){
            updateTrainerDate(cv, contact);
        }
    
        if (cv.Category__c == 'Volunteer'){
            updateVolunteerDate(cv, contact);
        }

        if (cv.Type__c == 'ContactForm'){
            contact.ContactFormReceived__c = null;
        }
        update contact;
    }

        
    private static clearDogDate(ContentVersion cv, Id recordId) {
        string  field = string.format('{0}Received__c', new List<Object>{ cv.Type__c.replace(' ', '') });
        string query = string.format('SELECT Id, {0} FROM Dog__c WHERE Id = :recordId', new List<Object>{ field });
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];

        if (cv.Type__c == 'ContactForm'){
            contact.ContactFormReceived__c = null;
        }
        update contact;
    }

}
