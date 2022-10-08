from category import Category
import templates.clear as clear
import templates.update as update


class Dog:
    '''Class to control writing out the generated FileService code for the dog objects'''

    def __init__(self, file, category):
        self.file = file
        self.category = Category('Dog', category)


    def code(self):
        self.file.write(update.dog_code_start)
        for typ in sorted(self.category.types, key = lambda typ : typ.doc_type):
            self.file.write(typ.code())

        self.file.write(update.dog_code_end)


    def clear_code(self, clear_file):
        clear_file.write(clear.dog_code_start)
        for typ in sorted(self.category.types, key = lambda typ : typ.doc_type):
            clear_file.write(typ.clear_code())

        clear_file.write(clear.dog_code_end)
