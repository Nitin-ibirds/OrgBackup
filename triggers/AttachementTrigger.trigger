trigger AttachementTrigger on ContentDocument (After Insert, After Update ) {
    System.debug('####Attachement Called');
}