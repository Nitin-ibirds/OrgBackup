trigger ContactTrigger on Contact (After Insert) {
    System.debug( '####' + Trigger.new );
    System.debug( '####' + Trigger.newMap );
    System.debug( '####' + Trigger.new );
    System.debug( '####' + Trigger.newMap );
}