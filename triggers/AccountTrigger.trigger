trigger AccountTrigger on Account (Before Insert) {
    System.debug( '####' + Trigger.new );
    System.debug( '####' + Trigger.newMap );
    System.debug( '####' + Trigger.new );
    System.debug( '####' + Trigger.newMap );
}