import templates.clear as clear
import templates.update as update

new_dog = "Name = 'Fido'"

new_contact = "FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com'"

new_team = "Name = 'Test', Client__c = client.Id, Dog__c = dog.Id"

class CategoryType:
    """Create code to update or test a category/type"""
    category = ''
    doc_type = 'ContactForm'
    name = 'contact'
    field = ''
    object = 'Contact'
    fields = new_contact
    setup = ''

    def __init__ (self, cat, typ):
        self.category = cat
        self.doc_type = typ
        self.fields = new_contact

        if cat == 'Dog' or cat == 'TeamDog':
            self.field = typ + 'Received__c'
            if typ == 'VacExams':
                self.name = 'dog'
                self.object = 'Dog__c'
                self.fields = new_dog
            else:
                self.name = 'team'
                self.object = 'Team__c'
                self.fields = new_team
                self.setup = update.test_team_setup

        elif cat == 'Na':
            self.name = 'contact'
            self.field = typ + 'Received__c'
            self.object = 'Contact'

        elif cat == 'Client':
            self.name = 'team'
            self.object = 'Team__c'
            self.field = cat + typ + 'Received__c'
            self.fields = new_team
            self.setup = update.test_team_setup

        else:
            self.name = 'contact'
            self.field = cat + typ + 'Received__c'
            self.object = 'Contact'


    def code(self):
        '''Update the last date for this type'''
        template = '''
        if (cv.Type__c == '{type}' && isLater({object}.{field}, cv.Date__c)) {{
            {object}.{field} = cv.Date__c;
        }}
'''
        return template.format(field = self.field, type = self.doc_type, object = self.name)


    def clear_code(self):
        '''Clear the last date for this type'''
        template = '''
        if (cv.Type__c == '{type}'){{
            {object}.{field} = null;
        }}
'''
        return template.format(field = self.field, type = self.doc_type, object = self.name)


    def test(self):
        return update.test_template.format(category = self.category, type = self.doc_type, field = self.field, object_fields = self.fields, object = self.object, setup = self.setup)


    def test_clear(self):
        return clear.test_template.format(category = self.category, type = self.doc_type, field = self.field, object_fields = self.fields, object = self.object, setup = self.setup)
