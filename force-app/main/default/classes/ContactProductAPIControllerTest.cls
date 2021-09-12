@IsTest
global class ContactProductAPIControllerTest {
    @isTest static void test() {

        Contact Con1= new Contact();
		Con1.LastName ='Joe';
        Con1.Email ='Joe@test.com';
        Con1.Product__c ='Standard';
        Con1.Home_Country__c ='DE';
        Con1.UUID__c ='1234';
		insert Con1;
       
        Product_Management__c PM = new Product_Management__c();
        PM.ATM_Fee_in_other_currencies__c= '1.70%';
        PM.Card_Replacement_Cost__c=6;
        PM.Cost_per_Calendar_Month__c='0';
        PM.Country__c='DE';
        PM.Name='Standard';
        PM.Unique_Id__c='StandardDE';
        insert PM;

        String myJSON = JSON.serialize(PM);
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://gdseycom-1b-dev-ed.my.salesforce.com/services/apexrest/salesforceprodinfo';
        request.params.put('Id', '1234');
        request.httpMethod = 'GET';
		request.requestBody = Blob.valueof(myJSON);
		RestContext.request = request;
        
        ContactProductAPIController.productInfo();
        ContactProductAPIController.parse(Con1,PM);

    }
    @isTest static void test2() {

        Contact Con1= new Contact();
		Con1.LastName ='Joe';
        Con1.Email ='Joe@test.com';
        Con1.Product__c ='Standard';
        Con1.Home_Country__c ='DE';
        Con1.UUID__c ='1236';
		insert Con1;
       
        Product_Management__c PM = new Product_Management__c();
        PM.ATM_Fee_in_other_currencies__c= '1.70%';
        PM.Card_Replacement_Cost__c=6;
        PM.Cost_per_Calendar_Month__c='0';
        PM.Country__c='DE';
        PM.Name='Standard';
        PM.Unique_Id__c='StandardDE';
        insert PM;

        String myJSON = JSON.serialize(PM);
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://gdseycom-1b-dev-ed.my.salesforce.com/services/apexrest/salesforceprodinfo';
        request.params.put('Id', '1237');
        request.httpMethod = 'GET';
		request.requestBody = Blob.valueof(myJSON);
		RestContext.request = request;
        
        ContactProductAPIController.productInfo();
        ContactProductAPIController.parse(Con1,PM);

    }
}