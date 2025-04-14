({
    onPageReferenceChange: function(cmp, evt, helper) {
    var myPageRef = cmp.get("v.pageReference");
    var id = myPageRef.state.c__id;
    cmp.set("v.id", id);
    var objectName = myPageRef.state.c__object;
    cmp.set("v.object", objectName);
  }
});
