({	
    
    init: function(component, event, helper) {

        component.set("v.showSpinner",true);
        component.set("v.accountList",null);        

        //check commodity Destination Has Existing Record

        var spreadDefaultVlue='base';
        var action = component.get("c.acdHasExistingAvailableStock");
        action.setParams({
            "asdId": component.get("v.recordId")
        });
        console.log('acdHasExistingAvailableStock');

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



       // var accountList = [];
       
        var action = component.get("c.fetchSaleODType");
        action.setParams({
            "recId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('fetchSaleODType-->state-->',state);
            if (state === "SUCCESS") {                

                        var dt  = response.getReturnValue();
                        component.set("v.saleODType", dt.Sale_Origin_Destination__c);
                        component.set("v.contractType", dt.Contract_Type_picklist__c);
                        console.log('saleODType',component.get('v.saleODType'));

                    
                    }
                    component.set("v.showSpinner",false);
                    
                });
                
                $A.enqueueAction(action);

            

        // picklist


        // var action = component.get("c.fetchSaleODType");
        // action.setParams({
        //     "recId": component.get("v.recordId")
        // });
        // action.setCallback(this, function(response) {
        //     var state = response.getState();
        //     if (state === "SUCCESS") {
        //         var dt  = response.getReturnValue();
        //         console.log('dt--->');
        //         console.log(dt);

        //         //component.set("v.saleODType", dt);
        //         component.set("v.saleODType", dt.Sale_Origin_Destination__c);
        //         component.set("v.contractType", dt.Contract_Type__c);

        //     }
        //     component.set("v.showSpinner",false);

        // });

        // $A.enqueueAction(action);

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
                component.set("v.gradeOptions", tempOpt1);

                accountList.push({
                    'sobjectType': 'AS_Commodity_Dest_for_Stock__c',
                    'Site__c': '',
                    'selectedSiteData': '',       
                    'Grade_Commodity_Destination__c': '',
                    'Quantity__c': '0',
                    'Site_Price__c': '',
                    'Price_Offered__c': '',
                    'Price_Target__c': '',
                    'Sale_Origin_Destination__c': component.get("v.saleODType") ,
                    'Stock__c': component.get("v.recordId"),
                    'gradeOptions': tempOpt1,
                    'Spreads__c': component.get("v.saleODType")=='Nearest Terminal Port (NTP)'?'': spreadDefaultVlue,
                    'colSiteCss':'',
                    'colQuantityCss':'',
                    'colGradeCssFilled':'',
                    'colPriceOfferedCss':'',
                    'colPriceTargetCss':'',
                    'colSitePriceCss':''
                });
                component.set("v.accountList",accountList);
            }
            component.set("v.showSpinner",false);

        });

        $A.enqueueAction(action);

        var action = component.get("c.picklistValues");
        action.setParams({
            "objectName": "Stock__c",
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
        console.log('',component.get('v.saleODType'));
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

        console.log('tempAccountList-->', tempAccountList);

        component.set('v.accountList', tempAccountList);


    },

    gradeChange : function(component, event){
        // var val = event.getParam("value");
        var index = event.getSource().get('v.name');
        var val = event.getSource().get('v.value');



        // console.log('val--->');
        // console.log(val.join(';'));

        var tempAccountList = component.get('v.accountList');
        if(val != "")
        {
            tempAccountList[index].Grade_Commodity_Destination__c = val;

        }
       
        console.log('tempAccountList--5-->', tempAccountList);

        component.set('v.accountList', tempAccountList);


    },


    handleSiteDetails : function(component, event) {
        var valueFromChild = event.getParam("siteInfo");
        var ntptype = event.getParam("ntptype");

        console.log('event', event.getParam("ntptype"));
        console.log('valueFromChild-->', valueFromChild);
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


        console.log('accountList', accountList);

    },
    

    addRow: function(component, event, helper) {

        // console.log('accountList-->', component.get('v.accountList'));
        // helper.addAccountRecord(component, event);

        var aList = component.get("v.accountList");       
        console.log('aList-->',aList);
        // console.log('saleODType-->',component.get("v.saleODType"));
        // var saleODType=component.get("v.saleODType");
        // if(saleODType ==='Ex-Farm/FOT')
        // if(saleODType !=='Ex-Farm/FOT')
        // if(saleODType =='Nearest Terminal Port (NTP)')
        // if(saleODType !='Nearest Terminal Port (NTP)')
        
        
        
        // var filled=true;
        // var colSiteCssFilled=true;        
        // var colGradeCssFilled=true;
        
        // for(var i=0;i<aList.length;i++){
            

        //     console.log("aList[i].Site__c-->",aList[i].Site__c);
        //     //console.log("aList[i].Quantity__c-->",aList[i].Quantity__c);
        //     console.log("aList[i].Site_Price__c-->",aList[i].Site_Price__c);
        //     //console.log("aList[i].Price_Offered__c-->",aList[i].Price_Offered__c);
        //     //console.log("aList[i].Price_Target__c-->",aList[i].Price_Target__c);

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
            
            // if(aList[i].Quantity__c===''||aList[i].Quantity__c===null||aList[i].Quantity__c===undefined )
            // {
            //     aList[i].colQuantityCss="slds-box slds-has-error slds-theme_alert-texture";
            //     colQuantityCssFilled=false;
            // }
            // else
            // {
            //     aList[i].colQuantityCss="";  
            //     colQuantityCssFilled=true;              
            // }

            // if(aList[i].Grade_Commodity_Destination__c===''||aList[i].Grade_Commodity_Destination__c===null||aList[i].Grade_Commodity_Destination__c===undefined )
            // {
            //     aList[i].colGradeCss="slds-box slds-has-error slds-theme_alert-texture";
            //     colGradeCssFilled=false;
            // }
            // else
            // {
            //     aList[i].colGradeCss="";  
            //     colGradeCssFilled=true;              
            // }

            
            // if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)' && aList[i].Price_Offered__c && aList[i].Price_Target__c)
            // {
            //     filled=false;
            //     aList[i].colPriceOfferedCss="slds-box slds-has-error slds-theme_alert-texture";
            //     aList[i].colPriceTargetCss="slds-box slds-has-error slds-theme_alert-texture";

            //     var toastEvent = $A.get("e.force:showToast");
            //     toastEvent.setParams({
            //         "title": "Warning!",
            //         "message": "You have entered a value in both the ‘Price Offered’ & ‘Price Target’ fields. You can only enter a value in one field. Please remove a value for the non-require field and resave", 
            //         "type": "warning"
            //     });
            //     toastEvent.fire(); 
            //     console.log('both has value-->',aList[i].Price_Offered__c);


            //     break;
            // }

            // if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)' && (!aList[i].Price_Offered__c && !aList[i].Price_Target__c))
            // {
            //     console.log('both has no value');
            //     filled=false;
            //     aList[i].colPriceOfferedCss="slds-box slds-has-error slds-theme_alert-texture";
            //     aList[i].colPriceTargetCss="slds-box slds-has-error slds-theme_alert-texture";
            //     break;
                
            // }
            // if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)' && (aList[i].Price_Offered__c  || aList[i].Price_Target__c))
            // {
            //     console.log('single has a value');
            //     filled=true;
            //     aList[i].colPriceOfferedCss="";
            //     aList[i].colPriceTargetCss="";
                
                
            // }
            
        //     filled=colSiteCssFilled && colGradeCssFilled;   
            
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
        
    },

    addRowDuplicateSite: function(component, event, helper) {
        console.log('addRowDuplicateSite-->');
        //var aList = component.get("v.accountList");       
        //console.log('aList-->',aList);
        
        
        // var filled=true;
        // var colSiteCssFilled=true;
        // var colGradeCssFilled=true;
        
        

        // for(var i=0;i<aList.length;i++){
            

           // console.log("aList[i].Site__c-->",aList[i].Site__c);
            //console.log("aList[i].Quantity__c-->",aList[i].Quantity__c);
            //console.log("aList[i].Site_Price__c-->",aList[i].Site_Price__c);
            //console.log("aList[i].Grade_Commodity_Destination__c-->",aList[i].Grade_Commodity_Destination__c);
          //  console.log("aList[i].Price_Offered__c-->",aList[i].Price_Offered__c);
          //  console.log("aList[i].Price_Target__c-->",aList[i].Price_Target__c);
           // console.log("component.get(v.saleODType)-->",component.get("v.saleODType"));

            //if(aList[i].Site__c===''||aList[i].Site__c===null||aList[i].Site__c===undefined )
            //{
                
            //     aList[i].colSiteCss="slds-box slds-has-error slds-theme_alert-texture";
            //     colSiteCssFilled=false;
            // }
            // else
            // {
        //         aList[i].colSiteCss="";    
        //         colSiteCssFilled=true;            
        //     }           
          

        //     if(aList[i].Grade_Commodity_Destination__c===''||aList[i].Grade_Commodity_Destination__c===null||aList[i].Grade_Commodity_Destination__c===undefined )
        //     {
        //         aList[i].colGradeCss="slds-box slds-has-error slds-theme_alert-texture";
        //         colGradeCssFilled=false;
        //     }
        //     else
        //     {
        //         aList[i].colGradeCss="";  
        //         colGradeCssFilled=true;              
        //     }
        //     filled=colSiteCssFilled  && colGradeCssFilled;   
            
        //     if(!filled)
        //     {
        //         break;
        //     }
            
        // }

        // var colPriceOffered=true;
        // var colPriceTarget=true;
        // var colQuantityCssFilled=true;

        // if(filled && component.get("v.saleODType") === 'Nearest Terminal Port (NTP)')
        // {
        //     if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)' && ($A.util.isEmpty(component.get("v.priceOffered"))
        //     && $A.util.isEmpty(component.get("v.priceTarget"))))
        //     {
        //         console.log('both has value');
        //         filled=false;
        //         component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');
        //         component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');
              

        //         var toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({
        //             "title": "Warning!",
        //             "message": "You have entered a value in both the ‘Price Offered’ & ‘Price Target’ fields. You can only enter a value in one field. Please remove a value for the non-require field and resave", 
        //             "type": "warning"
        //         });
        //         toastEvent.fire(); 
               
        //     }

        //     if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)' && (!$A.util.isEmpty(component.get("v.priceOffered"))
        //     && !$A.util.isEmpty(component.get("v.priceTarget"))))
        //     {
        //         console.log('both has no value');
        //         filled=false;
               
        //         component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');
        //         component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');
                
                
        //     }
        //     if( component.get("v.saleODType") === 'Nearest Terminal Port (NTP)')
        //     {
        //         console.log('single has a value');
        //         filled=true;
        //         // aList[i].cssPriceOffered="";
        //         // aList[i].cssPriceTarget="";
        //         component.set("v.cssPriceOffered",'');
        //         component.set("v.cssPriceTarget",'');
                
                
        //     }
        // }
        
       // component.set('v.accountList',aList);       
        //console.log('aList-->',aList);
        //console.log('filled-->',filled);
        
        // if(filled)
        // {             
            //console.log('accountList-->', component.get('v.accountList'));
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
        
        // var aList = component.get("v.accountList");
        // for(var i=0;i<aList.length;i++){
        //     var titleField = component.find("row")[i];
        //     $A.util.removeClass(component.find("row"), 'slds-box slds-has-error slds-theme_alert-texture');
        //     $A.util.removeClass(titleField, 'slds-box slds-has-error slds-theme_alert-texture');
            
        // }

        // console.log('aList-->',aList);

        
        // var filled=true;
        // for(var i=0;i<aList.length;i++){
            
        //     var inputField = component.find("row")[i];
        //     var titleField = component.find("row")[i];
        //     $A.util.removeClass(component.find("row"), 'slds-box slds-has-error slds-theme_alert-texture');
        //     $A.util.removeClass(titleField, 'slds-box slds-has-error slds-theme_alert-texture');
        //     //
        //     if(aList[i].Site__c===''||aList[i].Site__c===null|| aList[i].Grade_Commodity_Destination__c===''||aList[i].Grade_Commodity_Destination__c===null||aList[i].Grade_Commodity_Destination__c===undefined){
        //         filled=false;
        //         $A.util.addClass(titleField, 'slds-box slds-has-error slds-theme_alert-texture');
        //         $A.util.addClass(component.find("row"), 'slds-box slds-has-error slds-theme_alert-texture');
        //     } 

            // if(component.get("v.saleODType") == 'Nearest Terminal Port (NTP)' && (aList[i].Price_Offered__c===''||aList[i].Price_Offered__c===null||aList[i].Price_Target__c===''||aList[i].Price_Target__c===null)){
            //     filled=false;
            //     $A.util.addClass(titleField, 'slds-box slds-has-error slds-theme_alert-texture');
            //     $A.util.addClass(component.find("row"), 'slds-box slds-has-error slds-theme_alert-texture');
            // } 
            
        //}

        // if(filled && component.get("v.saleODType")=='Nearest Terminal Port (NTP)' )
        // {
        //     console.log('component.get("v.siteQuantity")-->',component.get("v.siteQuantity"));
        //     console.log('component.get("v.cssSiteQuantity")-->',component.get("v.cssSiteQuantity"));
        //     console.log('component.get("v.cssSiteQuantity")-->',$A.util.isEmpty(component.get("v.cssSiteQuantity")));

        //     component.set("v.cssPriceOffered",'');
        //     component.set("v.cssPriceTarget",''); 

        //     if(!$A.util.isEmpty(component.get("v.priceOffered")) && !$A.util.isEmpty(component.get("v.priceTarget")))
        //     {
        //        component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');
        //        component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');
        //        filled=false;

        //         var toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({
        //             "title": "Warning!",
        //             "message": "You have entered a value in both the ‘Price Offered’ & ‘Price Target’ fields. You can only enter a value in one field. Please remove a value for the non-require field and resave", 
        //             "type": "warning"
        //         });
        //         toastEvent.fire(); 
                
        //     }

        //     if($A.util.isEmpty(component.get("v.priceOffered")) && $A.util.isEmpty(component.get("v.priceTarget")))
        //     {
        //        component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');
        //        component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');  
        //        filled=false;             
                
        //     }          
           

            
        //     if($A.util.isEmpty(component.get("v.siteQuantity")))
        //     {
        //         component.set("v.cssSiteQuantity",'slds-box slds-has-error slds-theme_alert-texture');
        //         filled=false;
                
        //     }
        //     else
        //     {
        //         component.set("v.cssSiteQuantity",'');
        //     }

        //     console.log("priceOffered-->",component.get("v.priceOffered"));
        //     console.log("cssPriceTarget-->",component.get("v.cssPriceTarget"));
        
        //console.log('$A.util.isEmpty(component.get("v.ntpPrice"))-->',$A.util.isEmpty(component.get("v.ntpPrice")));
        
       
            
            //filled=!$A.util.isEmpty(component.get("v.priceOffered")) && !$A.util.isEmpty(component.get("v.priceTarget")) && !$A.util.isEmpty(component.get("v.siteQuantity"));
            //console.log('filled-->',filled);
        //}



        // if(filled===false){
        //     var toastEvent = $A.get("e.force:showToast");
        //     toastEvent.setParams({
        //         "title": "Warning!",
        //         "message": "Please fill in all the required fields and then create the contract sites!", 
        //         "type": "warning"
        //     });
        //     toastEvent.fire(); 
        // }else{

        /**
         * For NON-NTP check invalid price-offered and price-target
         */
        if(component.get("v.saleODType")!=='Nearest Terminal Port (NTP)')
        {     

            let aList=component.get("v.accountList");
            let isInValidRecord=false;
            for(var i=0;i<aList.length;i++){
                if((aList[i].Price_Offered__c !=="" && aList[i].Price_Target__c !=="") || (aList[i].Price_Offered__c==="" && aList[i].Price_Target__c===""))
                {
                    aList[i].colPriceOfferedCss="slds-box slds-has-error slds-theme_alert-texture";
                    aList[i].colPriceTargetCss="slds-box slds-has-error slds-theme_alert-texture";
                    isInValidRecord=true;
                }
                else
                {
                    aList[i].colPriceOfferedCss="";
                    aList[i].colPriceTargetCss="";
                }
                
            }

            component.set("v.accountList",aList);

            if(isInValidRecord)
            {
                console.log('isInValidRecord-->',aList);
                return;
            }

            //     filled=false;
            //     aList[i].colPriceOfferedCss="slds-box slds-has-error slds-theme_alert-texture";
            //     aList[i].colPriceTargetCss="slds-box slds-has-error slds-theme_alert-texture";

            //     var toastEvent = $A.get("e.force:showToast");
            //     toastEvent.setParams({
            //         "title": "Warning!",
            //         "message": "You have entered a value in both the ‘Price Offered’ & ‘Price Target’ fields. You can only enter a value in one field. Please remove a value for the non-require field and resave", 
            //         "type": "warning"
            //     });
            //     toastEvent.fire(); 
            //     console.log('both has value-->',aList[i].Price_Offered__c);

       

        }


        if(component.get("v.saleODType")=='Nearest Terminal Port (NTP)' && component.get('v.spreadDefaultVlue')=='base')
        {
            let showWarning=false;

            if($A.util.isEmpty(component.get("v.priceTarget")))
            {
                component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');                
                
            }
            else
            {
                component.set("v.cssPriceTarget",'');
            }

            if($A.util.isEmpty(component.get("v.priceOffered")))
            {
                component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');                
                
            }
            else
            {
                component.set("v.cssPriceOffered",'');
            }

            console.log('component.get("v.cssPriceOffered")-->',component.get("v.cssPriceOffered"));

            showWarning=(component.get("v.cssPriceOffered")!=='' && component.get("v.cssPriceTarget")!=='')|| (component.get("v.cssPriceOffered")==='' && component.get("v.cssPriceTarget")==='');

            if(showWarning)
            {
                component.set("v.cssPriceOffered",'slds-box slds-has-error slds-theme_alert-texture');
                component.set("v.cssPriceTarget",'slds-box slds-has-error slds-theme_alert-texture');
                
                return;
            }
        }
        
            
            component.set("v.showSpinner",true);
            var action = component.get("c.insCntrct");

            //need to remove selectedSiteData from the list, create data conversion error.
            let dataToSave=component.get("v.accountList");
            dataToSave.forEach(object => {
                delete object['selectedSiteData'];
              });


            

            let ntptype=component.get("v.ntptype");
            let baseNtpsite=component.get("v.baseNtpsite");
            //let ntpPrice=component.get("v.ntpPrice");
            let priceOffered=component.get("v.priceOffered");
            let priceTarget=component.get("v.priceTarget");

            console.log('priceOffered-->',priceOffered);
            console.log('priceTarget-->',priceTarget);
           

            let ntpSiteQuantity=component.get("v.siteQuantity");
            let selectedNtpData=component.get("v.selectedNtpData");


            let baseGrade=component.get("v.baseGrade");
            let baseSpreads=component.get("v.baseSpreads");
            console.log('save ntptype-->',ntptype);
            console.log('save priceOffered-->',priceOffered);
            console.log('save selectedNtpData-->',JSON.stringify(selectedNtpData));

            let validDataList=[];
            for(let i=0;i<dataToSave.length;i++)
            {
                if(dataToSave[i].Site__c !='' || dataToSave[i].Grade_Commodity_Destination__c!='' || dataToSave[i].Spreads__c!='')
                {
                    validDataList.push(dataToSave[i]);
                }
            }
            dataToSave=[];
            dataToSave=validDataList;
 
            console.log('validDataList-->',validDataList);
            
            if(component.get("v.saleODType")=='Nearest Terminal Port (NTP)' && component.get('v.spreadDefaultVlue')=='base')
            {
                let baseRecord=
                    {
                        'sobjectType': 'AS_Commodity_Dest_for_Stock__c',
                        'Site__c': baseNtpsite,
                        'selectedSiteData': '',                        
                        'Site_Price__c': '',
                        'Sale_Origin_Destination__c': component.get("v.saleODType") ,
                        'Stock__c': component.get("v.recordId"),
                        'gradeOptions': '',
                        'Spreads__c': component.get('v.spreadDefaultVlue'),
                        'NTP__c':selectedNtpData.value,
                        'NTP_Name__c':selectedNtpData.label,
                        'Quantity__c':ntpSiteQuantity,
                        'Price_Offered__c':priceOffered,
                        'Price_Target__c':priceTarget,
                        'Base_Spreads__c':baseSpreads,
                        'Grade_Commodity_Destination__c':baseGrade,
                    }
                

                dataToSave=[];
                dataToSave=[baseRecord,...validDataList];

                let currentPrice=priceOffered||priceTarget;

                for(let i=0;i<dataToSave.length;i++)
                {
                    dataToSave[i].Price_Offered__c=priceOffered;
                    dataToSave[i].Price_Target__c=priceTarget;
                    dataToSave[i].NTP_Price__c=currentPrice;
                  //  dataToSave[i].Site_Price__c=parseInt(ntpPrice) +(isNaN(dataToSave[i].Spreads__c_)?0:parseInt(dataToSave[i].Spreads__c));
                   // console.log('dataToSave[i].Spreads__c_-->',dataToSave[i].Spreads__c_);
                   // console.log('dataToSave[i].Site_Price__c-->',dataToSave[i].Site_Price__c);
                }

                console.log('ntp dataToSave-->',dataToSave);
            }

            console.log('dataToSave-->',dataToSave);
            //console.log('dataToSave-->',JSON.stringify(dataToSave));
            



            action.setParams({
                "contractList": dataToSave
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.accountList",null);
                    var accountList = [];
                    accountList.push({
                        'sobjectType': 'AS_Commodity_Dest_for_Stock__c',
                        'Site__c': '',
                        'Grade_Commodity_Destination__c': '',
                        'Quantity__c': '0',
                        'Site_Price__c': '',
                        'Price_Offered__c': '',
                        'Price_Target__c': '',
                        'Sale_Origin_Destination__c': component.get("v.saleODType") ,
                        'Stock__c': component.get("v.recordId"),
                        'colSiteCss':'',
                        'colQuantityCss':'',
                        'colGradeCssFilled':'',
                        'colPriceOfferedCss':'',
                        'colPriceTargetCss':'',
                        'colSitePriceCss':''
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
                    console.log(" errors[0].message", JSON.stringify( errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            alert(JSON.stringify( errors[0].message));
                        }
                    }
                    
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
            'sobjectType': 'AS_Commodity_Dest_for_Stock__c',
            'Site__c': '',
            'Grade_Commodity_Destination__c': '',
            'Quantity__c': '',
            'Site_Price__c': '',
            'Sale_Origin_Destination__c': component.get("v.saleODType") ,
            'Stock__c': component.get("v.recordId"),
            'colSiteCss':'',
            'colQuantityCss':'',
            'colGradeCssFilled':'',
            'colPriceOfferedCss':'',
            'colPriceTargetCss':'',
            'colSitePriceCss':''
        });
        component.set("v.accountList", accountList);
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },

    
    handlePriceOfferedChange: function(component, event, helper) {
        const inputValue = event.getSource().get('v.value');
        component.find("txtPriceTarget").set("v.disabled",inputValue?true:false); // set value true or false       
    },

    handlePriceTargetChange: function(component, event, helper) {
        const inputValue = event.getSource().get('v.value');
        component.find("txtPriceOffered").set("v.disabled",inputValue?true:false); // set value true or false       
    }

})