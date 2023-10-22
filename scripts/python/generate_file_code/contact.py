from category import Category
import templates.clear as clear
import templates.update as update

skip_categories = {'Client', 'Na'}

class Contact:
    '''Class to control writing out the generated FileService code for the contact objects'''

    def __init__(self, file, categories):
        self.file = file
        self.sorted_categories = [Category(key, categories[key]) for key in sorted(categories.keys()) if 'Dog' not in key]


    def fields(self):
        '''List the fields'''
        fields = [', '.join(category.fields()) for category in self.sorted_categories if (category.category not in skip_categories)]
        fields.append('ContactFormReceived__c')
        return ',\n\t\t\t\t'.join(fields)


    def code(self):
        self.file.write(update.contact_code_start.format(fields = self.fields()))
        for category in self.sorted_categories:
            if (category.category in skip_categories):
                continue;
            self.file.write(category.check())

        self.file.write(update.contact_code_end)

        for category in self.sorted_categories:
            if (category.category in skip_categories):
                continue;
            self.file.write(category.method())


    def clear_code(self, clear_file):
        clear_file.write(clear.contact_code_start.format(fields = self.fields()))
        for category in self.sorted_categories:
            if (category.category in skip_categories):
                continue;
            clear_file.write(category.clear_check())

        clear_file.write(clear.contact_code_end)

        for category in self.sorted_categories:
            if (category.category in skip_categories):
                continue;
            clear_file.write(category.clear_method())
