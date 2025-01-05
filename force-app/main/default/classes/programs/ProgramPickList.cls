global class ProgramPickList extends VisualEditor.DynamicPickList{
    
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('red', 'RED');
        return defaultValue;
    }
    global override VisualEditor.DynamicPickListRows getValues() {
        List<Program__c> programs = [SELECT Id, Name FROM Program__c ORDER BY Name];
        VisualEditor.DynamicPickListRows  myValues = new VisualEditor.DynamicPickListRows();

        for (Program__c program : programs) {
            myValues.addRow(new VisualEditor.DataRow(program.Name, program.Name));
        }
        return myValues;
    }
}