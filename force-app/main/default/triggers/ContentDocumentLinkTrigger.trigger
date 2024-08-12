trigger ContentDocumentLinkTrigger on ContentDocumentLink(after insert) {
    if (Trigger.new[0].ShareType != 'I') {
        // create list of documents
        FileService.updateDates(Trigger.new);
    }
}
