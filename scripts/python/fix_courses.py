import json

with open("datasets/Course__c.json", "r") as read_file:
    data = json.load(read_file)

for item in data["records"]:
    item["Name"] = item["Section_SIS__c"]

with open("datasets/Course__c.json", "w") as write_file:
    json.dump(data, write_file)
