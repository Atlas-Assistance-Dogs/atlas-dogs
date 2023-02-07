from category import Category
import templates.clear as clear
import templates.update as update


class Team:
    '''Class to control writing out the generated FileService code for the team objects'''

    def __init__(self, file, category):
        self.file = file
        self.category = Category('Client', category)


    def fields(self):
        '''List the fields'''
        return ', '.join(self.category.fields())


    def code(self):
        self.file.write(update.team_code_start.format(fields = self.fields()))
        for typ in sorted(self.category.types, key = lambda typ : typ.doc_type):
            if typ.doc_type == 'ContactForm':
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
