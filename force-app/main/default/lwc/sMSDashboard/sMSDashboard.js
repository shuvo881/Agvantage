import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getContactListViewData from '@salesforce/apex/SMSDashboardController.getContactListViewDataApex';
import getAllPickListData from '@salesforce/apex/SMSDashboardController.getContactListViewsApex';
import getConverseTemplates from '@salesforce/apex/SMSDashboardController.getConverseTemplates';
import getSmsDataData from '@salesforce/apex/SMSDashboardController.getSmsData';
import sendBulkSms from '@salesforce/apex/SMSMagicController.sendSMS';



const contactColumns = [
    { label: 'ID/Status', fieldName: 'ID_Status__c' },
    { label: 'Full Name', fieldName: 'Name' },
    { label: 'Mobile - Work', fieldName: 'Mobile_Work__c' },
    { label: 'Farming Regions', fieldName: 'Farming_Regions__c' },
    { label: 'Cotton Valley Region', fieldName: 'Cotton_Valley_Regions__c' },
    { label: 'Priority', fieldName: 'Priority__c' },
];


const bidDataColumns = [

    {
        label: 'Site/Location', fieldName: 'bidLink', type: 'url',
        typeAttributes: { label: { fieldName: 'Site_Name__c' }, target: '_blank' }
    },
    { label: 'Commodity', fieldName: 'Commodity__c' },
    { label: 'Grade', fieldName: 'Grade__c' },
    { label: 'Crop Year', fieldName: 'Crop_Year__c' },
    { label: 'Price', fieldName: 'Price__c', type: 'currency', cellAttributes: { alignment: 'left' } },
];

export default class SMSDashboard extends LightningElement {
    @track isLoading = false;
    @track data;
    @track bidData;
    @track showSmsData = false;
    @track showTemplateData = false;
      @track viewFinalData = false;
    @track showContData = false;
    @track contactListViews = [];
    @track templateOptions = [];
    @track selectedContacts = [];
    @track selectedMsg = [];
    @track characterCount = 0;
    contactColumns = contactColumns;
    bidDataColumns = bidDataColumns;
    @track msgBody = '';
    @track msgTemplateBody = '';
    AllContacts;

    @track searchResults="";
    @track selectedSearch="";
    @track selectedSearchResult="";


    showToast(title, message, variant) {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }

    connectedCallback() {
        this.isLoading = true;
        getAllPickListData({ rand: Math.random() })
            .then(data => {
                var tempArray = JSON.parse(data);
                console.log('tempArray');
                console.log(tempArray);
                this.contactListViews = tempArray;
            })
            .catch(error => {
                this.error = error;
            });


            getConverseTemplates({ rand: Math.random() })
            .then(data => {
                var tempArray = JSON.parse(data);
                console.log('tempArray');
                console.log(tempArray);
                //alert(tempArray);
                this.templateOptions = tempArray;
            })
            .catch(error => {
                this.error = error;
            });
        this.isLoading = false;
    }

    handleComboChange() {
        this.isLoading = true;

        var contactListViewId = this.selectedSearch.value;

        getContactListViewData({ contactListViewId: contactListViewId, rand: Math.random() })
            .then(data => {
                if (data) {
                    this.data = data;
                    this.showContData = true;
                    console.log('Cont sms');
                    console.log(this.data);
                }
                else {
                    this.msgBody = '';
                    this.msgTemplateBody= '';
                }
            })
            .catch(error => {
                alert(JSON.stringify(error));
            });

        getSmsDataData({ randomNumber: Math.random() })
            .then(bidData => {
                if (bidData) {
                    var data = JSON.parse(JSON.stringify(bidData));
                    var tempArray = [];
                    for (var i = 0; i < data.length; i++) {

                        var db = data[i];
                        db.bidLink = '/' + db.Id;
                        db.Site_Name__c = (data[i].Site__c)?data[i].Site__r.Name:'';

                        tempArray.push(db);

                    }

                    this.bidData = tempArray;
                    this.showSmsData = true;
                    console.log('data sms');
                    console.log(this.bidData);
                }
                else {
                    this.msgBody = '';
                    this.msgTemplateBody= '';
                }
            })
            .catch(error => {
            });
        this.isLoading = false;
        // #endregion
    }

    handleTemplateOptions(event) {
        this.viewFinalData=true;
        var templateData=event.detail.value;
        templateData=templateData.replace("{SMSBODY}", this.msgBody);
        this.msgTemplateBody=templateData;
    }
    handleSubmit() {
        const phoneNumbers = this.selectedContacts.map(contact => contact.Mobile_Work__c);
        console.log('Selected Phone Numbers:', phoneNumbers);
    }

    handleRowSelection(event) {
        this.selectedContacts = event.detail.selectedRows;
        this.AllContacts = this.selectedContacts.map(contact => contact.Id);
        console.log("this.AllContacts");
        console.log(this.AllContacts);
    }



