({
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    },
    
	 onCheck: function(cmp, evt) {
		 var checkCmp = cmp.find("checkbox").get("v.value");
           if(checkCmp === true)
           {
               cmp.set("v.isbuttondisabled",false);
           }
      /*     if(checkCmp === false)
           {
               cmp.set("v.isbuttondisabled",true);
           }    */     


	 },
    next : function(component,event,helper) {
        var navigate = component.get("v.navigateFlow");
        navigate("NEXT");         
        
    }
})