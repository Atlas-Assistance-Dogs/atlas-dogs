import templates.clear as clear
import templates.update as update
from type import CategoryType


class Category:
    '''Class to generate test code for all types for a category'''
    category = ''
    types = []
    name = 'contact'
    object = 'Contact'

    def __init__(self, cat, types):
        self.category = cat
        self.types = [CategoryType(cat, typ) for typ in sorted(types)]
        if cat == 'Dog':
            self.name = 'dog'
            self.object = 'Dog__c'
        elif cat == 'Client':
            self.name = 'team'
            self.object = 'Team__c'
        else:
            self.name = 'contact'
            self.object = 'Contact'


    def check(self):
        template = '''        
            if (cv.Category__c == '{category}') {{
                update{category}Date(cv, {name});
            }}
'''
        return template.format(category = self.category, name = self.name)


    def method(self):
        template = '''
    // Update the last date when the category is {category}
    private static void update{category}Date(ContentVersion cv, {object} {name}) {{
'''
        definition = template.format(category = self.category, object = self.object, name = self.name)
        types = [typ.code() for typ in self.types]
        end = '    }\n'
        return definition + ''.join(types) + end


    def clear_method(self):
        template = '''
    // Clear the last date when the category is {category}
    private static void clear{category}Date(ContentVersion cv, {object} {name}) {{'''
        definition = template.format(category = self.category, object = self.object, name = self.name)
        types = [typ.clear_code() for typ in self.types]
        end = '    }\n'
        return definition + ''.join(types) + end


    def clear_check(self):
        template = '''        
        if (cv.Category__c == '{category}') {{
            clear{category}Date(cv, {name});
        }}
'''
        return template.format(category = self.category, name = self.name)


    def fields(self):
        '''Return the list of fields for this category'''
        return [typ.field for typ in self.types]


    def test(self, test_file):
        test_file.write(update.test_file_start.format(category = self.category))
        if self.category in ['Client', 'TeamDog']:
            test_file.write(update.test_team_setup_method)

        for typ in self.types:
            test_file.write(typ.test())
        test_file.write('}')


    def test_clear(self, test_file):
        test_file.write(clear.test_file_start.format(category = self.category))
        if self.category in ['Client', 'TeamDog']:
            test_file.write(update.test_team_setup_method)
            
        for typ in self.types:
            test_file.write(typ.test_clear())
        test_file.write('}')
