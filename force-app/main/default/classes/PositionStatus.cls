public with sharing class PositionStatus {
    @AuraEnabled
    public string position { get; set; }

    @AuraEnabled
    public string status { get; set; }

    public PositionStatus() {}
    
    public PositionStatus(string position, string status) {
        this.position = position;
        this.status = status;
    }
}