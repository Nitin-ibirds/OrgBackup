trigger OppTrigger on Opportunity (after Insert) {
    System.debug('###' + Trigger.New );
}