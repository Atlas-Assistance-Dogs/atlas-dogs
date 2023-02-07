from category import Category
import templates.clear as clear
import templates.update as update


class Team:
    '''Class to control writing out the generated FileService code for the team objects'''

    def __init__(self, file, clientTypes, dogTypes):
        self.file = file
        self.client_cat = Category('Client', clientTypes)
        self.dog_cat = Category('Dog', dogTypes)
        self.categories = [self.client_cat, self.dog_cat]


    def fields(self):
        '''List the fields'''
        client_fields = ', '.join(self.client_cat.fields())
        dog_fields = ', '.join([typ.field for typ in self.dog_cat.types if typ.doc_type != 'VacExams'])
        return '\n\t\t\t\t\t'.join([client_fields, dog_fields])


    def code(self):
        self.file.write(update.team_code_start.format(fields = self.fields()))
        for cat in self.categories:
            for typ in sorted(cat.types, key = lambda typ : typ.doc_type):
                if typ.doc_type == 'ContactForm':
                    continue
                if typ.doc_type == 'VacExams':
                    continue
                self.file.write(typ.code())

        self.file.write(update.team_code_end)


    def clear_code(self, clear_file):
        clear_file.write(clear.team_code_start.format(fields = self.fields()))
        for cat in self.categories:
            for typ in sorted(cat.types, key = lambda typ : typ.doc_type):
                if typ.doc_type == 'ContactForm':
                    continue
                if typ.doc_type == 'VacExams':
                    continue
                clear_file.write(typ.clear_code())

        clear_file.write(clear.team_code_end)
