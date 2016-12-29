trigger AccountTrigger on Account (Before Insert) {
    System.debug( '####' + Trigger.new );
}