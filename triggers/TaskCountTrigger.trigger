trigger TaskCountTrigger on Task (After Insert, After Update, After Delete, After UnDelete) {
    
    if(Trigger.isInsert){
        list<task> TaskList=Trigger.new;
        list<Contact> conList=new list<Contact>();
        set<String> idListCompleted=new set<String>();
        set<String> idListInProgress=new set<String>();
        for(Task temp : TaskList){
            String id=temp.whoId;
            if(temp.status.equalsIgnoreCase('Completed')){
                if(id!='' && id.Left(3)=='003'){
                    idListCompleted.add(id);
                }
            }
            else
                idListInProgress.add(id);
        }
        conList=[SELECT ID, Total_Tasks_Completed__c FROM Contact Where Id In :idListCompleted];
        for(Contact conTemp:conList){
            conTemp.Total_Tasks_Completed__c+=1;
        }
        Update conList;
        conList=[SELECT ID,  Total_Tasks_in_Progress__c FROM Contact Where Id In :idListInProgress];
        for(Contact conTemp:conList){
            conTemp.Total_Tasks_in_Progress__c+=1;
        }
        Update conList;
    }
    else
    if(trigger.IsUpdate){
        list<Task> oldCaseValueList=Trigger.Old;
        list<Task> newCaseValueList=Trigger.new;
        list<Contact> conList=new list<Contact>();
        set<string> idListCompleted=new set<string>();
        set<String> idListInProgress=new set<String>();
        for(Integer i=0;i<oldCaseValueList.size();i++){
            if(oldCaseValueList.get(i).whoId!=newCaseValueList.get(i).whoId){
            
            }
            if(oldCaseValueList.get(i).Status!=newCaseValueList.get(i).status){
                if(newCaseValueList.get(i).status.equalsIgnoreCase('Completed'))
                    idListCompleted.add(newCaseValueList.get(i).whoId);
                else if(newCaseValueList.get(i).status.equalsIgnoreCase('in Progress'))
                    idListInProgress.add(newCaseValueList.get(i).whoId);
            }
        }
        conList=[SELECT ID, Total_Tasks_Completed__c, Total_Tasks_in_Progress__c FROM Contact Where Id In :idListCompleted];
        for(Contact conTemp:conList){
            conTemp.Total_Tasks_Completed__c+=1;
        }
        Update conList;
        conList=[SELECT ID,  Total_Tasks_in_Progress__c, Total_Tasks_Completed__c FROM Contact Where Id In :idListInProgress];
        for(Contact conTemp:conList){
            conTemp.Total_Tasks_in_Progress__c+=1;
        }
        Update conList;
    }
}