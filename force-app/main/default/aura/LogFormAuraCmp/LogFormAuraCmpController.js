({
    onRender: function (component, event, helper) {
        //Fetching Record Type Id
        var recordTypeId = component.get("v.recordTypeId");
        if (!recordTypeId) {
            recordTypeId = component.get("v.pageReference").state.recordTypeId;
            component.set("v.recordTypeId", recordTypeId);
            //component.find("modal").open(recordTypeId);
        }
    }
});
