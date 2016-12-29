trigger CandidateTriggerForPortalUser on Candidate__c (After insert, After Update) {
    list<Candidate__c> candidateList=trigger.new;
    map<string,Account> createNewAccounts=new map<string,Account>();
    map<string,Account> createNewAccountsMBrokrage=new map<string,Account>();
    list<Contact> conList=new list<Contact>(); 
    list<Task> taskList= new list<task>();
    if(Trigger.IsInsert){
        for(Candidate__c temp : candidateList){
            if(temp.Brokrage__c!=null){
                Account acct=new Account();
                acct.Name=temp.Brokrage__c;
                createNewAccounts.put(temp.Id,acct);
            }
        }    
        Insert createNewAccounts.Values();
        for(Account acc : createNewAccounts.Values()){
            System.debug(acc.Id);
        }
        for(Candidate__c temp : candidateList){
            if(createNewAccounts.ContainsKey(temp.Id)){
                Account acctTemp=createNewAccounts.get(temp.Id);
                if(temp.Manage_Brokrage__c!=null && temp.Brokrage__c!=null){
                    Account acct=new Account();
                    acct.ParentId=acctTemp.Id;
                    acct.Name=temp.Manage_Brokrage__c;
                    createNewAccountsMBrokrage.put(temp.Id,acct);
                }    
            }
        }
        Insert createNewAccountsMBrokrage.values();
        for(Candidate__c temp : candidateList){
            if(createNewAccountsMBrokrage.ContainsKey(temp.Id)){
                Account acctTemp=createNewAccounts.get(temp.Id);
                if(temp.Manage_Brokrage__c!=null && temp.Brokrage__c!=null){
                    Contact con=new Contact();
                    con.Firstname=temp.First_Name__c;
                    con.LastName=temp.Last_Name__c;
                    con.Email=temp.Email__C;
                    con.Accountid=acctTemp.id;
                    con.candidate__C=temp.Id;
                    conList.add(con);
                }    
            }
        }
        Insert conList;
        for(Contact conTemp: conList){
            Task taskTemp=new Task();
            taskTemp.WhoId=conTemp.Id;
            taskTemp.whatId=conTemp.Candidate__c;
            taskTemp.subject='Portal Contact Setup';
            taskList.add(taskTemp);
        }
        Insert taskList;
    }
    else{
        list<User> portalUserList=new list<User>();
        Profile profileObj =  [SELECT Id, Name FROM Profile WHERE name='Authenticated Website'];
        set<ID> candidateId=new set<Id>();
        for(Candidate__c temp : candidateList)
            candidateId.add(temp.Id);
        conList=[SELECT Id, FirstName, LastName, Email, Phone FROM Contact WHERE Candidate__c IN :candidateId];
        for(Candidate__c temp : candidateList){
            if(temp.status__c.equalsIgnoreCase('Webinar - Attended') && temp.User_Created__c==false){
                 System.Debug('####'+profileObj);
                 for(Contact con : conList){
                     User userObject = new User(contactId=con.Id, username=con.Email, firstname=con.FirstName,lastname=con.LastName, email=con.Email, communityNickname = con.LastName + '_Portal', alias = string.valueof(con.FirstName.substring(0,1) + con.LastName.substring(0,1)), profileid = profileObj.Id, emailencodingkey='UTF-8',languagelocalekey='en_US', localesidkey='en_US', timezonesidkey='America/Los_Angeles');   
                     Database.DMLOptions dlo = new Database.DMLOptions();
                     dlo.EmailHeader.triggerUserEmail= true;
                     userObject.setOptions(dlo);
                     portalUserList.add(userObject);
                 }
            }
        }
        Insert portalUserList;               
        for(User u: portalUserList)
        System.debug('#### Account created');
    }
}