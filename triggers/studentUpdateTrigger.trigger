trigger studentUpdateTrigger on Student__c (After Update) {
    list<student__c> stdList = Trigger.new;
    map<Id,Student__c> stdIdRecordMap = new map<Id,Student__c>();
    map<Id,Account> updateAccounts = new map<Id,Account>();
    
    for(student__c temp : stdList)
        stdIdRecordMap.put(temp.Id,temp );
        
    list<Account> acctList =[Select Id, Name, student__c, ParentId From Account Where Student__c In :stdIdRecordMap.keySet()];
    
    list<Account> allAcctsList =[Select Id, Name, ParentId,student__c From Account];
    map<Id,Account> allActMap = new map<Id,Account>();
    
    for(Account tempAcct : allAcctsList )
        allActMap.put(tempAcct.Id,tempAcct);
        
    for (Account tempAcct : acctList ){
        tempAcct.Name = stdIdRecordMap.get(tempAcct.student__c).First_Name__c;
        updateAccounts.put(tempAcct.Id,tempAcct);
        System.debug('####'+tempAcct );
        Account tempAcctRecord = tempAcct;
        
        while(tempAcctRecord.ParentId!=null){
            tempAcctRecord.Name=stdIdRecordMap.get(tempAcct.student__c).First_Name__c;
            updateAccounts.put(tempAcctRecord.Id,tempAcctRecord);
            tempAcctRecord=allActMap.get(tempAcctRecord.ParentId);
            System.debug('####'+tempAcctRecord);
        }
        if(tempAcctRecord.ParentId==null){
            tempAcctRecord.Name=stdIdRecordMap.get(tempAcct.student__c).First_Name__c;
            updateAccounts.put(tempAcctRecord.Id,tempAcctRecord);
        }
    }
    Update updateAccounts.values();
}