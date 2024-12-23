({
  onPageReferenceChange: function (cmp, evt, helper) {
    var myPageRef = cmp.get("v.pageReference");
    var id = myPageRef.state.c__id;
    cmp.set("v.id", id);
  }
});
