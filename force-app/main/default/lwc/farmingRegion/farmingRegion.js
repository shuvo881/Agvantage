import { LightningElement, wire, track } from 'lwc';
import getAllData from '@salesforce/apex/SMSDashboardController.getAllData';
import orderMarketRegion from '@salesforce/apex/SMSDashboardController.getOrderMarketRegion';
import getSelectedBids from '@salesforce/apex/BulkBidController.getAllSelectedBids';
import getAllPickListData from '@salesforce/apex/SMSDashboardController.getAllPickListOptions';
import insertBidIdsToCustomSettings from '@salesforce/apex/SMSDashboardController.insertBidIdsToCustomSettingsApex';
import getAllDataByDate from '@salesforce/apex/SMSDashboardController.getAllDataByDate';
import getAllSearchBidOptions from '@salesforce/apex/SMSDashboardController.getAllSearchBidOptions';
import getAllBidDataBySearch from '@salesforce/apex/SMSDashboardController.getAllBidDataBySearch';

import { loadStyle } from 'lightning/platformResourceLoader';

const columns = [

    { label: 'Site/Location', fieldName: 'Farming_Region_Name__c' },
    { label: 'Commodity', fieldName: 'Commodity__c' },
    { label: 'Grade', fieldName: 'Grade__c' },
    { label: 'Crop Year', fieldName: 'Crop_Year__c' },
    { label: 'Sale Origin/Destination', fieldName: 'Sale_Origin_Destination__c' },
    {
        label: 'Price',
        fieldName: 'Price__c',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'PriceLabel' },
            target: '_blank'
        }
    },
    {
        label: 'Change', fieldName: 'Price_Change__c', type: 'text',
        cellAttributes: {
            class: { fieldName: 'priceChange1' },
            alignment: 'left'
        }
    },

    {
        label: 'Del Period Start', fieldName: 'Delivery_Start_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    {
        label: 'Del Period End', fieldName: 'Delivery_End_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    // { label: 'Price', fieldName: item.Price__c, type: 'url', cellAttributes: { alignment: 'left' }},
    {
        label: 'Bid Date', fieldName: 'Default_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    { label: 'Buyer Name', fieldName: 'Buyer_Name_Text__c' },
    {
        type:"button",
        fixedWidth: 150,
        typeAttributes: {
            label: 'Show Bids',
            name: 'edit',
            variant: 'brand'
        }
    },
    {
        type:"button",
        fixedWidth: 150,
        typeAttributes: {
            label: 'Historical Graph',
            name: 'history',
            variant: 'brand'
        }
    },
];


const selectedBidColumn = [

    { label: 'Site/Location', fieldName: 'Site_Name__c' },
    { label: 'Commodity', fieldName: 'Commodity__c' },
    { label: 'Grade', fieldName: 'Grade__c' },
    { label: 'Crop Year', fieldName: 'Crop_Year__c' },
    { label: 'Sale Origin/Destination', fieldName: 'Sale_Origin_Destination__c' },
    {
        label: 'Price',
        fieldName: 'priceLink',
        type: 'url',
        typeAttributes: {
            label: { fieldName: 'PriceLabel' },
            target: '_blank'
        }
    },
    
    {
        label: 'Bid Date', fieldName: 'Default_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    {
        label: 'Del Period Start', fieldName: 'Delivery_Start_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    {
        label: 'Del Period End', fieldName: 'Delivery_End_Date__c', type: 'date', typeAttributes: {
            day: 'numeric',
            month: 'short',
            year: 'numeric',
        },
        sortable: false
    },
    // { label: 'Price', fieldName: item.Price__c, type: 'url', cellAttributes: { alignment: 'left' }},
    // {
    //     label: 'Bid Date', fieldName: 'Default_Date_Time__c', type: 'date', typeAttributes: {
    //         day: 'numeric',
    //         month: 'short',
    //         year: 'numeric',
    //     },
    //     sortable: false
    // },
    { label: 'Buyer Name', fieldName: 'Buyer_Name_Text__c' },
];




export default class farmingRegion extends LightningElement {
    // #region Declaration
    @track value;
    @track values = [];
    @track optionData;
    @track searchString;
    @track noResultMessage;
    @track showDropdown = false;
    @track data = [];
    @track Biddata = [];

    @track error;
    @track errorMessage;

    @track siteErrorDetailsDefault = {errorMessage: 'Site required', isError: false, errorClass: undefined};

    @track columns = columns;
    @track selectedBidColumn = selectedBidColumn;
    @track comboOptions;
    @track commodityOptions = [];
    @track gradeOptions = [];
    @track cropYearOptions = [];
    @track searchString;
    @track initialRecords;
    @track initialBidRecords;

    @track gradePills = [];
    @track showCommodityOptions = false;
    @track showGradeOptions = false;
    @track showCropYearOptions = false;
    @track showBidDateOptions = false;
    @track showSearchBid = false;

    @track searchCropYearOptions = false;
    @track searchGradeOptions = false;
    @track searchCommodityOptions = false;
    @track searchSiteOptions = false;
    @track searchSaleoriginOptions = false;

    @track isGradeBidDisabled = false;
    @track isHideDiv = false;

    @track isGradeDisabled = false;
    @track selectedIds = [];
    @track yourList = [];
    @track yourComList = [];

    @track commodityBidSearch=" ";
    @track siteBidSearch=" ";
    @track gradeBidSearch=" ";
    @track saleBidSearch=" ";
    @track cropyearBidSearch=" ";

    @track commodityBidOptions = [];
    @track gradeBidOptions = [];
    @track cropYearBidOptions = [];
    @track siteBidOptions = [];
    @track saleBidOptions = [];

    @track allOptions;
    @track commodityFilterOptions = [];
    @track gradeFilterOptions = [];
    @track cropYearFilterOptions = [];

    @track allBidOptions;
    @track commodityBidFilterOptions = [];
    @track gradeBidFilterOptions = [];
    @track cropYearBidFilterOptions = [];
    @track siteBidFilterOptions = [];
    @track saleOriginBidFilterOptions = [];

    @track isModalOpen = false;
    @track isSearchBidOpen = false;
    @track isGraphOpen = false;

    @track selectedBids = [];
    @track isSelectedBidVisible = false;

    @track ifrmaeSRC;
    @track wiredFeedElements;
    selectionId = [];
    AllBidId;
    BidId;
    @track todayDate=new Date().toISOString();
    @track searchBid='Filter Bids';
    // #endregion  
  @track marketOrder=[];
    @wire(orderMarketRegion, {randomNumber:Math.random() })
    wiredMarketOrder({ error, data }) {
        if (data) {
            for(var i=0;i<data.length;i++){ 
                this.marketOrder[this.marketOrder.length]=data[i];
            }
        } else if (error) {
            console.log('Something went wrong:', error);
        }
    }

    @wire(getAllData, {rand: Math.random() })
    wiredAccount({ error, data }) {
        if (data) {

            var tempArray = [];
          
                for(var i=0;i<this.marketOrder.length;i++){ 
           
                if(!tempArray[this.marketOrder[i]]){
                   
                    tempArray[this.marketOrder[i]] = [];
                    
                }
            }

            for(var i=0;i<data.length;i++){
                if(data[i].Price__c>0){

                    if(!tempArray[data[i].Site__r.Market_Region__c]){
                        
                        tempArray[data[i].Site__r.Market_Region__c] = [];
                    }      
                    //alert(tempArray);              
                    // tempArray[data[i].Site__r.Market_Region__c].push(data[i]);

                    tempArray[data[i].Site__r.Market_Region__c].push(
                        {
                            Id: data[i].Id,
                            Farming_Region_Name__c: data[i].Site__r.Name,
                            Commodity__c: data[i].Commodity__c,
                            Grade__c: data[i].Grade__c,
                            Crop_Year__c: data[i].Crop_Year__c,
                            Sale_Origin_Destination__c: data[i].Sale_Origin_Destination__c,
                            Price__c: data[i].Price__c,
                            Price_Change__c: data[i].Price_Change__c,
                            Delivery_Start_Date__c: data[i].Delivery_Start_Date__c,
                            Delivery_End_Date__c: data[i].Delivery_End_Date__c,
                            Default_Date_Time__c: data[i].Default_Date_Time__c,
                            Default_Date__c: data[i].Default_Date__c,
                            Buyer_Name_Text__c: data[i].Buyer_Name_Text__c,
                            Market_Region__c: data[i].Site__r.Market_Region__c,
                            Site__r: data[i].Site__r,
                            Site_Commodity_CropYear: data[i].Site__c+'-'+data[i].Commodity__c+'-'+data[i].Crop_Year__c
                        }
                        
                    );
                }
                
            }
            var t=[];
            for(var i=0;i<this.marketOrder.length;i++){ 
           //console.log(tempArray[this.marketOrder[i]].length);
                if(tempArray[this.marketOrder[i]].length<=0){
                   
                    console.log(this.marketOrder[i]);
                    //console.log(tempArray[this.marketOrder[i]].indexOf());
                    
                    delete tempArray[this.marketOrder[i]];
                    
                }
            }


            function sortFunction(a, b) {
                if (a.Site_Commodity_CropYear === b.Site_Commodity_CropYear) {
                    return 0;
                }
                else {
                    return (a.Site_Commodity_CropYear < b.Site_Commodity_CropYear) ? -1 : 1;
                }
            }


            for(var t in tempArray){

                tempArray[t].sort(sortFunction);

            }

            function formatCurrency(value) {
                const formatter = new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: 'USD'
                });
                return formatter.format(value);
            }

            var tempArray2 = [];
            var i = 0;
            //console.log('temparray->> '+tempArray['Southern QLD']);
            for (var key in tempArray) {

                var farmingRegionObj = {};
    //alert('check data ->>'+key);
   // console.log('check data ->>'+key);
                farmingRegionObj.key = key;
                farmingRegionObj.data = tempArray[key].map((item) => {
                    var priceChange = '';
                    if (item.Price_Change__c.includes('-$')) {
                        priceChange = "slds-text-color_error";
                    }
                    if (item.Price_Change__c.includes('+$')) {
                        priceChange = 'slds-text-color_success';
                    }
                    // data.forEach((item) => {
                    //     // Generate the URL using the record ID and Price__c field
                    //     item.PriceLabel = `/${item.Id}`; // Replace this with the actual URL pattern you need
                    
                    //     // For the label, you can use the Price__c field directly or customize it as needed
                    //     item.PriceLabelForModal = `${item.Price__c} USD`; // Customize the label as required
                    // });

                    

                    return {
                        ...item,
                        PriceLabel: formatCurrency(item.Price__c),
                        Price__c: '/lightning/r/Bid__c/' + item.Id + '/view',
                        priceChange1: priceChange

                    };
                });
                tempArray2.push(farmingRegionObj);

                i++;
            
            }
            this.data = tempArray2;
            this.initialRecords = tempArray2;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.data = undefined;
        }

        // if (data) {
        //     this.tempArray = data.map((item) => {
        //         // let priceChange = item.Price__c <0 ? "slds-text-color_error":"slds-text-color_success"
        //         let priceChange = "slds-text-color_success";
        //         if (item.Price__c < 0) {
        //             priceChange = "slds-text-color_error";
        //         }
        //         return {
        //             ...item,
        //             "priceChange1": priceChange,
        //         };
        //     });


        // }
    }


    // @wire(getAllPickListData, {pickListNames: '$pickListNames'})
    // wiredAccount({ error, data }) {
    //     if (data) {



    //         console.log('picklist data');
    //         console.log(JSON.parse(data));

    //         var tempArray = JSON.parse(data);

    //         this.comboOptions = tempArray;


    //     } else if (error) {
    //         this.error = error;
    //         this.data = undefined;
    //     }
    // }

    connectedCallback() {

        var pickListNames = JSON.stringify(['Commodity__c', 'Grade__c', 'Crop_Year__c']);


        this.yourList = [];

        this.yourList.push(Math.random());

        getAllPickListData({ pickListNames: pickListNames })
            .then(data => {

                var tempArray = JSON.parse(data);

                this.allOptions = tempArray;

                this.commodityOptions = tempArray.Commodity__c;
                this.cropYearOptions = tempArray.Crop_Year__c;

                this.showCommodityOptions = true;
                this.showGradeOptions = true;
                this.showCropYearOptions = true;
                this.showBidDateOptions = true;
                this.showSearchBid = true;

                this.isGradeDisabled = true;

            })
            .catch(error => {
                this.error = error;
            });

    }

    handleCommodityFilter(event) {


        this.yourList = [];

        this.yourList.push(Math.random());



        this.commodityFilterOptions = event.detail;

        if (this.commodityFilterOptions.length > 0) {

            this.isGradeDisabled = false;
            var tempArray = [];
            this.gradeOptions = [];

            for (var i = 0; i < event.detail.length; i++) {

                console.log('event.detail[i]-->' + event.detail[i]);
                console.log(this.allOptions[event.detail[i]]);



                if (this.allOptions[event.detail[i]]) {
                    for (var it of this.allOptions[event.detail[i]]) {
                        tempArray.push({ label: it.label, value: it.label, selected: false });
                    }
                }

            }

            this.gradeOptions = tempArray;

        } else {
            this.isGradeDisabled = true;
            this.gradeOptions = [];
        }


        this.handleSearch();
    }

    handleGradeFilter(event) {
        this.gradeFilterOptions = event.detail;
        this.handleSearch();
    }

    handleCropYearFilter(event) {
        this.cropYearFilterOptions = event.detail;
        this.handleSearch();
    }
  

    handleSearch() {

        if (this.commodityFilterOptions.length > 0 || this.gradeFilterOptions.length > 0 || this.cropYearFilterOptions.length > 0) {
            this.data = this.initialRecords;

            if (this.data) {
                let searchRecords = [];

                for (let record of this.data) {

                    var tempArray = [];


                    for (let r of record.data) {

                        var isCommodity = false;
                        var isGrade = false;
                        var isCropYear = false;

                        if (this.commodityFilterOptions.length > 0) {
                            isCommodity = true;
                        }
                        if (this.gradeFilterOptions.length > 0) {
                            isGrade = true;
                        }
                        if (this.cropYearFilterOptions.length > 0) {
                            isCropYear = true;
                        }


                        if (isCommodity && !isGrade && !isCropYear) {
                            if (this.commodityFilterOptions.includes(r.Commodity__c)) {
                                tempArray.push(r);
                            }
                        } else if (!isCommodity && isGrade && !isCropYear) {
                            if (this.gradeFilterOptions.includes(r.Grade__c)) {
                                tempArray.push(r);
                            }
                        } else if (!isCommodity && !isGrade && isCropYear) {
                            if (this.cropYearFilterOptions.includes(r.Crop_Year__c)) {
                                tempArray.push(r);
                            }
                        } else if (isCommodity && isGrade && !isCropYear) {
                            if (this.commodityFilterOptions.includes(r.Commodity__c) && this.gradeFilterOptions.includes(r.Grade__c)) {
                                tempArray.push(r);
                            }
                        } else if (isCommodity && isGrade && isCropYear) {
                            if (this.commodityFilterOptions.includes(r.Commodity__c) && this.gradeFilterOptions.includes(r.Grade__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)) {
                                tempArray.push(r);
                            }
                        } else if (!isCommodity && isGrade && isCropYear) {
                            if (this.gradeFilterOptions.includes(r.Grade__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)) {
                                tempArray.push(r);
                            }
                        } else if (isCommodity && !isGrade && isCropYear) {
                            if (this.commodityFilterOptions.includes(r.Commodity__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)) {
                                tempArray.push(r);
                            }
                        }

                    }



                    if (tempArray.length > 0) {
                        var tempObj = {};
                        tempObj.key = record.key;
                        tempObj.data = tempArray;
                        searchRecords.push(tempObj);
                    }
                }

                console.log('Matched results are ' + JSON.stringify(searchRecords));
                this.data = searchRecords;
            }
        } else {
            this.data = this.initialRecords;
        }
    }


    handleRowSelection(event) {



        for (var i = 0; i < event.detail.selectedRows.length; i++) {
            this.selectedIds.push(event.detail.selectedRows[i].Id);
        }




    }
    handleClick() {
        // console.log('this.BidId:', this.BidId);
        this.selectedIds = this.selectedIds.filter((value, index, array) => array.indexOf(value) === index);

        console.log(this.selectedIds);
        console.log('JSON.stringify', JSON.stringify(this.selectedIds));


        if (this.selectedIds.length > 0) {
            insertBidIdsToCustomSettings({ bidIds: JSON.stringify(this.selectedIds) })
                .then(result => {
                    console.log('Inserted successfully.');
                    window.location.href = "/lightning/n/SMS_Dashboard";
                })
                .catch(error => {
                    console.log('Error:', error);
                });
        } else {
            console.log('Please select at least one bid.');
        }


    }

    handleRowAction(event){
        //alert(event.detail.action.name);
        this.bidId = event.detail.row.Id;

if(event.detail.action.name=='edit')
{
     getSelectedBids({ recordId:  event.detail.row.Id, rand: Math.random() })
            .then(data => {

                var tempArray = JSON.parse(data);

                for(var ta in tempArray){
                    tempArray[ta].PriceLabel = '$'+tempArray[ta].Price__c;
                }
                for(var ta in tempArray){
                    tempArray[ta].priceLink = '/lightning/r/Bid__c/' + tempArray[ta].Id + '/view';
                }
                // data.forEach(res => {
                //     res.Price__c = '/lightning/r/Bid__c/' + res.Id + '/view';
                // });
                console.log('tempArray000>');
                console.log(tempArray);

                this.selectedBids = tempArray;
                this.isSelectedBidVisible = true;
            })
            .catch(error => {
                alert(JSON.stringify(error));
                this.error = error;
            });

        this.isModalOpen = true;
        this.isSearchBidOpen = false;

}

       if(event.detail.action.name=='history'){
        const currentDate = new Date();
            const day = currentDate.getDate();
            const month = currentDate.getMonth() + 1; 
            const year = currentDate.getFullYear();
            this.ifrmaeSRC = '/apex/HistoricalGraph?recordID='+this.bidId+'&startDate=2023-01-01&endDate='+year+'-'+month+'-'+day;
        
        this.isGraphOpen = true;
        this.isSearchBidOpen = false;

       }
     

    }

    closeModal() {
        this.isModalOpen = false;
        this.isGraphOpen = false;
        this.isSearchBidOpen = false;
        this.Biddata=[];

    }

    
    handleBidDateFilter(event)
    {
        this.todayDate=event.detail.value;
        getAllDataByDate({ bidDate: this.todayDate,rand:'096846347' })
            .then(data => {
                    var tempArray = [];
                  
                        for(var i=0;i<this.marketOrder.length;i++){ 
                   
                        if(!tempArray[this.marketOrder[i]]){
                           
                            tempArray[this.marketOrder[i]] = [];
                            //alert(tempArray); 
                        }
                    }
        
                    for(var i=0;i<data.length;i++){
                        if(data[i].Price__c>0){
        
                            if(!tempArray[data[i].Site__r.Market_Region__c]){
                                
                                tempArray[data[i].Site__r.Market_Region__c] = [];
                            }      
                            //alert(tempArray);              
                            // tempArray[data[i].Site__r.Market_Region__c].push(data[i]);
        
                            tempArray[data[i].Site__r.Market_Region__c].push(
                                {
                                    Id: data[i].Id,
                                    Farming_Region_Name__c: data[i].Site__r.Name,
                                    Commodity__c: data[i].Commodity__c,
                                    Grade__c: data[i].Grade__c,
                                    Crop_Year__c: data[i].Crop_Year__c,
                                    Sale_Origin_Destination__c: data[i].Sale_Origin_Destination__c,
                                    Price__c: data[i].Price__c,
                                    Price_Change__c: data[i].Price_Change__c,
                                    Delivery_Start_Date__c: data[i].Delivery_Start_Date__c,
                                    Delivery_End_Date__c: data[i].Delivery_End_Date__c,
                                    Default_Date_Time__c: data[i].Default_Date_Time__c,
                                    Default_Date__c: data[i].Default_Date__c,
                                    Buyer_Name_Text__c: data[i].Buyer_Name_Text__c,
                                    Market_Region__c: data[i].Site__r.Market_Region__c,
                                    Site__r: data[i].Site__r,
                                    Site_Commodity_CropYear: data[i].Site__c+'-'+data[i].Commodity__c+'-'+data[i].Crop_Year__c
                                }
                                
                            );
                        }
        
                    }
        
                    function sortFunction(a, b) {
                        if (a.Site_Commodity_CropYear === b.Site_Commodity_CropYear) {
                            return 0;
                        }
                        else {
                            return (a.Site_Commodity_CropYear < b.Site_Commodity_CropYear) ? -1 : 1;
                        }
                    }
        
        
                    for(var t in tempArray){
        
                        tempArray[t].sort(sortFunction);
        
                    }
        
                    function formatCurrency(value) {
                        const formatter = new Intl.NumberFormat('en-US', {
                            style: 'currency',
                            currency: 'USD'
                        });
                        return formatter.format(value);
                    }
        
                    var tempArray2 = [];
                    var i = 0;
                    //console.log('temparray->> '+tempArray['Southern QLD']);
                    for (var key in tempArray) {
        
                        var farmingRegionObj = {};
            //alert('check data ->>'+key);
           // console.log('check data ->>'+key);
                        farmingRegionObj.key = key;
                        farmingRegionObj.data = tempArray[key].map((item) => {
                            var priceChange = '';
                            if (item.Price_Change__c.includes('-$')) {
                                priceChange = "slds-text-color_error";
                            }
                            if (item.Price_Change__c.includes('+$')) {
                                priceChange = 'slds-text-color_success';
                            }
                            // data.forEach((item) => {
                            //     // Generate the URL using the record ID and Price__c field
                            //     item.PriceLabel = `/${item.Id}`; // Replace this with the actual URL pattern you need
                            
                            //     // For the label, you can use the Price__c field directly or customize it as needed
                            //     item.PriceLabelForModal = `${item.Price__c} USD`; // Customize the label as required
                            // });
        
                            
        
                            return {
                                ...item,
                                PriceLabel: formatCurrency(item.Price__c),
                                Price__c: '/lightning/r/Bid__c/' + item.Id + '/view',
                                priceChange1: priceChange
        
                            };
                        });
                        tempArray2.push(farmingRegionObj);
        
                        i++;
                    
                    }
                    this.data = tempArray2;
                    this.initialRecords = tempArray2;
                    this.error = undefined;

            })
            .catch(error => {
                this.error = error;
            });

        // this.getBidData(this.lineItems[this.lineItems.length - 1].Buyer_Name__c, this.filterToday);
    }

    handleSearchBidFilter(event){

        
        var pickListNames = JSON.stringify(['Site__c','Commodity__c', 'Grade__c', 'Crop_Year__c','Sale_Origin_Destination__c']);


        this.yourComList = [];

        this.yourComList.push(Math.random());

        getAllSearchBidOptions({ pickListNames: pickListNames })
            .then(data => {

                var tempArrayBid = JSON.parse(data);

                this.allBidOptions = tempArrayBid;

                this.commodityBidOptions = tempArrayBid.Commodity__c;
                this.cropYearBidOptions = tempArrayBid.Crop_Year__c;
                this.siteBidOptions = tempArrayBid.Site__c;
                this.saleBidOptions = tempArrayBid.Sale_Origin_Destination__c;

                this.searchSiteOptions = true;
                this.searchCommodityOptions = true;
                this.searchGradeOptions = true;
                this.searchCropYearOptions = true;
                this.searchSaleoriginOptions = true;

                this.isGradeBidDisabled = true;

            })
            .catch(error => {
                this.error = error;
            });
            this.isSearchBidOpen = true;
            this.isHideDiv=true;



    }
    
    handleSearchBid(){

        getAllBidDataBySearch({ siteBid: this.siteBidSearch,commodityBid: this.commodityBidSearch,gradeBid: this.gradeBidSearch,cropyearBid: this.cropyearBidSearch,saleoriginBid: this.saleBidSearch,rand:'096846347' })
            .then(data => {
                console.log(data);
                var tempArray = [];
                  
                      
        
                    for(var i=0;i<data.length;i++){
                        if(data[i].Price__c>0){
        
                            if(!tempArray[data[i].IsDeleted]){
                                
                                tempArray[data[i].IsDeleted] = [];
                            }      
                            //alert(tempArray);              
                            // tempArray[data[i].Site__r.Market_Region__c].push(data[i]);
        
                            tempArray[data[i].IsDeleted].push(
                                {
                                    Id: data[i].Id,
                                    Farming_Region_Name__c: data[i].Site__r.Name,
                                    Commodity__c: data[i].Commodity__c,
                                    Grade__c: data[i].Grade__c,
                                    Crop_Year__c: data[i].Crop_Year__c,
                                    Sale_Origin_Destination__c: data[i].Sale_Origin_Destination__c,
                                    Price__c: data[i].Price__c,
                                    Price_Change__c: data[i].Price_Change__c,
                                    Delivery_Start_Date__c: data[i].Delivery_Start_Date__c,
                                    Delivery_End_Date__c: data[i].Delivery_End_Date__c,
                                    Default_Date_Time__c: data[i].Default_Date_Time__c,
                                    Default_Date__c: data[i].Default_Date__c,
                                    Buyer_Name_Text__c: data[i].Buyer_Name_Text__c,
                                    Market_Region__c: data[i].Site__r.Market_Region__c,
                                    Site__r: data[i].Site__r,
                                    IsDeleted:data[i].IsDeleted,
                                    Site_Commodity_CropYear: data[i].Site__c+'-'+data[i].Commodity__c+'-'+data[i].Crop_Year__c
                                }
                                
                            );
                        }
        
                    }
        
                    function sortFunction(a, b) {
                        if (a.Site_Commodity_CropYear === b.Site_Commodity_CropYear) {
                            return 0;
                        }
                        else {
                            return (a.Site_Commodity_CropYear < b.Site_Commodity_CropYear) ? -1 : 1;
                        }
                    }
        
        
                    for(var t in tempArray){
        
                        tempArray[t].sort(sortFunction);
        
                    }
        
                    function formatCurrency(value) {
                        const formatter = new Intl.NumberFormat('en-US', {
                            style: 'currency',
                            currency: 'USD'
                        });
                        return formatter.format(value);
                    }
        
                    var tempArray2 = [];
                    var i = 0;
                    //console.log('temparray->> '+tempArray['Southern QLD']);
                    for (var key in tempArray) {
        
                        var farmingRegionObj = {};
            //alert('check data ->>'+key);
           // console.log('check data ->>'+key);
                        farmingRegionObj.key = key;
                        farmingRegionObj.data = tempArray[key].map((item) => {
                            var priceChange = '';
                            if (item.Price_Change__c.includes('-$')) {
                                priceChange = "slds-text-color_error";
                            }
                            if (item.Price_Change__c.includes('+$')) {
                                priceChange = 'slds-text-color_success';
                            }
                            // data.forEach((item) => {
                            //     // Generate the URL using the record ID and Price__c field
                            //     item.PriceLabel = `/${item.Id}`; // Replace this with the actual URL pattern you need
                            
                            //     // For the label, you can use the Price__c field directly or customize it as needed
                            //     item.PriceLabelForModal = `${item.Price__c} USD`; // Customize the label as required
                            // });
        
                            
        
                            return {
                                ...item,
                                PriceLabel: formatCurrency(item.Price__c),
                                Price__c: '/lightning/r/Bid__c/' + item.Id + '/view',
                                priceChange1: priceChange
        
                            };
                        });
                        tempArray2.push(farmingRegionObj);
        
                        i++;
                    
                    }
                    this.Biddata = tempArray2;
                    this.initialRecords = tempArray2;
                    this.error = undefined;

            })
            .catch(error => {
                this.error = error;
            });

            this.isHideDiv=false;

    }
    
    handleSearchCommodityFilter(event) {


        this.yourComList = [];

        this.yourComList.push(Math.random());


this.commodityBidSearch=event.detail.value;
        this.commodityBidFilterOptions = event.detail;
        if (this.commodityBidSearch!=null) {

            this.isGradeBidDisabled = false;
            var tempArray = [];
            this.gradeBidOptions = [];

          

                console.log('event.detail[i]-->' + event.detail.value);
                console.log(this.allBidOptions[event.detail.value]);



                if (this.allBidOptions[event.detail.value]) {
                    
                    for (var it of this.allOptions[event.detail.value]) {
                        tempArray.push({ label: it.label, value: it.label, selected: false });
                    }
                    
                }

          

            this.gradeBidOptions = tempArray;

        } else {
            this.isGradeBidDisabled = true;
            this.gradeBidOptions = [];
        }


    }

    handleSearchGradeFilter(event) {

        this.gradeBidSearch = event.detail.value;
    }

    handleSearchCropYearFilter(event) {
        this.cropyearBidSearch = event.detail.value;
    }
    handleSearchSiteFilter(event) {
       // alert(event.detail.value);
        this.siteBidSearch=event.detail.recordName;
    }
    handleSearchSaleOriginFilter(event) {

        this.saleBidSearch = event.detail.value;
    }

    handleRemove(){
        this.Biddata=[];
        this.isHideDiv=true;

    }
       
}