## Script to update test files for the FileService class.  This needs to be run in the root directory of the project.
import shutil
from xml.dom import minidom

from contact import Contact
from dog import Dog
from category import Category
from team import Team
  
doc = minidom.parse("force-app/main/default/objects/ContentVersion/fields/Type__c.field-meta.xml")
  
setting_elements = doc.getElementsByTagName("valueSettings")
settings = {}
for setting in setting_elements:
    name = setting.getElementsByTagName("valueName")[0].firstChild.data
    categories = setting.getElementsByTagName("controllingFieldValue")
    for category_element in categories:
        category = category_element.firstChild.data
        if category in settings:
            settings[category].append(name)
        else:
            settings[category] = [name]



base_file = 'force-app/main/test/TestFileService{category}Fields.cls'
base_clear_file = 'force-app/main/test/TestClearDateService{category}Fields.cls'
meta_path = 'force-app/main/test/TestFileServiceFields.cls-meta.xml'


for category, types in settings.items():
    if category == 'Standalone':
        continue

    category = Category(category, types)

    with open(base_file.format(category = category.category), 'w') as test_file:
        category.test(test_file)

    ## make sure there is a meta file for the test class
    shutil.copy(meta_path, meta_path.replace('Fields', category.category + 'Fields')) #copy the file to destination dir

    with open(base_clear_file.format(category = category.category), 'w') as test_file:
        category.test_clear(test_file)

    ## make sure there is a meta file for the test class
    shutil.copy(meta_path, meta_path.replace('TestFileService', 'TestClearDateService{category}'.format(category = category.category))) #copy the file to destination dir


# Read the FileService.cls file
service_path = 'force-app/main/default/classes/FileService.cls'
with open(service_path) as file:
    service_lines = file.readlines()

with open(service_path, 'w') as service_copy:

    # Copy the FileService class up to the first #region.  This in the Generated Contact 
    for line in service_lines:
        service_copy.write(line)
        if '#region' in line:
            break

    contact = Contact(service_copy, settings)
    contact.code()

    team = Team(service_copy, settings['Client'])
    team.code()

    dog = Dog(service_copy, settings['Dog'])
    dog.code()

    service_copy.write('''    //#endregion Generated code
}''')

# Read the ClearDateService.cls file
service_path = 'force-app/main/default/classes/ClearDateService.cls'
with open(service_path) as file:
    service_lines = file.readlines()

with open(service_path, 'w') as service_copy:

    # Copy the FileService class up to the first #region.  This in the Generated Contact 
    for line in service_lines:
        service_copy.write(line)
        if '#region' in line:
            break

    contact = Contact(service_copy, settings)
    contact.clear_code(service_copy)

    team = Team(service_copy, settings['Client'])
    team.clear_code(service_copy)

    dog = Dog(service_copy, settings['Dog'])
    dog.clear_code(service_copy)

    service_copy.write('''    //#endregion Generated code
}''')
