// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

List<User> users = [SELECT Id FROM User WHERE Alias = 'molly'];
List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name = 'Background Check Coordinator'];

if (!users.isEmpty() && !roles.isEmpty()) {
    users[0].UserRoleId = roles[0].Id;
    update users[0];
}

List<User> users = [SELECT Id FROM User WHERE Alias = 'jen'];
List<UserRole> roles = [SELECT Id FROM UserRole WHERE Name IN ('Course Assignment Director', 'Account Provisioning Director')];

if (!users.isEmpty())
    for (UserRole ur in roles) {
        users[0].UserRoleId = roles[0].Id;
    update users[0];
}
