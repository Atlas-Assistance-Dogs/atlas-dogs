trigger ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    // create list of documents
    FileService.updateDates(Trigger.new);
}