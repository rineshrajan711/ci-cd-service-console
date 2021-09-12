@isTest
public class UIElementDataControllerTest {
	@testSetup static void setup() {
    	List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<2;i++) {
            testAccts.add(new Account(Name = 'TestAcct'+i));
        }
        insert testAccts;
        List<Contact> testConts = new List<Contact>();
        for(Account acc: testAccts){
            testConts.add(new Contact(FirstName='Jason',LastName='Smith',AccountId=acc.Id,
                                      email='js@test.com',Product__c='Standard',Home_Country__c = 'IT'));
        }
       	insert testConts;
        List<Case> caseRec = new List<Case>();
        for(Contact newC : testConts){
          	caseRec.add(new Case(Status='New',Subject='Test Class',Origin = 'Email', ContactId=newC.Id));
        }
        Insert caseRec;
        
        List<Product_Management__c> prdManagement = new List<Product_Management__c>();
        prdManagement.add(new Product_Management__c(Name = 'Standard',Country__c='IT',Cost_per_Calendar_Month__c='0',
                                                   ATM_Fee_in_other_currencies__c ='1.70%',Card_Replacement_Cost__c=6,
                                                   Unique_Id__c ='Standard_IT'));
        prdManagement.add(new Product_Management__c(Name = 'Standard',Country__c='DE',Cost_per_Calendar_Month__c='0',
                                                   ATM_Fee_in_other_currencies__c ='1.70%',Card_Replacement_Cost__c=6,
                                                   Unique_Id__c ='Standard_DE'));
        Insert prdManagement;
    }
    @isTest static void getUIDataInfoTest() {
        
        Map<String,String> newFilterComponents = new Map<String,String>();
        newFilterComponents.put('Name','Standard');
        newFilterComponents.put('Country__c','IT');
    	UIElementDataController.getUIDataInfo('Product Information',newFilterComponents);
    }
    @isTest static void getUIDataInfoErrorHandlerTest() {
        
        Map<String,String> newFilterComponents = new Map<String,String>();
        newFilterComponents.put('Name','Standard');
        newFilterComponents.put('Country__c','IT');
    	UIElementDataController.getUIDataInfo('Product Information Test',newFilterComponents);
    }
}