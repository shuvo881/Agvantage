import { LightningElement, track, api} from 'lwc';
 
export default class quickCottonObjectDynamicRow extends LightningElement {
 
   @api fullRecord;
   @api buyerId;
   @track defaultItem;
   @track yourList;
   @track value;
   @track values = [];
   @track optionData;
   @track searchString;
   @track noResultMessage;
   @track showDropdown = false;
   @track data = [];
   @track error;
   @track comboOptions;
   @track commodityOptions = [];
   @track gradeOptions = [];
   @track cropYearOptions = [];
   @track searchString;
   @track initialRecords;
   @track gradePills = [];
   @track showCommodityOptions = false;
   @track showGradeOptions = false;
   @track showCropYearOptions = false;
   @track isGradeDisabled = false;
   @track selectedIds = [];
   @track yourList = [];
   @track allOptions;
   @track commodityFilterOptions = [];
   @track gradeFilterOptions = [];
   @track cropYearFilterOptions = [];
   @track gradeDisabled;
   @track selectedYear;
   yearOptions = [];
   @api updatethisrow; 
   @track selectedValue;
   @track errorMessage;


  
  
   connectedCallback(){

    if(this.fullRecord.commodityDefaultValue){
        this.gradeOptions = this.fullRecord.allOptions[this.fullRecord.commodityDefaultValue];
    }

    console.log('this.updatethisrow  => '+ this.updatethisrow);

       console.log('fullRecord-->', this.fullRecord.allOptions);
       
 const currentYear = new Date().getFullYear()-2;
    
    for (let year = currentYear ; year <= currentYear + 10; year++){
        const yearRange = `${year - 1}/${year}`;
    this.yearOptions.push({ label: yearRange, value: yearRange });
    }

   }


 
   handleSiteLookupChange(event){
    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, name: event.detail.name, type: 'site'}}));
    }

   handleBidderContactChange(event){

    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, name: event.detail.name, type: 'biddercontact'}}));
   }

   handleBuyerNameChange(event){
    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, name: event.detail.name, type: 'buyername'}}));
   }
  
   handlePriceTypeChange(event){
    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'saleorigindestination'}}));
   }


handleGradeChange(event){
    var getVal = event.detail.value;

    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: getVal, type: 'grade'}}));
   }


handlePriceChange(event) {
    // alert(event.detail.value);
    // alert(event.target.name);
    // if(event.target.name == '21/22' && this.priceNewArray.get('21/22') != undefined){
    //     this.priceNewArray.push('21/22', event.detail.value);
    // }
    // else if(event.target.name == '22/23' && this.priceNewArray.get('22/23') != undefined){
    //     this.priceNewArray.push('22/23', event.detail.value);
    // }
    // else if(event.target.name == '23/24' && this.priceNewArray.get('23/24') != undefined){
    //     this.priceNewArray.push('23/24', event.detail.value);
    // }
    // else if(event.target.name == '24/25' && this.priceNewArray.get('24/25') != undefined){
    //     this.priceNewArray.push('24/25', event.detail.value);
    // }
    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: event.target.name}}));
    // this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'cropyear'}}));

  }


  handleStartDateChange(event) {

    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'startdate'}}));
  }

  handleEndDateChange(event) {

    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'enddate'}}));

}

handleCommodityChange(event){

    var getVal = event.detail.value;


    if(getVal){

        console.log('getVal-->'+getVal);
        console.log(this.fullRecord.allOptions[getVal]);
        this.gradeDisabled = false;

        this.gradeOptions = this.fullRecord.allOptions[getVal];

        this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'commodity'}}));


    }
}


