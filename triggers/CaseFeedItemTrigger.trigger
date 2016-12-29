trigger CaseFeedItemTrigger on FeedItem (After Insert) {
    list<FeedItem> feedItemList = new list<FeedItem>();
    for(FeedItem temp : Trigger.new){
        String csId = temp.ParentId;
        Profile pf = [SELECT  id FROM Profile WHERE ID=:UserInfo.getProfileId()];
        String license=pf.UserLicense.name;
        if(temp.Type.equalsIgnoreCase('ContentPost') && temp.Hascontent==true && csId.startsWith('500') && license.equalsIgnoreCase('Salesforce'))
            feedItemList.add(temp);
    }
    if(feedItemList.size()!=0)
        CaseFeedItemTriggerHelper.caseItemUserdetails(feedItemList);
}