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
        clientFields = [', '.join(this.client_cat.fields()) for category in self.sorted_categories if (category.category not in skip_categories)]
        return ', '.join([item.fields() for sub_list in self.categories for item in sub_list])


    def code(self):
        self.file.write(update.team_code_start.format(fields = self.fields()))
        for cat in self.categories:
            for typ in sorted(cat.types, key = lambda typ : typ.doc_type):
                if typ.doc_type == 'ContactForm':
                    continue
                if type.doc_type == 'VacExams':
                    continue
                self.file.write(typ.code())

        self.file.write(update.team_code_end)


    def clear_code(self, clear_file):
        clear_file.write(clear.team_code_start.format(fields = self.fields()))
        for typ in sorted(self.category.types, key = lambda typ : typ.doc_type):
            if typ.doc_type == 'ContactForm':
                continue
            clear_file.write(typ.clear_code())

        clear_file.write(clear.team_code_end)
