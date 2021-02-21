// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/* This script assigns molly and jen to Groups needed for flows */

List<User> users = [SELECT Id FROM User WHERE Alias = 'molly'];
List<Group> groups = [SELECT Id,Name FROM Group WHERE Name = 'Background Check Coordinator'];

if (!users.isEmpty() && !groups.isEmpty()) {
    GroupMember gm = new GroupMember(GroupId = groups[0].Id, UserOrGroupId = users[0].Id);
    insert gm;
}

users = [SELECT Id FROM User WHERE Alias = 'jen'];
groups = [SELECT Id FROM Group WHERE Name IN ('Course Assignment Director', 'Account Provision Director')];

if (!users.isEmpty()){
    User jen = users[0];
    for (Group grp : groups) {
        GroupMember gm = new GroupMember(GroupId = grp.Id, UserOrGroupId = jen.Id);
        insert gm;
    }
}
