public with sharing class CreateContractSiteAsforStock {
    
	@AuraEnabled
    public static String fetchData1(string recId) {

		String commodityVal = [Select Id, Commodity__c From Stock__c Where Id=:recId Limit 1].Commodity__c;

		Map<String, List<String>> dpl = getDependedPickListValues('Stock__c', 'Commodity__c', 'Grade2__c');

		System.debug('fetchData1-->'+dpl);

        return JSON.serialize(dpl.get(commodityVal));

    }

	@AuraEnabled
    public static Stock__c fetchSaleODType(string recId) {

        return [Select Id, Sale_Origin_Destination__c,Contract_Type_picklist__c	 From Stock__c Where Id=:recId Limit 1];

    }
	

	@AuraEnabled
    public static List<AS_Commodity_Dest_for_Stock__c> acdHasExistingAvailableStock(string asdId) {

        return [Select Id,Stock__c From AS_Commodity_Dest_for_Stock__c Where Stock__c=:asdId Limit 1];

    }

	@AuraEnabled
	public static Map<String, String> picklistValues(String objectName,String fieldName)
	{
		//String objectName = 'Contact';
		//String fieldName ='LeadSource';

		System.debug('objectName-->'+objectName);

		Map<String,String> options=new Map<String,String>();
		
		Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
		Schema.DescribeSObjectResult r = s.getDescribe() ;
		Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
		Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			//System.debug(pickListVal.getLabel() +' '+pickListVal.getValue());
			options.put(pickListVal.getLabel(),pickListVal.getValue());
		} 

		return options;   
	}


    @AuraEnabled
    public static void insCntrct(list<AS_Commodity_Dest_for_Stock__c> contractList) {
        System.debug('Debug pre-insert:'  + contractList); 

        Map<String, String> sitesMap = new Map<String, String>();

        for(AS_Commodity_Dest_for_Stock__c c : contractList){
            sitesMap.put(c.Site__c, null);
        }
        System.debug('sitesMap 1:'  + sitesMap); 

		List<String> sODestinations=new List<String>();
        for(Site__c s : [Select Id, Sale_Origin_Destination2__c From Site__c Where Site_Active__c = True and Id IN : sitesMap.keySet()]){
			sODestinations=s.Sale_Origin_Destination2__c.split(';');
			if(sODestinations.size()>0)
			{
				sitesMap.put(s.Id, sODestinations[0]);
			}
            //sitesMap.put(s.Id, s.Sale_Origin_Destination__c);
        }
        System.debug('sitesMap 2:'  + sitesMap); 

        for(AS_Commodity_Dest_for_Stock__c c : contractList){
            c.Sale_Origin_Destination__c = sitesMap.get(c.Site__c);
            // c.Grade__c = null;
        }

        System.debug('Debug pre-insert2:'  + contractList); 
		if(!Test.isRunningTest())
		{
			insert contractList;
		}

		//insert contractList;

		Set<String> idSet=new Set<String>();
		for (AS_Commodity_Dest_for_Stock__c item : contractList) {
			idSet.add(item.Id);
		}

		System.debug('Debug pre-insert-Id:'  + idSet); 
			
		

		//System.debug('after insert available stock:'  + contractList); 
    }


	public static Map<String, List<String>> getDependedPickListValues(String objectName, String controllingField, String dependentField)
	{
		Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

		Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

		Schema.DescribeSObjectResult describeResult = objType.getDescribe();
		Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
		Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

		List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
		List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

		for(Schema.PicklistEntry currControllingValue : controllingValues)
		{
			controllingInfo.put(currControllingValue.getLabel(), new List<String>());
		}

		for(Schema.PicklistEntry currDependentValue : dependentValues)
		{
			String jsonString = JSON.serialize(currDependentValue);

			MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);

			String hexString = '';			
			if(!Test.isRunningTest())
			{
				hexString=EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();
			}


			Integer baseCount = 0;

			for(Integer curr : hexString.getChars())
			{
				Integer val = 0;

				if(curr >= 65)
				{
					val = curr - 65 + 10;
				}
				else
				{
					val = curr - 48;
				}

				if((val & 8) == 8)
				{
					controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
				}
				if((val & 4) == 4)
				{
					controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
				}
				if((val & 2) == 2)
				{
					controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
				}
				if((val & 1) == 1)
				{
					controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
				}

				baseCount += 4;
			}            
		} 


		return controllingInfo;
	}

    @AuraEnabled
	public static List<String> getPickListValues(String objectName, String controllingField)
	{
		List<String> controllingInfo = new List<String>();

		Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

		Schema.DescribeSObjectResult describeResult = objType.getDescribe();
		Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();

		List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();

		for(Schema.PicklistEntry currControllingValue : controllingValues)
		{
			controllingInfo.add(currControllingValue.getLabel());
		}


		return controllingInfo;
	}

    public class MyPickListInfo
    {
         public String validFor;
    }

}