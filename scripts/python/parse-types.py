from xml.dom import minidom
  
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

print(settings)