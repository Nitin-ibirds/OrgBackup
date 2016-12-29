/*
@Name         :    HireProcessCaseTrigger 
@AUthor       :    Nitin Chandwani
@Date         :    11, June,2015
@Description  :    Trigger For Validating Update
*/
trigger HireProcessCaseTrigger on Case (Before Update) {
    list<Case> caseList=Trigger.new;
    set<Id> contactIdSet=new set<Id>();
    list<Hire_Form__c> hireList=new list<Hire_Form__c>();
    for(Case temp : caseList){
        if(temp.status.equalsIgnoreCase('Closed')){
            contactIdSet.add(temp.ContactId);
        }
    }
   hireList=[SELECT Id, First_Name__c, Last_Name__c, Phone__C, Email__c,status__c FROM Hire_Form__c Where Candidate__c In :contactIdSet];
   for(integer i=0;i<hireList.size();i++){
       if(!(hireList.get(i).status__C.equalsIgnoreCase('Completed'))){
       try{
           Trigger.new[i].addError('You cannot close the case until hire form  is completed');
        }
        catch(Exception e){
        }
       }
   }
}