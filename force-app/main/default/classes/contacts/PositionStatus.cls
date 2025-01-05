global with sharing class PositionStatus {
    @AuraEnabled
    global string position { get; set; }

    @AuraEnabled
    global string status { get; set; }

    global PositionStatus() {}
    
    global PositionStatus(string position, string status) {
        this.position = position;
        this.status = status;
    }
}