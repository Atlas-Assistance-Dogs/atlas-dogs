trigger ContinuingEducationUnitTrigger on ContinuingEducationUnit__c (before insert) {
    for (ContinuingEducationUnit__c ceu : Trigger.new) {
        if (ceu.Name == null) {
            // find the last created CEU and increment the number from there
            List<ContinuingEducationUnit__c> last = [
                SELECT Name
                FROM ContinuingEducationUnit__c
                WHERE Name LIKE 'CEU-%'
                ORDER BY Name DESC LIMIT 1];
            if (last.isEmpty()) {
                ceu.Name = 'CEU-0001';
                return;
            }
            ContinuingEducationUnit__c latest = last[0];
            // First, instantiate a new Pattern object "cuePattern"
            Pattern pat = Pattern.compile('CEU-(\\d{4})');
            Matcher match = pat.matcher(latest.Name);
            if (match.find()) {
                string group1 = match.group(1);
                Integer lastNum = Integer.valueOf(group1);
                String num = (lastNum + 1).format().leftPad(4, '0');
                ceu.Name = String.format('CEU-{0}', new List<Object> { num });
            }
            else {
                ceu.Name = 'CEU-0001';
            }
        }
    }
}