handleCommodityFilter(event){


    this.yourList = [];

    this.yourList.push(Math.random());



    this.commodityFilterOptions = event.detail;

    if(this.commodityFilterOptions.length>0){

        this.isGradeDisabled = false;
        var tempArray = [];
        this.gradeOptions = [];

        for(var i=0;i<event.detail.length;i++){

            console.log('event.detail[i]-->'+event.detail[i]);
            console.log(this.allOptions[event.detail[i]]);



            if(this.allOptions[event.detail[i]]){
                for(var it of this.allOptions[event.detail[i]]){
                    tempArray.push({label: it.label, value: it.label, selected: false});
                }
            }

        }

        this.gradeOptions = tempArray;

    }else{
        this.isGradeDisabled = true;
        this.gradeOptions = [];
    }


    this.handleSearch();  
}

  handleCropYearFilter(event){
    this.cropYearFilterOptions = event.detail;
    this.handleSearch();
}


handleGradeFilter(event){
    this.gradeFilterOptions = event.detail;
    this.handleSearch();
}

handleSearch() {

    if (this.commodityFilterOptions.length > 0 || this.gradeFilterOptions.length > 0 || this.cropYearFilterOptions.length > 0) {
        this.data = this.initialRecords;

        if (this.data) {
            let searchRecords = [];

            for (let record of this.data) {

                var tempArray = [];

                
                for(let r of record.data){

                    var isCommodity = false;
                    var isGrade = false;
                    var isCropYear = false;

                    if(this.commodityFilterOptions.length>0){
                        isCommodity = true;
                    }
                    if(this.gradeFilterOptions.length>0){
                        isGrade = true;
                    }
                    if(this.cropYearFilterOptions.length>0){
                        isCropYear = true;
                    }


                    if(isCommodity && !isGrade && !isCropYear){
                        if(this.commodityFilterOptions.includes(r.Commodity__c)){
                            tempArray.push(r);
                        }
                    }else if(!isCommodity && isGrade && !isCropYear){
                        if(this.gradeFilterOptions.includes(r.Grade__c)){
                            tempArray.push(r);
                        }
                    }else if(!isCommodity && !isGrade && isCropYear){
                        if(this.cropYearFilterOptions.includes(r.Crop_Year__c)){
                            tempArray.push(r);
                        }
                    }else if(isCommodity && isGrade && !isCropYear){
                        if(this.commodityFilterOptions.includes(r.Commodity__c) && this.gradeFilterOptions.includes(r.Grade__c)){
                            tempArray.push(r);
                        }
                    }else if(isCommodity && isGrade && isCropYear){
                        if(this.commodityFilterOptions.includes(r.Commodity__c) && this.gradeFilterOptions.includes(r.Grade__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)){
                            tempArray.push(r);
                        }
                    }else if(!isCommodity && isGrade && isCropYear){
                        if(this.gradeFilterOptions.includes(r.Grade__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)){
                            tempArray.push(r);
                        }
                    }else if(isCommodity && !isGrade && isCropYear){
                        if(this.commodityFilterOptions.includes(r.Commodity__c) && this.cropYearFilterOptions.includes(r.Crop_Year__c)){
                            tempArray.push(r);
                        }
                    }

                }



                if(tempArray.length>0){
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
 
   handleDelete(){
 
        // alert(this.fullRecord.index);

       this.dispatchEvent(new CustomEvent('deleterow', {detail: this.fullRecord.index}));
   }


    handleAdd(){
        this.dispatchEvent(new CustomEvent('addrow' , {detail: this.fullRecord.index}));
    }


    handleSiteAdd(){
        this.dispatchEvent(new CustomEvent('addrowsite' , {detail: this.fullRecord.index}));
    }

    handleExcluded()
    {
        this.dispatchEvent(new CustomEvent('excludedsite' , {detail: {recordId: this.fullRecord.Id, index: this.fullRecord.index} }));
    }
    

  handlePriceChangeUpdate(event){

    console.log('this.fullRecord.index-->');
    console.log(this.fullRecord.index);

    this.dispatchEvent(new CustomEvent('updatethisrow', {detail: {index: this.fullRecord.index, value: event.detail.value, type: 'pricechange'}}));



  }
 


 
}