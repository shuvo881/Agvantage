({	
    init: function(component, event, helper) {
        
        component.set("v.showSpinner",true);
        component.set("v.accountList",null);
        
        //check commodity Destination Has Existing Record
        
        var spreadDefaultVlue='base';
        var action = component.get("c.cdHasExistingOpp");
        action.setParams({
            "oppId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result  = response.getReturnValue();
                
                if(result.length>0)
                {
                    spreadDefaultVlue='';                    
                }
                component.set('v.spreadDefaultVlue',spreadDefaultVlue);
            }
            component.set("v.showSpinner",false);
            
        });
        
        $A.enqueueAction(action);        

                // picklist
        
        
                var action = component.get("c.fetchSaleODType");
                action.setParams({
                    "recId": component.get("v.recordId")
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var dt  = response.getReturnValue();
                        console.log('saleODType- dt--->',dt);
                        
                        
                        component.set("v.saleODType", dt.Sale_Origin_Destination__c);
                        component.set("v.contractType", dt.Contract_Type__c);
                        
                    }
                    component.set("v.showSpinner",false);
                    
                });
                
                $A.enqueueAction(action);


        
        
        var accountList = [];
        var action = component.get("c.fetchData1");
        
        action.setParams({
            "recId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var dt  = JSON.parse(response.getReturnValue());
                
                
                
                console.log('dt--->');
                console.log(dt);
                // console.log(dt['Adzuki Beans']);
                
                window.dt = dt;
                
                var tempOpt1 = [];
                
                for(var k in dt){
                    tempOpt1.push({label: dt[k], value: dt[k]});
                }
                // for (const [key, value] of Object.entries(dt)) {
                //     tempOpt1.push({label: key, value: key});
                // }
                // component.set('v.commodityOptions', tempOpt1);
                
                console.log('tempOpt1-->',tempOpt1);
                
                
                component.set("v.gradeOptions", tempOpt1);
                
                accountList.push({
                    'sobjectType': 'Contract_Site__c',
                    'Site__c': '',                                        
                    'selectedSiteData': '',                                        
                    'Grade__c': '',
                    'Quantity__c': '0',                    
                    'Sale_Origin_Destination__c': component.get("v.saleOrigin") ,
                    'Opportunity__c': component.get("v.recordId"),
                    'gradeOptions': tempOpt1,
                    'Spreads__c': component.get("v.saleODType")=='Nearest Terminal Port (NTP)'?'': spreadDefaultVlue,
                    'colSiteCss':'',
                    'colQuantityCss':'',
                    'colGradeCss':''
                });
                component.set("v.accountList",accountList);
                console.log('initial account List-->',accountList);
                console.log('component.get("v.saleODType")-->',component.get("v.saleODType"));
            }
            component.set("v.showSpinner",false);
            
        });
        
        $A.enqueueAction(action);
        
        



        // picklist


        var action = component.get("c.picklistValues");
        action.setParams({
            "objectName": "Opportunity",
            "fieldName": "Spreads__c",
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {             

                var result = response.getReturnValue();
                var fieldMap = [];
                for(var key in result){
                    fieldMap.push({key: key, value: result[key]});
                }
                component.set("v.baseSpread", fieldMap);
                
            }
            component.set("v.showSpinner",false);
            
        });
        
        $A.enqueueAction(action);
        
        
        
        
        
        
    },
    
    commodityChange : function(component, event){
        var val = event.getParam("value");
        var index = event.getSource().get('v.name');
        
        var tempArray = [];
        
        if(val){
            for(var k in window.dt[val]){
                tempArray.push({label: window.dt[val][k], value: window.dt[val][k]});
            }
        }
        
        var tempAccountList = component.get('v.accountList');
        tempAccountList[index].gradeOptions = tempArray;
        
        // console.log('tempAccountList-->', tempAccountList);
        
        // component.set('v.accountList', tempAccountList);
        
        
    },
    
    gradeChange : function(component, event){
        // var val = event.getParam("value");
        var index = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');
        
        
        
        console.log('val--->',val);
        // console.log(val.join(';'));
        
        var tempAccountList = component.get('v.accountList');
        if(val != "")
        {
            tempAccountList[index].Grade__c = val;
        }
        
        
        console.log('tempAccountList--5-->', tempAccountList);
        
        component.set('v.accountList', tempAccountList);
        
        
    },
    // baseGradeChange : function(component, event){

    //     console.log('v.baseGrade-->',component.get('v.baseGrade'));
    //     // var val = event.getParam("value");

    //     // var index = event.getSource().get('v.name');
    //     // var val = event.getSource().get('v.value');
        
        
        
    //     // console.log('val--->',val);
        
        
    //     // var tempAccountList = component.get('v.accountList');
    //     // if(val != "")
    //     // {
    //     //     tempAccountList[index].Grade__c = val;
    //     // }
        
        
    //     // console.log('tempAccountList--5-->', tempAccountList);
        
    //     // component.set('v.accountList', tempAccountList);
        
        
    // },
    
    
    handleSiteDetails : function(component, event) {
        var valueFromChild = event.getParam("siteInfo");
        var ntptype = event.getParam("ntptype");
        
        console.log('event', event.getParam("ntptype"));
        console.log('valueFromChild-->',valueFromChild);

        
        if(ntptype=='ntpname')
        {
            component.set("v.ntptype",ntptype);
            component.set('v.selectedNtpData',valueFromChild);
        }
        
        if(ntptype=='baseNtpsite')
        {
            component.set("v.baseNtpsite",valueFromChild.value);
           // component.set('v.selectedNtpData',valueFromChild);
        }
        
        var accountList = component.get("v.accountList");
        
        console.log('ntptype-->',ntptype);
        if(valueFromChild.state=='add'){
            if(ntptype=='ntpname'){
                accountList[parseInt(valueFromChild.index)].NTP__c = valueFromChild.value;
            }else{
                accountList[parseInt(valueFromChild.index)].Site__c = valueFromChild.value;
                accountList[parseInt(valueFromChild.index)].selectedSiteData = {label: valueFromChild.label, value: valueFromChild.value};
            }
            
        }else if(valueFromChild.state=='remove'){
            
            if(ntptype=='ntpname'){
                accountList[parseInt(valueFromChild.index)].NTP__c ='';
            }else{
                accountList[parseInt(valueFromChild.index)].Site__c = '';
            }
            
        }

       
        
        component.set("v.accountList",accountList);

        // if(component.get("v.saleODType") == 'Nearest Terminal Port (NTP)')
        // {
        //     let temp_accountList=component.get("v.accountList");
        //     let temp_selectedNtpData =component.get('v.selectedNtpData');

        //     console.log('temp_accountList-->',temp_accountList);
        //     console.log('temp_selectedNtpData-->',temp_selectedNtpData);

        //     if(temp_selectedNtpData && Object.keys(temp_selectedNtpData).length!==0)
        //     {
        //         for(var i=0;i<temp_accountList.length;i++)
        //         {
        //             temp_accountList[i].NTP__c=temp_selectedNtpData.value;
        //         }
        //         component.set('v.accountList',temp_accountList);
        //         console.log('initial accountList-->',accountList);
                
        //     }

        // }
        
        // console.log('handleSiteDetails--accountList-->', accountList);
        
    },
    
    
    addRow: function(component, event, helper) {
        
        var aList = component.get("v.accountList");       
        console.log('aList-->',aList);

        // var filled=true;
        // var colSiteCssFilled=true;
        // var colQuantityCssFilled=true;
        // var colGradeCssFilled=true;
        // for(var i=0;i<aList.length;i++){
            
        //     console.log('aList[i].Site__c-->',aList[i].Site__c);
        //     console.log('aList[i].Quantity__c-->',aList[i].Quantity__c);
        //     console.log('aList[i].Grade__c-->',aList[i].Grade__c);

        //     if(aList[i].Site__c===''||aList[i].Site__c===null||aList[i].Site__c===undefined )
        //     {
        //         aList[i].colSiteCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colSiteCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colSiteCss="";    
        //         colSiteCssFilled=true;            
        //     }
            
        //     if(component.get("v.saleODType")!='Nearest Terminal Port (NTP)' && (aList[i].Quantity__c===''||aList[i].Quantity__c===null||aList[i].Quantity__c===undefined ))
        //     {
        //         aList[i].colQuantityCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colQuantityCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colQuantityCss="";  
        //         colQuantityCssFilled=true;              
        //     }
            
        //     if(aList[i].Grade__c===''||aList[i].Grade__c===null||aList[i].Grade__c===undefined )
        //     {
        //         aList[i].colGradeCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colGradeCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colGradeCss="";  
        //         colGradeCssFilled=true;              
        //     }
            
            
        //     filled=colSiteCssFilled && colQuantityCssFilled && colGradeCssFilled;
            
        //     //when many rows has one invalid record.It will stop to add new row.
        //     if(!filled)
        //     {
        //         break;
        //     }
                        
         
        // }
        
        component.set('v.accountList',aList);
        // if(filled)
        // {             
            console.log('accountList-->', component.get('v.accountList'));
            helper.addAccountRecord(component, event);
       // }



        // if(component.get("v.saleODType") == 'Nearest Terminal Port (NTP)')
        // {
        //     let temp_accountList=component.get("v.accountList");
        //     let temp_selectedNtpData =component.get('v.selectedNtpData');

        //     //console.log("temp_accountList-->",temp_accountList);
        //     //console.log("temp_selectedNtpData-->",temp_selectedNtpData);
        //     //console.log("temp_selectedNtpDataLength-->",Object.keys(temp_selectedNtpData));

        //     if(temp_selectedNtpData && Object.keys(temp_selectedNtpData).length!==0)
        //     {
        //         for(var i=0;i<temp_accountList.length;i++)
        //         {
        //             temp_accountList[i].NTP__c=temp_selectedNtpData.value;
        //         }
        //         component.set('v.accountList',temp_accountList);
        //     }

        // }
        
    },
    
    addRowDuplicateSite: function(component, event, helper) {
        console.log('addRowDuplicateSite-->');
        var aList = component.get("v.accountList");       
        //console.log('aList-->',aList);
        
        
        // var filled=true;
        // var colSiteCssFilled=true;
        // var colQuantityCssFilled=true;
        // var colGradeCssFilled=true;
        // for(var i=0;i<aList.length;i++){

        //     console.log('aList[i].Site__c',aList[i].Site__c);
        //     console.log('aList[i].Quantity__c',aList[i].Quantity__c);
        //     console.log('aList[i].Grade__c',aList[i].Grade__c);
            
        //     if(aList[i].Site__c===''||aList[i].Site__c===null||aList[i].Site__c===undefined )
        //     {
        //         aList[i].colSiteCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colSiteCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colSiteCss="";    
        //         colSiteCssFilled=true;            
        //     }            
          
            
        //     if(aList[i].Grade__c===''||aList[i].Grade__c===null||aList[i].Grade__c===undefined )
        //     {
        //         aList[i].colGradeCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colGradeCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colGradeCss="";  
        //         colGradeCssFilled=true;              
        //     }
            
            
        //     filled=colSiteCssFilled && colQuantityCssFilled && colGradeCssFilled;
        //     console.log('filled-->',filled);
            
        //     //when many rows has one invalid record.It will stop to add new row.
        //     if(!filled)
        //     {
        //         break;
        //     }
                        
        
        // }
        
        component.set('v.accountList',aList);
        console.log('aList-->',aList);
        
        // if(filled)
        // {             
            
            helper.addAccountWithDuplicateRecord(component, event);
            console.log('aList-->',aList);
        // }
        
    },
    
    
    removeRow: function(component, event, helper) {
        var accountList = component.get("v.accountList");
        if(accountList.length>1)
        {         
            var selectedItem = event.currentTarget;
            var index = selectedItem.dataset.record;
            accountList.splice(index, 1);
            component.set("v.accountList", accountList);
        }
    },
    
    save: function(component, event, helper) {
     
            component.set("v.showSpinner",true);
            var action = component.get("c.insCntrct");

            //need to remove selectedSiteData from the list, create data conversion error.
            let dataToSave=component.get("v.accountList");
            dataToSave.forEach(object => {
                delete object['selectedSiteData'];
              });

            let ntptype=component.get("v.ntptype");
            let baseNtpsite=component.get("v.baseNtpsite");
            let ntpPrice=component.get("v.ntpPrice");
            let ntpSiteQuantity=component.get("v.siteQuantity");
            let selectedNtpData=component.get("v.selectedNtpData");

            let baseGrade=component.get("v.baseGrade");
            let baseSpreads=component.get("v.baseSpreads");
            console.log('save ntptype-->',ntptype);
            console.log('save baseNtpsite-->',baseNtpsite);
            console.log('save ntpPrice-->',ntpPrice);
            console.log('save selectedNtpData-->',JSON.stringify(selectedNtpData));
            console.log('save selectedNtpData-->',JSON.stringify(selectedNtpData));

           let validDataList=[];
           for(let i=0;i<dataToSave.length;i++)
           {
               if(dataToSave[i].Site__c !='' || dataToSave[i].Grade__c!='' || dataToSave[i].Spreads__c!='')
               {
                   validDataList.push(dataToSave[i]);
               }
           }
           dataToSave=[];
           dataToSave=validDataList;

           console.log('validDataList-->',validDataList);

            

            if(component.get("v.saleODType")=='Nearest Terminal Port (NTP)' && component.get('v.spreadDefaultVlue')=='base')
            {
               
               // console.log('on save dataToSave-->',dataToSave);
                
                 let baseRecord=
                     {
                         'sobjectType': 'Contract_Site__c',
                         'Site__c': baseNtpsite,
                         'selectedSiteData': '',                                                
                         'Sale_Origin_Destination__c': component.get("v.saleOrigin") ,
                         'Opportunity__c': component.get("v.recordId"),
                         'gradeOptions': '',
                         'Spreads__c': component.get('v.spreadDefaultVlue'),
                         'NTP__c':selectedNtpData.value,
                         'NTP_Name__c':selectedNtpData.label,
                         'Quantity__c':ntpSiteQuantity,
                         'Site_Price__c':ntpPrice,
                         'Base_Spreads__c':baseSpreads,
                         'Grade__c':baseGrade,
                         'Base_Price__c': (ntpPrice)?ntpPrice:baseNtpsite
                     };
                
                dataToSave=[];
                dataToSave=[baseRecord,...validDataList];

                for(let i=0;i<dataToSave.length;i++)
                {
                    dataToSave[i].NTP_Price__c=ntpPrice;
                    //dataToSave[i].Quantity__c=ntpSiteQuantity;
                  //  dataToSave[i].Site_Price__c=parseInt(ntpPrice) +(isNaN(dataToSave[i].Spreads__c_)?0:parseInt(dataToSave[i].Spreads__c));
                   // console.log('dataToSave[i].Spreads__c_-->',dataToSave[i].Spreads__c_);
                   // console.log('dataToSave[i].Site_Price__c-->',dataToSave[i].Site_Price__c);
                }

                console.log('ntp dataToSave-->',dataToSave);
            }
         
            
            //dataToSave=component.get("v.accountList");
            //console.log('dataToSave-->',dataToSave);
            
            action.setParams({
                "contractList": dataToSave
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('save status-->',state);
                if (state === "SUCCESS") {
                    component.set("v.accountList",null);
                    var accountList = [];
                    accountList.push({
                        'sobjectType': 'Contract_Site__c',
                        'Site__c': '',
                        'selectedSiteData': '',                        
                        'Grade__c': '',
                        'Quantity__c': '0',                        
                        'Price_Offered__c': '',
                        'Price_Target__c': '',
                        'Sale_Origin_Destination__c': component.get("v.saleOrigin") ,
                        'Opportunity__c': component.get("v.recordId"),
                        'colSiteCss':'',
                        'colQuantityCss':'',
                        'colGradeCss':''
                    });
                    component.set("v.accountList", accountList);
                    $A.get('e.force:refreshView').fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "type":"success",
                        "message": "Contract Sites Assigned sucessfully!"
                    });
                    toastEvent.fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                }else{
                    var errors = response.getError();
                    if (errors) {
                        console.log("Errors", errors);
                    }
                    alert(JSON.stringify(response.getError()));
                }
                component.set("v.showSpinner",false);
                
            });
            $A.enqueueAction(action);
        //}
    },
    
    closeModel: function (component, event, helper) {
        component.set("v.accountList",null);
        var accountList = [];
        accountList.push({
            'sobjectType': 'Contract_Site__c',
            'Site__c': '',
            'selectedSiteData': '',                        
            'Grade__c': '',
            'Quantity__c': '0',            
            'Sale_Origin_Destination__c': component.get("v.saleOrigin") ,
            'Opportunity__c': component.get("v.recordId"),
            'colSiteCss':'',
            'colQuantityCss':'',
            'colGradeCss':''
        });
        component.set("v.accountList", accountList);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})