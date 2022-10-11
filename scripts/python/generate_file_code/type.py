import templates.clear as clear
import templates.update as update

new_dog = "Name = 'Fido'"

new_contact = "FirstName = 'Test', LastName = 'Contact', Email = 'abc@abc.com'"


class CategoryType:
    """Create code to update or test a category/type"""
    category = ''
    doc_type = 'ContactForm'
    name = 'contact'
    field = ''
    object = 'Contact'
    fields = new_contact

    def __init__ (self, cat, typ):
        self.category = cat
        self.doc_type = typ
        self.fields = new_contact

        if cat == 'Dog':
            self.name = 'dog'
            self.field = typ + 'Received__c'
            self.object = 'Dog__c'
            self.fields = new_dog

        elif typ == 'ContactForm':
            self.name = 'contact'
            self.field = typ + 'Received__c'
            self.object = 'Contact'

        else:
            self.name = 'contact'
            self.field = cat + typ + 'Received__c'
            self.object = 'Contact'


    def code(self):
        '''Update the last date for this type'''
        template = '''
        if (cv.Type__c == '{type}' && isLater({object}.{field}, cv.Date__c)){{
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
        return update.test_template.format(category = self.category, type = self.doc_type, field = self.field, object_fields = self.fields, object = self.object)


    def test_clear(self):
        return clear.test_template.format(category = self.category, type = self.doc_type, field = self.field, object_fields = self.fields, object = self.object)
