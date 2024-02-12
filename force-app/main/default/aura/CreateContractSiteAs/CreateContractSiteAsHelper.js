({
    addAccountRecord: function(component, event) {
        var accountList = component.get("v.accountList");
        accountList.push({
            'sobjectType': 'AS_Commodity_Destination__c',
            'Site__c': '',
            'selectedSiteData': '',
            'Grade_Commodity_Destination__c': '',
            'Quantity__c': '0',
            'Site_Price__c': '',
            'Sale_Origin_Destination__c': component.get("v.saleODType") ,
            'Available_Stock__c': component.get("v.recordId"),
            'gradeOptions': accountList[0].gradeOptions,
            'Spreads__c': ''
        });
        component.set("v.accountList", accountList);
    },
    addAccountWithDuplicateRecord: function(component, event) {
        var accountList = component.get("v.accountList");
        if(accountList.length>0)
        {
            let youngestDataRow=accountList[accountList.length-1];
            console.log('youngestDataRow-->',youngestDataRow);
            accountList.push({
                'sobjectType': 'AS_Commodity_Destination__c',
                'Site__c': youngestDataRow.Site__c,
                'selectedSiteData': youngestDataRow.selectedSiteData,   
                'Grade_Commodity_Destination__c':'',             
                'Quantity__c': '0',
                'Site_Price__c': '',
                'Sale_Origin_Destination__c': component.get("v.saleODType") ,
                'Available_Stock__c': component.get("v.recordId"),
                'gradeOptions': accountList[0].gradeOptions,
                'Spreads__c': ''
            });
            component.set("v.accountList", accountList);
            console.log('helper-->accountList',accountList);
        }
        
        
    }
})