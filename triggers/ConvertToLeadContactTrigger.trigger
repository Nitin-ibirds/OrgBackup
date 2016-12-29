trigger ConvertToLeadContactTrigger on Lead (before update) 
{
    /*list<NitinChandwani__Lead_Contact__c> leadContactList = new list<NitinChandwani__Lead_Contact__c>();
    for(Lead temp : trigger.new) 
    {
        if (temp.IsConverted)
        {
            NitinChandwani__Lead_Contact__c leadObj = new NitinChandwani__Lead_Contact__c();
            leadObj.NitinChandwani__Last_Name__c = temp.LastName;
            leadObj.NitinChandwani__Lead__c = temp.Id;
            leadContactList.add(leadObj);
        }
    }
    System.debug('####'+leadContactList);
    Insert leadContactList;*/
    list<Lead_Contact__c> leadContactList = new list<Lead_Contact__c>();
    set<Id> convertedLeadSet = new set<Id>();
    for(Lead temp : trigger.new) 
    {
        if (temp.IsConverted)
        {
            convertedLeadSet.add(temp.Id);
            /*leadContactList = [SELECT First_Name__c, Last_Name__c FROM Lead_Contact__c WHERE Lead__c=:temp.Id];
            NitinChandwani__Lead_Contact__c leadObj = new NitinChandwani__Lead_Contact__c();
            leadObj.NitinChandwani__Last_Name__c = temp.LastName;
            leadObj.NitinChandwani__Lead__c = temp.Id;
            leadContactList.add(leadObj);*/
        }
    }
    leadContactList = [SELECT  Last_Name__c FROM Lead_Contact__c WHERE Lead__c IN :convertedLeadSet];
    System.debug('####'+convertedLeadSet);
    System.debug('####'+leadContactList);
    //Insert leadContactList;
}