/************************************************************************************************************* 
@ClassName   : UIElementDataController
@Description : This class will handle the logic of getting contact's product informaion based on Home country
			   and product name
@Date		 : 11/Sep/2021
@Version     : 1.0
@Author	     : Rinesh Rajan
**************************************************************************************************************/
public class UIElementDataController {
	@AuraEnabled
    /*MethodName  : getUIDataInfo
     *Description : Method called from Lightning controller which returns the configuration as well as 
     *              Data to be displayed in the UI    
     *Author	  : Rinesh Rajan
     */
    public static Object getUIDataInfo(String ComponentName, Map<String, String> filters){
        
        try{
            UI_Management__mdt uiManageData = fetchUIManageMetadata(ComponentName);
            if(uiManageData != null){
               String soqlQuery =  prepareSOQLQuery(uiManageData,filters);
               List<SObject> uiData = Database.query(soqlQuery);
               return prepareUIDataPackage(uiManageData,uiData);
            }else{
            	return handleErrors('Unable to find the UI Configuration');    
            }
            
        }catch(Exception e){
            System.debug('error : '+e);
            return handleErrors(e.getMessage()); 
        }
       
    }
    /*Method Name    	: fetchUIManageMetadata
     *Description  		: Fetches the custom metadata information which configures the UI
     *Author 			: Rinesh Rajan
     */
    
    public static UI_Management__mdt fetchUIManageMetadata(String ComponentName){
         UI_Management__mdt uiManageData = [SELECT Id,MasterLabel,Data_Source__c,Format__c,UI_Icon__c,
                                            	(SELECT MasterLabel,Field_API_Name__c,Sort_Order__c,Data_Type__c 
                                            	 FROM UI_Management_Elements__r 
                                                 ORDER BY Sort_Order__c ASC
                                                )
                                           FROM UI_Management__mdt
                                           WHERE MasterLabel =: ComponentName LIMIT 1];
        return uiManageData;
    }
    /*MethodName  : prepareSOQLQuery
     *Description : Method prepares the soql query dynamically from the information stored in the custom metadata
	 *				This can be reused.	
     *Author	  : Rinesh Rajan
     */
    public static String prepareSOQLQuery(UI_Management__mdt uiManageData, Map<String, String> filters ){
        
        String soqlQuery = 'SELECT Id ';
        
        for(UI_Management_Element__mdt uiElements : uiManageData.UI_Management_Elements__r){
                soqlQuery += ', '+ uiElements.Field_API_Name__c ;
        }
        soqlQuery += ' FROM '+ uiManageData.Data_Source__c;

        if(!filters.isEmpty()){
            soqlQuery += ' WHERE ';
            Boolean isFirstFilter = true;
            for(String filterFields : filters.keySet()){
                if(!isFirstFilter){
                    soqlQuery += ' AND ';
                }
                isFirstFilter = false;
           		soqlQuery += filterFields + ' = \'' + String.escapeSingleQuotes(filters.get(filterFields).trim()) + '\' ';
            }
        }
        return soqlQuery;
    }
    /*MethodName  : prepareUIDataPackage
     *Description : Method prepares the data packet from the metadata and sobject information
     *Author	  : Rinesh Rajan
     */
    public static Object prepareUIDataPackage(UI_Management__mdt uiManageData, List<SObject> uiData ){
    	
        Map<String,Object> dataMap = new Map<String,Object>();
        
        //This info will be displayed as a header in the UI Component
        dataMap.put('Title',uiManageData.MasterLabel);
        //This info will be used to choose whether the data should be displayed as table or detailed.
        dataMap.put('Format',uiManageData.Format__c);
        //This info will be used to choose the icon to be displayed.
        dataMap.put('Icon',uiManageData.UI_Icon__c);
        //The below list collects the whole data to be displayed in the UI.
        List<Object> data = new List<Object>();
        //The below Map collects one instance of the record. Later this will be added to the above list.
        Map<String,Object> fieldLevelMap = new Map<String,Object>();
        //The below list collects the list of columns/fields to be displayed in the UI.
        List<Object> columns = new List<Object>();
        
        /*The below boolean decides whether the loop is running for the first time. It is used so that we collect the 
        * columns only once in the loop. Extra logic to extract column is avoided and in process. 
		*/
        Boolean isFirstFilter = true;
        //loops through the queried data
        for(SObject dataVal : uiData){
            // loops through the UI configuration info 
            for(UI_Management_Element__mdt uiElements : uiManageData.UI_Management_Elements__r){
                if(isFirstFilter){
                    Map<String,Object> columnElements = new Map<String,Object>();
                    columnElements.put('label',uiElements.MasterLabel);
                    columnElements.put('fieldName',uiElements.Field_API_Name__c);
                    columnElements.put('type',uiElements.Data_Type__c);
                    if(uiElements.Data_Type__c == 'currency'){   
                        Map<String,Object> elementAttType = new Map<String,Object>();
                        elementAttType.put('currencyCode','EUR');
                        elementAttType.put('maximumSignificantDigits',5);
                        columnElements.put('typeAttributes',elementAttType);
                    }
                    columns.add(columnElements);
                }
                fieldLevelMap.put(uiElements.Field_API_Name__c, dataVal.get(uiElements.Field_API_Name__c));
            }
			isFirstFilter = false;
			data.add(fieldLevelMap);
        }
        dataMap.put('columns',columns);
        dataMap.put('data',data);
        return dataMap;
    }
    /*MethodName  : handleErrors
     *Description : Method to handle error and send the error response to the UI Component
     *Author	  : Rinesh Rajan
     */
    public static Object handleErrors(String errorMessage){
        Map<String,Object> dataMap = new Map<String,Object>();
        dataMap.put('Title', 'Error');
        dataMap.put('Format', 'Error Message');
        dataMap.put('Message', errorMessage);
        return dataMap;
    }
}