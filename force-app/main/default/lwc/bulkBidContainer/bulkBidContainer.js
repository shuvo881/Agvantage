import { LightningElement, track, wire } from 'lwc';
import getAllPickListData from '@salesforce/apex/SMSDashboardController.getAllPickListOptions';
import saveData from '@salesforce/apex/BulkBidController.saveData';
import updateExData from '@salesforce/apex/BulkBidController.updateExludedData';
import getAllBidsByBuyerId from '@salesforce/apex/BulkBidController.getAllBidsByBuyerId';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BulkBidContainer extends LightningElement {

    @track lineItems = [];
    @track allPicklistOptions;
    @track tempArray = [];
    @track searchResults = [];
    @track thisBuyerId;
    @track isLoading = false;

    @track selectedBuyerId;

    @track fakeErrorDetails = { errorMessage: '', isError: false, errorClass: '' };
    @track todayDate=new Date().toISOString();
    searchTerm = '';

    isExclude = false;

    filterToday = false;


    connectedCallback() {

        var pickListNames = JSON.stringify(['Commodity__c', 'Grade__c', 'Crop_Year__c', 'Sale_Origin_Destination__c']);


        getAllPickListData({ pickListNames: pickListNames })
            .then(data => {

                this.tempArray = JSON.parse(data);

                //this.handleAdd();

            })
            .catch(error => {
                this.error = error;
            });

    }

    handleValueChanges(event) {

        var val = event.detail;
        var index = this.getRealIndex(event.detail.index);

        //var index = this.getIndex(event.detail.index);

        if (val.type == 'grade') {

            this.lineItems[index].Grade__c = event.detail.value;
            this.lineItems[index].gradeVal=event.detail.value;
            this.lineItems[index].gradeDefaultValue=event.detail.value;

        }

        if (val.type == 'site') {

            if (event.detail.value) {
                this.lineItems[index].Site__c = event.detail.value;
                this.lineItems[index].siteDefaultItem = {recordId: event.detail.value, recordName: event.detail.name};

            } else {
                this.lineItems[index].Site__c = undefined;
                this.lineItems[index].siteDefaultItem = undefined;

            }
        }

        if (val.type == 'biddercontact') {

            if (event.detail.value) {
                this.lineItems[index].Bidders_Contact__c = event.detail.value;
                this.lineItems[index].biddercontactVal = event.detail.value;
            } else {
                this.lineItems[index].Bidders_Contact__c = undefined;
                this.lineItems[index].biddercontactVal = undefined;
            }

        }

        if (val.type == 'saleorigindestination' && event.detail.value) {
            this.lineItems[index].Sale_Origin_Destination__c = event.detail.value;
              this.lineItems[index].priceTypeDefaultValue = event.detail.value;
        }


        if (val.type == 'buyernamesearch' && event.detail.value) {
            this.lineItems[index].Buyer_Name__c = event.detail.value;
        }

        if (val.type == 'buyername') {

            if (event.detail.value) {
                this.lineItems[index].Buyer_Name__c = event.detail.value;
            } else {
                this.lineItems[index].Buyer_Name__c = undefined;
            }

        }

        if (val.type == 'commodity' && event.detail.value) {
            this.lineItems[index].Commodity__c = event.detail.value;
            this.lineItems[index].commodityVal = event.detail.value;
            this.lineItems[index].commodityDefaultValue = event.detail.value;
            // alert(index);
            // alert(this.lineItems[index].Commodity__c);

        }

        if (val.type == 'cropyear' && event.detail.value) {

            this.lineItems[index].Crop_Year__c = event.detail.value;
             this.lineItems[index].cropYearDefaultValue = event.detail.value;
        }
        if (val.type == 'price' && event.detail.value) {

            this.lineItems[index].Price__c = event.detail.value;
            this.lineItems[index].priceDefaultValue = event.detail.value;
        }
        if (val.type == 'startdate' && event.detail.value) {

            this.lineItems[index].Delivery_Start_Date__c = event.detail.value;
            this.lineItems[index].startDateDefaultValue = event.detail.value;
        }
        if (val.type == 'enddate' && event.detail.value) {
            // alert( event.detail.value);
            this.lineItems[index].Delivery_End_Date__c = event.detail.value;
            this.lineItems[index].endDateDefaultValue = event.detail.value;
        }

        console.log('this.lineItems');
        console.log(this.lineItems);

    }

    handleAdd() {

        //    this.lineItems.push({index: this.lineItems[this.lineItems.length-1].index+1, recordId: undefined, recordName: undefined});
        var tempIndex = 0;
        if (this.lineItems.length > 0) {
            tempIndex = this.lineItems[this.lineItems.length - 1].index + 1;
        }


        var bidObj = {
            index: tempIndex,
            allOptions: this.tempArray,
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
            commodityOptions: this.tempArray.Commodity__c,
            commodityVal: undefined,
            biddercontactOptions: this.tempArray.Contact,
            biddercontactVal: undefined,
            buyernameOptions: this.tempArray.Account,
            buyernameVal: undefined,
            priceTypeOptions: this.tempArray.Sale_Origin_Destination__c,
            priceTypeVal: undefined,
            siteDefaultItem: undefined,


        }

        if(this.thisBuyerId){
            bidObj.Buyer_Name__c = this.thisBuyerId;
        }

        this.lineItems.push(bidObj);

    }

    

    handleBuyerNameChangeForSearch(event) {
        this.lineItems = [];
        var val = event.detail.value;
        this.thisBuyerId = val;
        this.selectedBuyerId = val;
        this.isLoading = true;
        console.log('handleBuyerNameChangeForSearch val-->' + val);

        if (val) {
            this.getBidData(this.selectedBuyerId, this.filterToday);
        } else {
            this.connectedCallback();
        }
        this.isLoading = false;




    }

    

    getBidData(val, todayFilter) {

        getAllBidsByBuyerId({ buyerId: val, rand: Math.random(), filterToday: todayFilter })
            .then(data => {

                var tempArray = JSON.parse(data);


                // if (this.lineItems.length = 0) {
                //     tempIndex = this.lineItems[this.lineItems.length - 1].index + 1;
                // }

                if (tempArray.length == 0) {
                    this.connectedCallback();
                }

                console.log('tempArray');
                console.log(tempArray);
                this.lineItems = [];

                var tempArray2 = [];
                var index = 0;
                for (var ta of tempArray) {

                    var bidObj = {
                        Id: ta.Id,
                        index: index,
                        allOptions: this.tempArray,
                        siteDefaultItem: { recordId: ta.Site__c, recordName: ta.Site__r.Name },
                        buyerNameDefault: { recordId: ta.Buyer_Name__c, recordName: ta.Buyer_Name__r.Name },
                        createdDateDefaultValue: ta.Default_Date_Time__c,
                        commodityDefaultValue: ta.Commodity__c,
                        gradeDefaultValue: ta.Grade__c,
                        cropYearDefaultValue: ta.Crop_Year__c,
                        priceDefaultValue: ta.Price__c,
                        startDateDefaultValue: ta.Delivery_Start_Date__c,
                        endDateDefaultValue: ta.Delivery_End_Date__c,
                        priceTypeDefaultValue: ta.Sale_Origin_Destination__c,
                        cropYearOptions: this.tempArray.Crop_Year__c,
                        siteRecordId: ta.Site__c, buyernameSearchOptions: this.tempArray.Account,
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
                        Site__c: ta.Site__c,
                        Commodity__c: ta.Commodity__c,
                        Grade__c: ta.Grade__c,
                        Crop_Year__c: ta.Crop_Year__c,
                        Price__c: ta.Price__c,
                        Delivery_Start_Date__c: ta.Delivery_Start_Date__c,
                        Delivery_End_Date__c: ta.Delivery_End_Date__c,
                        Sale_Origin_Destination__c: ta.Sale_Origin_Destination__c,
                        Buyer_Name__c: ta.Buyer_Name__c,
                        Bidders_Contact__c: ta.Bidders_Contact__c
                    };



                    if (ta.Bidders_Contact__c) {
                        bidObj.bidderContactDefaultValue = { recordId: ta.Bidders_Contact__c, recordName: ta.Bidders_Contact__r.Name };
                    }
     
                    
                    if(ta.Delivery_Start_Date__c < this.todayDate){

                        bidObj.Delivery_Start_Date__c = this.todayDate;
                        bidObj.startDateDefaultValue = this.todayDate;
                    }


                    if(this.thisBuyerId){
                        bidObj.Buyer_Name__c = this.thisBuyerId;
                    }


                    tempArray2.push(bidObj);

                    index++;
                }

                if(tempArray2.length==0){
                    this.handleAdd();
                }else{
                    this.lineItems = tempArray2;
                }

                

                
    
                // if(this.lineItems.length==0){
                //     this.handleAdd();
                // }

                


            })
            .catch(error => {
                this.error = error;
            });

    }

    handleSiteAdd(event) {
        //alert(event.detail);

        for(var item of this.lineItems){
            if(item.index==event.detail){
        var objNew = Object.assign({}, item);

        objNew.index = this.lineItems[this.lineItems.length - 1].index + 1;

        //alert(objNew.index);
        this.lineItems.push(objNew);
        console.log(this.lineItems);
             }
         }

       
    }

    handleExcludedSite(event){ 
       // alert(event.detail);

        var index = this.getRealIndex(event.detail);
//alert(index);
        //var index = this.getIndex(event.detail);

        if(!this.lineItems[index].Id){
            //alert('Id is missing');
            return false;
        }

        updateExData({ recordId: this.lineItems[index].Id, rand: Math.random() })
        .then(data => {
            this.showNotification('Success', 'The record is excluded successfully', 'success');
            this.handleRowDeletion(event);
            // this.getBidData(this.selectedBuyerId, this.filterToday);
        })
        .catch(error => {
            alert(JSON.stringify(error));
            this.error = error;
        });




    }

    handleRowDeletion(event){

    
       for(var item of this.lineItems){
            if(item.index==event.detail){
                this.lineItems.splice( this.lineItems.indexOf(item), 1);
             }
         }
        

        // var tempArray = [];
        // for(var item of this.lineItems){
        //     if(item.index!=event.detail){
        //         tempArray.push(item);
        //     }
        // }

        // this.lineItems = tempArray;
      
    }

    handleRowSelection(event) {

       var index = this.getRealIndex(event.detail.index);

      //  var index = this.getIndex(event.detail.index);

        this.lineItems[index] = { index: event.detail.index, recordId: event.detail.recordId, recordName: event.detail.recordName };

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



    // getIndex(index) {
    //     var i = 0;
    //     var tempIndex = 0;
    //     this.lineItems.forEach(function (item) {
    //         if (item.index === index) {
    //             tempIndex = i;
    //         }
    //         i++;
    //     });
    //     return tempIndex;
    // }

    getRealIndex(index){

        var thisIndex = 0;
    
        for(var ind in this.lineItems){
            if(this.lineItems[ind].index==index){
                thisIndex = ind;
            }
        }
        return thisIndex;
       }
    handleSaveClick(event) {
        var tempArray = [];

        var isErrorHappened = false;

        for (var item of this.lineItems) {

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
            //     item.buyerNameErrorDetails.errorMessage = 'Buyer Name or Bidders Contact required';
            //     item.buyerNameErrorDetails.isError = true;
            //     item.buyerNameErrorDetails.errorClass = 'slds-has-error';
            //     isErrorHappened = true;
            // }else{
            //     item.buyerNameErrorDetails.errorMessage = '';
            //     item.buyerNameErrorDetails.isError = false;
            //     item.buyerNameErrorDetails.errorClass = '';
            //     item.bidderContactErrorDetails.errorMessage = '';
            //     item.bidderContactErrorDetails.isError = false;
            //     item.bidderContactErrorDetails.errorClass = '';
            // }

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
            if (item.Grade__c == undefined || item.Grade__c == '') {


                item.gradeErrorDetails.errorMessage = 'Grade required';
                item.gradeErrorDetails.isError = true;
                item.gradeErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.gradeErrorDetails.errorMessage = '';
                item.gradeErrorDetails.isError = false;
                item.gradeErrorDetails.errorClass = '';
            }
            if (item.Crop_Year__c == undefined || item.Crop_Year__c == '') {
                item.cropYearErrorDetails.errorMessage = 'Crop Year required';
                item.cropYearErrorDetails.isError = true;
                item.cropYearErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.cropYearErrorDetails.errorMessage = '';
                item.cropYearErrorDetails.isError = false;
                item.cropYearErrorDetails.errorClass = '';
            }
            if (item.Price__c == undefined || item.Price__c == '') {

                item.priceErrorDetails.errorMessage = 'Price required';
                item.priceErrorDetails.isError = true;
                item.priceErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            }
            else {
                item.priceErrorDetails.errorMessage = '';
                item.priceErrorDetails.isError = false;
                item.priceErrorDetails.errorClass = '';
            }
            // if(item.Delivery_Start_Date__c==undefined || item.Delivery_Start_Date__c==''){
            //     item.startDateErrorDetails.errorMessage = 'Start Date required';
            //     item.startDateErrorDetails.isError = true;
            //     item.startDateErrorDetails.errorClass = 'slds-has-error';
            //     isErrorHappened = true;
            // }
            // else{
            //     item.startDateErrorDetails.errorMessage = '';
            //     item.startDateErrorDetails.isError = false;
            //     item.startDateErrorDetails.errorClass = '';
            // }
            // if(item.Delivery_End_Date__c==undefined || item.Delivery_End_Date__c==''){
            //     item.endDateErrorDetails.errorMessage = 'End Date required';
            //     item.endDateErrorDetails.isError = true;
            //     item.endDateErrorDetails.errorClass = 'slds-has-error';
            //     isErrorHappened = true;
            // }
            // else{
            //     item.endDateErrorDetails.errorMessage = '';
            //     item.endDateErrorDetails.isError = false;
            //     item.endDateErrorDetails.errorClass = '';
            // }
            if (new Date(item.Delivery_End_Date__c) < new Date(item.Delivery_Start_Date__c)) {
                item.endDateErrorDetails.errorMessage = 'End Date cannot be earlier than Start Date';
                item.endDateErrorDetails.isError = true;
                item.endDateErrorDetails.errorClass = 'slds-has-error';
                isErrorHappened = true;
            } else {
                item.endDateErrorDetails.errorMessage = '';
                item.endDateErrorDetails.isError = false;
                item.endDateErrorDetails.errorClass = '';
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

            tempArray.push({ Previous_Bid__c: item.Id, Site__c: item.Site__c, Bidders_Contact__c: item.Bidders_Contact__c, Buyer_Name__c: item.Buyer_Name__c, Commodity__c: item.Commodity__c, Grade__c: item.Grade__c, Crop_Year__c: item.Crop_Year__c, Price__c: item.Price__c, Delivery_Start_Date__c: item.Delivery_Start_Date__c, Delivery_End_Date__c: item.Delivery_End_Date__c, Sale_Origin_Destination__c: item.Sale_Origin_Destination__c });
        }

        console.log('Buyer_Name__c');
        console.log(tempArray);



        // console.log('this.lineItems');
        // console.log(this.lineItems);
        // console.log(tempArray);
        // console.log('isErrorHappened-->'+isErrorHappened);
        
        if (isErrorHappened == false) {
            saveData({ records: JSON.stringify(tempArray), rand: Math.random() , saveDate: new Date(this.todayDate)})
                .then(data => {
                    this.showNotification('Success', 'Records saved successfully', 'success');
                    window.location.href = '/lightning/n/Bid_Dashboard';
                })
                .catch(error => {
                    alert(JSON.stringify(error));
                    this.error = error;
                });
        } else {
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
        //alert(this.todayDate);
        var tempArray = [];
        for(var item of this.lineItems){

            console.log(item.Delivery_Start_Date__c+'--'+this.todayDate);

            if(item.Delivery_Start_Date__c < this.todayDate){
                item.Delivery_Start_Date__c = this.todayDate;
                item.startDateDefaultValue = this.todayDate;
            }
            tempArray.push(item);
        }

        console.log('items-->');
        console.log(tempArray);

        this.lineItems = tempArray;
        // this.getBidData(this.lineItems[this.lineItems.length - 1].Buyer_Name__c, this.filterToday);
    }
}