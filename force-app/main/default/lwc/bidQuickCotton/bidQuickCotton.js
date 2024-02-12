import { LightningElement, track, wire} from 'lwc';
import getAllPickListData from '@salesforce/apex/SMSDashboardController.getAllPickListOptions1';
import updateExData from '@salesforce/apex/SMSDashboardController.updateExludedData';
import saveData from '@salesforce/apex/BidQuickCottonController.saveData';
import getAllBidsByBuyerId from '@salesforce/apex/BidQuickCottonController.getAllBidsByBuyerId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class bidQuickCotton extends LightningElement {
 

   @track lineItems = [];
   @track allPicklistOptions;
   @track tempArray = [];
   @track searchResults = [];
   @track thisBuyerNameId;
   @track selectedBuyerId;
   @track thisBuyerId;
   @track isLoading = false;
    @track todayDate=new Date().toISOString();
   @track fakeErrorDetails = {errorMessage: '', isError: false, errorClass: ''};

   searchTerm = '';
   filterToday = false;

   @track cropYearMap = {price1: '2022/2023',price2: '2023/2024',price3: '2024/2025',price4: '2025/2026'};


   connectedCallback(){

    var pickListNames = JSON.stringify(['Commodity__c', 'Grade__c', 'Crop_Year__c', 'Sale_Origin_Destination__c']);
    

    getAllPickListData({pickListNames: pickListNames})
    .then(data => {

        this.tempArray = JSON.parse(data);

       // this.handleAdd();

    })
    .catch(error => {
        this.error = error;
    });


   }

   value21 = '';
   value22 = '';
   value23 = '';
   value24 = '';
   handleValueChanges(event){

        var val = event.detail;
        var index = this.getRealIndex(event.detail.index);

        if(val.type=='grade'){

            this.lineItems[index].Grade__c = event.detail.value;

        }

        if(val.type=='site'){

            if(event.detail.value){
                this.lineItems[index].Site__c = event.detail.value;
                this.lineItems[index].siteDefaultItem = { recordId: event.detail.value, recordName: event.detail.name };

            }else{
                this.lineItems[index].Site__c = undefined;
                this.lineItems[index].siteDefaultItem = undefined;

            }
        }

        if(val.type=='biddercontact'){

            if(event.detail.value){
                this.lineItems[index].Bidders_Contact__c = event.detail.value;
            }else{
                this.lineItems[index].Bidders_Contact__c = undefined;
            }

        }


        if(val.type=='saleorigindestination' && event.detail.value){
            this.lineItems[index].Sale_Origin_Destination__c = event.detail.value;
        }


        if(val.type=='buyernamesearch' && event.detail.value){
            this.lineItems[index].Buyer_Name__c = event.detail.value;
        }

        if(val.type=='buyername'){

            if(event.detail.value){
                this.lineItems[index].Buyer_Name__c = event.detail.value;
            }else{
                this.lineItems[index].Buyer_Name__c = undefined;
            }

        }

        if(val.type=='commodity' && event.detail.value){
            this.lineItems[index].Commodity__c = event.detail.value;
        }

        if(event.detail.type=='price' && event.detail.price && event.detail.cropyear){

            

            if(!this.lineItems[index].cropYearPrices){
                this.lineItems[index].cropYearPrices = [];
            }


            this.lineItems[index].cropYearPrices[event.detail.cropyear] = {year: event.detail.cropyear, price: event.detail.price};




        }

        if(event.detail.type=='pricechange1'){
            //alert(event.detail.value);
            if(index==0){
                this.lineItems[0].price1 = parseFloat(event.detail.value);
            }
            this.changeAllPrice();
        }
        if(event.detail.type=='pricechange2'){

            if(index==0){
                this.lineItems[0].price2 = parseFloat(event.detail.value);
            }
            this.changeAllPrice();

        }
        if(event.detail.type=='pricechange3'){

            if(index==0){
                this.lineItems[0].price3 = parseFloat(event.detail.value);
            }

            this.changeAllPrice();


        }
        if(event.detail.type=='pricechange4'){
            if(index==0){
                this.lineItems[0].price4 = parseFloat(event.detail.value);
            }

            this.changeAllPrice();


        }

        if(event.detail.type=='pricechange'){


            if(event.detail.value){
                this.lineItems[index].Adjustment__c = event.detail.value;
                this.lineItems[index].adjustmentValue2 = event.detail.value;
            }

            if(event.detail.value){

                this.changeAllPrice();


                // var price = 0.00;
            
                // if(!isNaN(event.detail.value))
                //     price = parseFloat(event.detail.value);
    
                // if(this.lineItems[index].price1)
                //     this.lineItems[index].price1 = this.lineItems[0].price1_prior+price;
    
                // if(this.lineItems[index].price2) 
                //     this.lineItems[index].price2 = this.lineItems[0].price2_prior+price;
    
                // if(this.lineItems[index].price3)
                //     this.lineItems[index].price3 = this.lineItems[0].price3_prior+price;
    
                // if(this.lineItems[index].price4)
                //     this.lineItems[index].price4 = this.lineItems[0].price4_prior+price;
            }else{
                
                console.log('this.lineItems-->');
                console.log(this.lineItems);

                this.lineItems[index].price1 = this.lineItems[0].price1_prior;
                this.lineItems[index].price2 = this.lineItems[0].price2_prior;
                this.lineItems[index].price3 = this.lineItems[0].price3_prior;
                this.lineItems[index].price4 = this.lineItems[0].price4_prior;
    

            }


        }

        
        // if(val.type=='price' && event.detail.value){

        //     this.lineItems[index].Price__c = event.detail.value;
        // }
        if(val.type=='startdate' && event.detail.value){

            this.lineItems[index].Delivery_Start_Date__c = event.detail.value;
        }
        if(val.type=='enddate' && event.detail.value){
            // alert( event.detail.value);
            this.lineItems[index].Delivery_End_Date__c = event.detail.value;
        }

        console.log('this.lineItems');
        console.log(this.lineItems);

   }
   handleExcludedSite(event)
   {
    console.log('EVENT TRIGGERED->>'+event.detail.index);
    console.log(event.detail);
   
        
    

    var index = this.getRealIndex(event.detail.index);
    console.log(index);
     if(index!=0){
       if(!event.detail.recordId){

         //  alert('Id is missing');
           
           return false;
       }

       updateExData({ recordId: event.detail.recordId, rand: Math.random() })
       .then(data => {
           this.showNotification('Success', 'The record is excluded successfully', 'success');

            this.handleRowDeletionByIndex(index);

        })
       .catch(error => {
           alert(JSON.stringify(error));
           this.error = error;
       });
    }
       else{
        const evt = new ShowToastEvent({
            title: "Alert!",
            message: "The Base record can not be Excluded.",
            variant: "error",
        });
        this.dispatchEvent(evt);
         //   alert("The Base Row can not be Deleted");

    }


   }
   changeAllPrice(){




    console.log('this.lineItems2-->');
    console.log(this.lineItems);
    var tempArray = [];

    var m = 0;
    for(var item of this.lineItems){

        if(m>0){

            var adjustment_price = 0.00;
            // alert(item.Adjustment__c);
            if(!isNaN(item.adjustmentValue2))
                adjustment_price = parseFloat(item.adjustmentValue2);
    
                if(this.lineItems[0].price1>0)
                {
                    item.price1 = this.lineItems[0].price1 + adjustment_price;
                }
                if(this.lineItems[0].price1<=0||isNaN(this.lineItems[0].price1))
                {
                    item.price1 = 0;
                }
                if(this.lineItems[0].price2>0)
                {
                    item.price2 = this.lineItems[0].price2 + adjustment_price;
                }
                if(this.lineItems[0].price2<=0||isNaN(this.lineItems[0].price2))
                {
                    item.price2 = 0;
                }
                if(this.lineItems[0].price3>0)
                {
                    item.price3 = this.lineItems[0].price3 + adjustment_price;
                }
                 if(this.lineItems[0].price3<=0||isNaN(this.lineItems[0].price3))
                {
                    item.price3 = 0;
                }
                if(this.lineItems[0].price4>0)
                {
                    item.price4 = this.lineItems[0].price4 + adjustment_price;
                }
            if(this.lineItems[0].price4<=0||isNaN(this.lineItems[0].price4))
                {
                    item.price4 = 0;
                }
            
            
            tempArray.push(item);
        }else{
            tempArray.push(item);
        }



        m++;
    }

    this.lineItems = tempArray;

   }

   handleAdd(){
      

        var indexKeys = [];

        for(var item of this.lineItems){
            indexKeys.push(item.index);
        }

        indexKeys.sort().reverse();


        var tempIndex = 0;
        if(indexKeys.length>0){
            tempIndex = indexKeys[0]+1;
        }

// alert(tempIndex);

        var bidObj = { index: tempIndex, 
        allOptions: this.tempArray, 
        buyernameSearchVal: undefined,
        priceTypeDefaultValue: 'Free on Truck (FOT) - Gin Yard',
        siteErrorDetails: {errorMessage: '', isError: false, errorClass: ''}, 
        buyerNameErrorDetails: {errorMessage: '', isError: false, errorClass: ''},  
        bidderContactErrorDetails: {errorMessage: '', isError: false, errorClass: ''}, 
        commodityErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        gradeErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        isGradeRequired: false,
        gradeLabel: 'Grade',
        commodityLabel: 'Commodity',
        cropYearLabel: 'Crop Year',
        priceLabel: 'Price',
        startDateLabel: 'Start Date',
        endDateLabel: 'End Date',
        buyerNameSearchLabel: 'Buyer Name',
        cropYearOptions: this.tempArray.Crop_Year__c,
        priceTypeErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        cropYearErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        priceErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        startDateErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        endDateErrorDetails: {errorMessage: '', isError: false, errorClass: ''},
        RecordName: undefined, 
        gradeDisabled: false, 
        gradeVal: undefined, 
        gradeOptions: [], 
        commodityDefaultValue: 'Cotton - Lint', 
        Commodity__c: 'Cotton - Lint', 
        Sale_Origin_Destination__c: 'Free on Truck (FOT) - Gin Yard',
        commodityOptions: this.tempArray.Commodity__c, 
        commodityVal: undefined, 
        biddercontactOptions: this.tempArray.Contact, 
        biddercontactVal: undefined, 
        buyernameOptions: this.tempArray.Account, 
        buyernameVal: undefined, 
        priceTypeOptions: this.tempArray.Sale_Origin_Destination__c, 
        priceTypeVal: undefined,
        price1: 0.00,
        price2: 0.00,
        price3: 0.00,
        price4: 0.00,
        price1_prior: 0.00,
        price2_prior: 0.00,
        price3_prior: 0.00,
        price4_prior: 0.00,
        adjustmentValue2: 0,
        Adjustment__c : 0,
    }
    if(this.thisBuyerId){
        bidObj.Buyer_Name__c = this.thisBuyerId;
    }
       
    this.lineItems.push(bidObj);
       
    this.lineItems[0].adjustmentValue2 = 'Base';
    this.lineItems[0].adjustmentDisabled = true;

   }
  
   handleBuyerNameChangeForSearch(event){

    this.lineItems = [];
    var val = event.detail.value;
    this.thisBuyerNameId = val;
    this.thisBuyerId = val;
    this.selectedBuyerId = val;
    this.isLoading = true;
    if(val){
        this.getBidData(this.selectedBuyerId, this.filterToday);
    }else{
        
        this.connectedCallback();
    }
    this.isLoading = false;
    }

    getBidData(val, todayFilter){
        var tempIndex = 0;

getAllBidsByBuyerId({buyerId: val, rand: Math.random(), filterToday: todayFilter})
    .then(data => {
        var tempArray = JSON.parse(data);

        if(tempArray.length==0){
            this.connectedCallback();
        }
        console.log('main tempArray-->');
        console.log(tempArray);
        this.lineItems = [];


        
        var tempArray3 = [];

        // grouped by site, sale origin destination and commodity
        for(var ta of tempArray){

            var key = ta.Site__c+'-'+ta.Sale_Origin_Destination__c+'-'+ta.Commodity__c;

            if(!tempArray3[key]){
                tempArray3[key] = [];
            }

            tempArray3[key].push(ta);

        }


        for(var k in tempArray3){


            var tempObj = {
                Id: tempArray3[k][0].Id,
                Site__c: tempArray3[k][0].Site__c,
                index: tempIndex,
                allOptions: this.tempArray,
                siteDefaultItem: { recordId: tempArray3[k][0].Site__c, recordName: tempArray3[k][0].Site__r.Name },
                // adjustmentValue2: tempArray3[k][0].Adjustment__c=='Base'?'':tempArray3[k][0].Adjustment__c,
                adjustmentValue2: tempArray3[k][0].Adjustment__c,
                Adjustment__c : tempArray3[k][0].Adjustment__c,
                priceTypeDefaultValue: 'Free on Truck (FOT) - Gin Yard',
                commodityDefaultValue: 'Cotton - Lint',
                Commodity__c: 'Cotton - Lint',
                Sale_Origin_Destination__c: 'Free on Truck (FOT) - Gin Yard',
                createdDateDefaultValue: tempArray3[k][0].Default_Date_Time__c,
                priceTypeOptions: this.tempArray.Sale_Origin_Destination__c,
                commodityOptions: this.tempArray.Commodity__c, 
                buyernameSearchVal: undefined,
                siteErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                buyerNameErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                bidderContactErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                commodityErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                gradeErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                isGradeRequired: false,
                gradeLabel: 'Grade',
                commodityLabel: 'Commodity',
                cropYearLabel: 'Crop Year',
                priceLabel: 'Price',
                startDateLabel: 'Start Date',
                endDateLabel: 'End Date',
                buyerNameSearchLabel: 'Buyer Name',
                cropYearOptions: this.tempArray.Crop_Year__c,
                priceTypeErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                cropYearErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                priceErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                startDateErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                endDateErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
                RecordName: undefined,
                gradeDisabled: false,
                gradeVal: undefined,
                gradeOptions: [],
                commodityVal: undefined,
                biddercontactVal: undefined,
                buyernameVal: undefined,
                priceTypeVal: undefined,
                Bidders_Contact__c: ta.Bidders_Contact__c,
            
            };

if(tempArray3[k].length > 1) {
    tempObj.createdDateDefaultValue=tempArray3[k][1].Default_Date_Time__c;
}

            if (tempArray3[k][0].Bidders_Contact__c) {
                tempObj.bidderContactDefaultValue = { recordId: tempArray3[k][0].Bidders_Contact__c, recordName: tempArray3[k][0].Bidders_Contact__r.Name };
            }


            for(var item of tempArray3[k]){

                for(var m in this.cropYearMap){

                    console.log(item.Crop_Year__c+'=='+this.cropYearMap[m]);

                    if(item.Crop_Year__c && item.Crop_Year__c==this.cropYearMap[m]){
                        tempObj[m] = item.Price__c;
                        if(m=='price1'){
                            tempObj.price1 = item.Price__c;
                            tempObj.price1_prior = item.Price__c;
                        }
                        if(m=='price2'){
                            tempObj.price2 = item.Price__c;
                            tempObj.price2_prior = item.Price__c;
                        }
                        if(m=='price3'){
                            tempObj.price3 = item.Price__c;
                            tempObj.price3_prior = item.Price__c;
                        }
                        if(m=='price4'){
                            tempObj.price4 = item.Price__c;
                            tempObj.price4_prior = item.Price__c;
                        }
                    }
                }


            }

            this.lineItems.push(tempObj);
            
           // alert(tempObj.index);

           // console.log(tempObj);

            tempIndex = tempIndex+1;

        }

        // if(tempArray3.length==0){
        //     this.handleAdd();
        // }else{
        //     this.lineItems = tempObj;
        // }
        if(this.lineItems.length==0){
            this.handleAdd();
        }
        

        var baseFound = false;

        var tempArray4 = [];

        var new_index = 0;

        for(var item of this.lineItems){
            if(item.adjustmentValue2=='Base'){
                item.index = new_index;
                tempArray4.push(item);
                baseFound = true;
            }
        }

        for(var item of this.lineItems){
            if(item.adjustmentValue2!='Base'){
                new_index++;
                item.index = new_index;
                tempArray4.push(item);
            }
        }

       
        this.lineItems = tempArray4;

        if(baseFound==false){
            this.lineItems[0].adjustmentValue = 'Base';
            this.lineItems[0].adjustmentValue2 = 'Base';    
        }

        this.lineItems[0].adjustmentDisabled = true;
        console.log('this.lineItems');
        console.log(this.lineItems);

    })
    .catch(error => {
        this.error = error;
    });

    }

    handleSiteAdd() {
        var tempIndex = 0;
        if (this.lineItems.length > 0) {
            tempIndex = this.lineItems[this.lineItems.length - 1].index + 1;
        }


        var bidObj = {
            index: tempIndex,
            allOptions: this.tempArray,
            buyernameSearchVal: undefined,
            siteDefaultItem: {recordId: undefined, recordName: undefined},
            siteErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            buyerNameErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            bidderContactErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            commodityErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            gradeErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            isGradeRequired: false,
            Commodity__c: 'Cotton - Lint',
            Sale_Origin_Destination__c: 'Free on Truck (FOT) - Gin Yard',
            priceTypeDefaultValue: 'Free on Truck (FOT) - Gin Yard',
            commodityDefaultValue: 'Cotton - Lint',
            gradeLabel: 'Grade',
            commodityLabel: 'Commodity',
            cropYearLabel: 'Crop Year',
            priceLabel: 'Price',
            startDateLabel: 'Start Date',
            endDateLabel: 'End Date',
            buyerNameSearchLabel: 'Buyer Name',
            cropYearOptions: this.tempArray.Crop_Year__c,
            priceTypeErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            cropYearErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            priceErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            startDateErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            endDateErrorDetails: { errorMessage: '', isError: false, errorClass: '' },
            RecordName: undefined,
            gradeDisabled: false,
            gradeVal: undefined,
            gradeOptions: [],
            commodityOptions: this.tempArray.Commodity__c,
            commodityVal: undefined,
            biddercontactOptions: this.tempArray.Contact,
            biddercontactVal: undefined,
            buyernameOptions: this.tempArray.Account,
            buyernameVal: undefined,
            priceTypeOptions: this.tempArray.Sale_Origin_Destination__c,
            priceTypeVal: undefined,
        }

        if(this.lineItems.length>0){
            bidObj
            bidObj.siteDefaultItem = this.lineItems[0].siteDefaultItem;
            bidObj.Site__c = this.lineItems[0].Site__c;
            bidObj.Buyer_Name__c = this.thisBuyerId;
            bidObj.price1 = this.lineItems[0].price1;
            bidObj.price2 = this.lineItems[0].price2;
            bidObj.price3 = this.lineItems[0].price3;
            bidObj.price4 = this.lineItems[0].price4;
            bidObj.price1_prior = this.lineItems[0].price1_prior;
            bidObj.price2_prior = this.lineItems[0].price2_prior;
            bidObj.price3_prior = this.lineItems[0].price3_prior;
            bidObj.price4_prior = this.lineItems[0].price4_prior;
        }
        // else{
        //     bidObj.siteDefaultItem = {recordId: ta.Site__c, recordName: ta.Site__r.Name};
        // }

        this.lineItems.push(bidObj);
        this.lineItems[0].adjustmentValue2 = 'Base';
        this.lineItems[0].adjustmentDisabled = true;

    }


   handleRowDeletion(event){

    console.log(event.detail);
   
        
    

    var index = this.getRealIndex(event.detail);
    console.log(index);

    if(index!=0)
    {
// alert(event.detail);

    var tempArray = [];
    for(var item of this.lineItems){
    if(item.index!=event.detail){

        tempArray.push(item);
    }
    
     }

     this.lineItems = tempArray;
    }
    else{
        const evt = new ShowToastEvent({
            title: "Alert!",
            message: "The Base record can not be Deleted.",
            variant: "error",
        });
        this.dispatchEvent(evt);
         //   alert("The Base Row can not be Deleted");

    }
        

    //    if(this.lineItems.length>1)
    //        this.lineItems.splice(event.detail, 1);

   }
 
   getRealIndex(index){

    var thisIndex = 0;

    for(var ind in this.lineItems){
        if(this.lineItems[ind].index==index){
            thisIndex = ind;
        }
    }
    return thisIndex;
   }

   handleRowDeletionByIndex(index){
 
    if(this.lineItems.length>1){
        this.lineItems.splice(index, 1);
    }else if(this.lineItems.length==1){
        window.location.reload();
    }

}


   handleRowSelection(event){
 

       var index = this.getRealIndex(event.detail.index);
 
       this.lineItems[index] = {index: index, recordId: event.detail.recordId, recordName: event.detail.recordName};
 
   }

   handleCheckboxChange(event) {
    this.isLoading = true;
    if(this.thisBuyerId){
        this.lineItems = [];
        this.filterToday = event.target.checked;
        this.getBidData(this.selectedBuyerId, this.filterToday);
    }else{
        //alert('Please add a buyer name');
    }
    this.isLoading = false;
}



   handleSaveClick(event){
    


        var tempArray = [];

        var isErrorHappened = false;
     

        console.log('this.lineItems-->');
        console.log(this.lineItems);

        var m = 0;

        for(var item of this.lineItems){

            console.log('item-->');
            console.log(item);
            var baseVal = false;
            if(m==0){
                baseVal = true;
                item.Adjustment__c = 'Base';
            }

            

            if(item.price1>0){
                tempArray.push({Sale_Origin_Destination__c: item.Sale_Origin_Destination__c,Bidders_Contact__c: item.Bidders_Contact__c, Site__c: item.Site__c, Buyer_Name__c: this.thisBuyerNameId, Commodity__c:item.Commodity__c, Grade__c: 'Australian Raw Cotton - Base 31-3-36', Crop_Year__c: this.cropYearMap.price1, Price__c: parseFloat(item.price1), Adjustment__c: item.Adjustment__c});
            }
            
            if(item.price2>0){
                tempArray.push({Sale_Origin_Destination__c: item.Sale_Origin_Destination__c,Bidders_Contact__c: item.Bidders_Contact__c, Site__c: item.Site__c, Buyer_Name__c: this.thisBuyerNameId, Commodity__c:item.Commodity__c, Grade__c: 'Australian Raw Cotton - Base 31-3-36', Crop_Year__c: this.cropYearMap.price2, Price__c: parseFloat(item.price2), Adjustment__c: item.Adjustment__c});
            }
            
            if(item.price3>0){
                tempArray.push({Sale_Origin_Destination__c: item.Sale_Origin_Destination__c,Bidders_Contact__c: item.Bidders_Contact__c, Site__c: item.Site__c, Buyer_Name__c: this.thisBuyerNameId, Commodity__c:item.Commodity__c, Grade__c: 'Australian Raw Cotton - Base 31-3-36', Crop_Year__c: this.cropYearMap.price3, Price__c: parseFloat(item.price3), Adjustment__c: item.Adjustment__c});
            }
            
            if(item.price4>0){
                tempArray.push({Sale_Origin_Destination__c: item.Sale_Origin_Destination__c,Bidders_Contact__c: item.Bidders_Contact__c, Site__c: item.Site__c, Buyer_Name__c: this.thisBuyerNameId, Commodity__c:item.Commodity__c, Grade__c: 'Australian Raw Cotton - Base 31-3-36', Crop_Year__c: this.cropYearMap.price4, Price__c: parseFloat(item.price4), Adjustment__c: item.Adjustment__c});
            }

            // for(var itm of item.cropYearPrices[item]){

            //     alert(JSON.stringify(this.lineItems[itm].cropYearPrices));
            //     alert('test');
            if (item.Site__c == undefined || item.Site__c == '') {
                item.siteErrorDetails.errorMessage = 'Site required';
                item.siteErrorDetails.isError = true;
                item.siteErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.siteErrorDetails.errorMessage = '';
                item.siteErrorDetails.isError = false;
                item.siteErrorDetails.errorClass = '';
            }
            // if((item.Buyer_Name__c==undefined || item.Buyer_Name__c=='') && (item.Bidders_Contact__c==undefined || item.Bidders_Contact__c=='')){
            //         item.buyerNameErrorDetails.errorMessage = 'Buyer Name or Bidders Contact required';
            //         item.buyerNameErrorDetails.isError = true;
            //         item.buyerNameErrorDetails.errorClass = 'slds-has-error';
            //         isErrorHappened = true;
            //     }else{
            //         item.buyerNameErrorDetails.errorMessage = '';
            //         item.buyerNameErrorDetails.isError = false;
            //         item.buyerNameErrorDetails.errorClass = '';
            //         item.bidderContactErrorDetails.errorMessage = '';
            //         item.bidderContactErrorDetails.isError = false;
            //         item.bidderContactErrorDetails.errorClass = '';
            //     }
            if (item.Commodity__c == undefined || item.Commodity__c == '') {
                item.commodityErrorDetails.errorMessage = 'Commodity required';
                item.commodityErrorDetails.isError = true;
                item.commodityErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.commodityErrorDetails.errorMessage = '';
                item.commodityErrorDetails.isError = false;
                item.commodityErrorDetails.errorClass = '';
            }
            if (item.Sale_Origin_Destination__c == undefined || item.Sale_Origin_Destination__c == '') {
                item.priceTypeErrorDetails.errorMessage = 'Sale Origin Destination required';
                item.priceTypeErrorDetails.isError = true;
                item.priceTypeErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.priceTypeErrorDetails.errorMessage = '';
                item.priceTypeErrorDetails.isError = false;
                item.priceTypeErrorDetails.errorClass = '';
            }

            // }

            m++;
        }


        console.log('tempArray1-->');
        console.log(tempArray);



        if(isErrorHappened==false){

            console.log('tempArray2-->');
            console.log(tempArray);



            saveData({records: JSON.stringify(tempArray), rand: Math.random(), saveDate: new Date(this.todayDate)})
            .then(data => {
                this.showNotification('Success', 'Records saved successfully', 'success');
                window.location.href = "/lightning/n/Bid_Dashboard";
            })
            .catch(error => {
                alert(JSON.stringify(error));
                this.error = error;
            } );
        }else{
            this.showNotification('Error', 'Please fill all required fields', 'error');
        }
    }

    showNotification(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(toastEvent);
    }


    handleChangeSaveDateTime(event)
    {
        this.todayDate=event.detail.value;
        
    }
}