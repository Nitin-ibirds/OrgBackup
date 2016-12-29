trigger countContactTasksTrigger on Account (After Insert, After Update, After Delete, After Undelete) {
   list<Account> acctList=[SELECT Id, Contact_Task_Count__c,  (Select Id, Total_Tasks_Completed__c, Total_Tasks_in_Progress__c From Contacts WHERE AccountId!=null) FROM Account];
   list<Account> updateList= new list<Account>();
   for(Account temp: acctList){
       Decimal count=0;
       for(Contact conTemp : temp.Contacts){
           count+=conTemp.Total_Tasks_Completed__c+conTemp.Total_Tasks_in_Progress__c;
        }
        if(count!=temp.Contact_Task_Count__c){
            temp.Contact_Task_Count__c=count;
            updateList.add(temp);
        }
   }
   Update updateList;
}