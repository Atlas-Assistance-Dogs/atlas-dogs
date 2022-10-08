from category import Category
import templates.clear as clear
import templates.update as update

class Contact:
    '''Class to control writing out the generated FileService code for the contact objects'''

    def __init__(self, file, categories):
        self.file = file
        self.sorted_categories = [Category(key, categories[key]) for key in sorted(categories.keys()) if key != 'Dog']

    def code(self):
        self.file.write(update.contact_code_start)
        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            self.file.write(category.check())

        self.file.write(update.contact_code_end)

        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            self.file.write(category.method())


    def clear(self, clear_file):
        clear_file.write(clear.contact_code_start)
        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            clear_file.write(category.clear_check())

        clear_file.write(clear.contact_code_end)

        for category in self.sorted_categories:
            if (category.category == 'Standalone'):
                continue;
            clear_file.write(category.clear_method())