    handleBidDataSelection(event) {
        this.selectedMsg = event.detail.selectedRows;
        var smsLine = [];
        var cottonRows = [];
        var isCotton = false;
        var totalMsg = '';

        var nonCottonLines = [];

        for (var record of event.detail.selectedRows) {

            if (record.Commodity_Short_Name__c == 'Cotton') {

                cottonRows.push(record);
                isCotton = true;
            } else {


                var tempIndex = record.Commodity__c + '-' + record.Crop_Year__c + '-' + record.Price_Tag_Name__c + '-' + record.Site__c;

                if (!nonCottonLines[tempIndex]) {
                    nonCottonLines[tempIndex] = [];
                }
                nonCottonLines[tempIndex].push(record);
            }
            

        }

        console.log('nonCottonLines-->');
        console.log(nonCottonLines);

        for (var ncl in nonCottonLines) {
            var smsLineNonCotton = '';
            for (var nclLine of nonCottonLines[ncl]) {

                console.log('nclLine');
                console.log(nclLine);

                smsLineNonCotton += nclLine.Grade_Short_Name__c + ' $' + nclLine.Price__c + ' ';
            }

            smsLineNonCotton += this.shortCropYear(nonCottonLines[ncl][0].Crop_Year__c) + ' ' + nonCottonLines[ncl][0].Price_Tag_Name__c + ' ' + nonCottonLines[ncl][0].Site__r.Site_Short_Name__c;
            smsLine.push(smsLineNonCotton);
        }

        var tempArray3 = [];

        for(var slnc of smsLine){

            var slncSplit = slnc.split(' ');
            var slncSplitLength = slncSplit.length;

            var slncKey = slncSplit[0]+'-'+slncSplit[slncSplitLength-2]+'-'+slncSplit[slncSplitLength-1];
            
            if(!tempArray3[slncKey]){
                tempArray3[slncKey] = [];
            }
            tempArray3[slncKey].push(slnc);
            

        }

        var smsLine2 = [];

        for(var ta3 in tempArray3){

            if(tempArray3[ta3].length==1){
                smsLine2.push(tempArray3[ta3][0]);
            }
            if(tempArray3[ta3].length>1){

                var updatedSMSLine = '';

                var firstPart = '';
                var lastPart = '';
                var middlePart = '';

                for(var ta of tempArray3[ta3]){

                    
                    var slncSplit = ta.split(' ');
                    var slncSplitLength = slncSplit.length;

                    firstPart = slncSplit[0];
                    lastPart = slncSplit[slncSplitLength-2]+' '+slncSplit[slncSplitLength-1];

                    var middleBody = ta.replace(firstPart, '').replace(lastPart, '');


                    middlePart += middleBody;
                    

                }

                var combinedLine = (firstPart+''+middlePart+''+lastPart).replaceAll('  ',' ');

                smsLine2.push(combinedLine);


            }

        }

        var cottonBody = 'Cotton ';

        for (var cr of cottonRows) {

            cottonBody += + this.shortCropYearCotton(cr.Crop_Year__c)+' '+'$' + cr.Price__c +' ';
                }

        if (isCotton) {
            if(smsLine2!=null)
            {
              totalMsg = cottonBody + '\n' + smsLine2.sort().join('\n');  
            }
            else{
                totalMsg = cottonBody;
            }
            
        } else {
            totalMsg = smsLine.join('\n');
        }


        if(totalMsg.length > 700){
            this.showToast('Error', 'SMS limit exceeded', 'error');
        }else{
            var oldMsg=this.msgBody;
            this.msgBody = totalMsg;
            var templateData=this.msgTemplateBody;
            templateData=templateData.replace(oldMsg, this.msgBody);
            this.msgTemplateBody=templateData;
            this.characterCount = + totalMsg.length.toString() + ' / No. of SMS: '+( Math.ceil(totalMsg.length/160)).toString();
       }
        
        // Cotton, year 23, price, year 24, price, year 25, price, location
        // Commodity, Year, Price, Price Type, Site Location

    }
    handleCharacterChange(event) {
        const inputValue = event.target.value;

        this.msgBody = event.target.value;

        if(inputValue.length > 700){
            this.showToast('Error', 'SMS limit exceeded', 'error');
        }else{
            this.characterCount = + inputValue.length.toString() + ' / No. of SMS: '+( Math.ceil(inputValue.length/160)).toString();
        }
 
    }

  

    shortCropYear(cropYear) {
        var tempCropYear = '';
        if (cropYear) {
            var tempData = cropYear.split('/');
            tempCropYear = tempData[0].substring(2);
            tempCropYear += '/';
            tempCropYear += tempData[1].substring(2);
        }
        return tempCropYear;
    }

    shortCropYearCotton(cropYear) {
        var tempCropYear = '';
        if (cropYear) {
            var tempData = cropYear.split('/');
            tempCropYear = tempData[1].substring(2);
        }
        return tempCropYear;
    }

    handleGoNext()
    {
        this.showTemplateData=true;
    }

    handleSendSMS() {

        console.log('this.msgTemplateBody-->');
        console.log(this.msgTemplateBody);
        console.log('this.AllContacts-->');
        console.log(this.AllContacts);
        // sendBulkSms({ recipientNumber: this.AllContacts, messageContent: this.msgTemplateBody })
        sendBulkSms({ recipientNumber: this.AllContacts, messageContent: this.msgTemplateBody })
            .then(result => {
                //Handle successful SMS sending
                this.showToast('Success', 'SMS sent successfully', 'success');
            })
            .catch(error => {
                //Handle error during SMS sending
                console.log(error);
                this.showToast('Error', 'Failed to send SMS', 'error');
            });
    }

    handleTemplateCharacterChange(event){
this.msgTemplateBody=event.detail.value;
    }



    search(event) {
        const input = event.detail.value.toLowerCase();
        const result = this.contactListViews.filter((picklistOption) =>
          picklistOption.label.toLowerCase().includes(input)
        );
        this.searchResults = result;
      }
    
      selectSearchResult(event) {
        const selectedValue = event.currentTarget.dataset.value;
        //alert(selectedValue);
        this.selectedSearch = this.contactListViews.find(
          (picklistOption) => picklistOption.value === selectedValue?picklistOption.label:''
        );
        this.selectedSearchResult=this.selectedSearch.label;
        this.clearSearchResults();
        this.handleComboChange();
      }
    
      clearSearchResults() {
        this.searchResults = null;
      }
    
      showPicklistOptions() {
        if (!this.searchResults) {
          this.searchResults = this.contactListViews;
        }
      }



}