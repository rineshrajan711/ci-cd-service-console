({
	recordUpdate : function(component, event, helper) {
        var caseRec = component.get("v.caseRecord");
		var theMap = component.get("v.theMapValue");
        theMap["Name"]=caseRec.Contact.Product__c;
        theMap["Country__c"]=caseRec.Contact.Home_Country__c;
        component.set("v.theMapValue",theMap);
       	component.set("v.dataFetchComplete",true);
	}
})