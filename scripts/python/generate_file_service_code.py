from generate_last_file_code import Category


contact_code_start = '''
    // Update the last received docDate for the contact for the document category and type
    private static void updateContactDate(List<ContentVersion> cvs, Id recordId){
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs){
            string category = (cv.Type__c == 'ContactForm') ? '' : cv.Category__c;
            if (category == 'Standalone') continue;
            string field = string.format('{0}{1}Received__c', new List<Object>{ category, cv.Type__c.replace(' ', '') });
            fields.add(field);
            ids.add(cv.Id);
        }
        if (fields.size() == 0) return;
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format('SELECT Id, {0} FROM Contact WHERE Id = :recordId', new List<Object>{ fieldList });
        List<Contact> contacts = Database.query(query);

        if (contacts.size() == 0)
            return;
        Contact contact = contacts[0];
        // Get the Date, order asc so we update the field with the last received
        cvs = [SELECT Category__c, Type__c, Date__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        for (ContentVersion cv : cvs){'''

check_end = '''
            if (cv.Type__c == 'ContactForm' && isLater(contact.ContactFormReceived__c, cv.Date__c)){
                contact.ContactFormReceived__c = cv.Date__c;
            }
        }
        update contact;
    }
'''

class Contact:
    '''Class to control writing out the generated FileService code for the contact objects'''

    def __init__(self, file, categories):
        self.file = file
        self.sorted_categories = [Category(key, categories[key]) for key in sorted(categories.keys()) if key != 'Dog']

    def code(self):
        self.file.write(contact_code_start)
        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            self.file.write(category.check())

        self.file.write(check_end)

        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            self.file.write(category.method())


dog_code_start = '''
    // Update the last received docDate for the dog for the document type
    private static void updateDogDate(List<ContentVersion> cvs, Id recordId){
        // this is related to a dog
        Set<string> fields = new Set<string>();
        List<Id> ids = new List<Id>();
        for (ContentVersion cv : cvs){
            string field = string.format('{0}Received__c', new List<Object>{ cv.Type__c.replace(' ', '') });
            fields.add(field);
            ids.add(cv.Id);
        }
        string fieldList = string.join(new List<string>(fields), ',');
        string query = string.format('SELECT Id, {0} FROM Dog__c WHERE Id = :recordId', new List<Object>{ fieldList });
        List<Dog__c> dogs = Database.query(query);

        if (dogs.size() == 0)
            return;
        Dog__c dog = dogs[0];
        // Make sure we have Date__c, and last of these is last in
        // the list so we update the field correctly
        cvs = [SELECT Date__c, Type__c
               FROM ContentVersion
               WHERE Id IN:ids
               ORDER BY Date__c];

        //#region Generated dog
        for (ContentVersion cv : cvs){
'''
"""Start of the dog FileService code."""

dog_code_end = '''        }
        update dog;
    }
'''

class Dog:
    '''Class to control writing out the generated FileService code for the dog objects'''

    def __init__(self, file, category):
        self.file = file
        self.category = Category('Dog', category)

    def code(self):
        self.file.write(dog_code_start)
        for typ in sorted(self.category.types, key = lambda typ : typ.doc_type):
            self.file.write(typ.code())

        self.file.write(dog_code_end)
