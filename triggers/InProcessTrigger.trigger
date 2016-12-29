trigger InProcessTrigger on Hire_Form__c (Before Insert , After Update) {
    list<Hire_Form__c> hireObjList=new list<Hire_Form__c>();
    list<Contact> conList=new list<Contact>();
    list<Case> caseList=new list<Case>();
    hireObjList=trigger.new;
    if(trigger.IsInsert){
        for(Hire_Form__c temp : hireObjList){
            temp.status__c='In Progress';
            Contact con=new Contact();
            con.firstName=temp.First_Name__C;
            con.lastName=temp.Last_Name__c;
            con.Email=temp.Email__C;
            con.Phone=temp.Phone__c;
            conList.add(con);
        }
        Insert conList;
        for(integer i=0; i<conList.size();i++){
            hireObjList.get(i).Candidate__c=conList.get(i).Id;
            Case cs=new Case();
            cs.status='New';
            cs.Origin='Phone';
            cs.ContactId=conList.get(i).Id;
            caseList.add(cs);
        }
        Insert caseList;
    }
    else {
        for(Hire_Form__c temp : hireObjList){
            list<case> caseListTemp;
            if(temp.status__c.equalsIgnoreCase('Completed')){
                caseListTemp=[Select Id, status From Case Where ContactId=:temp.Candidate__c];
                for(Case TempCase : caseListTemp){
                    TempCase.status='Closed';
                }
                Update caseListTemp;
            }
        }
    }
}