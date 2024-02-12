import { LightningElement,api,track,wire } from 'lwc';
import saveData from '@salesforce/apex/TradeEditRecord.saveData';
import getData from '@salesforce/apex/TradeEditRecord.getData';

import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';




export default class TradeEditModal extends LightningElement {
@api recordId;


spreads=null;
tradeRecType=null;
buyerCont=null;

actAs=null;
comRateSeller=null;
comRateBuyer=null;
comInvSeller=null;
comInvBuyer=null;

saleOrigin=null;
grade=null;
gradeSpread=null;
saleType=null;

commodity=null;
conType=null;
cropYear=null;
tolerance=null;
carryAmount=null;
unitTime=null;
carryDateStart=null;
carryDateEnd=null;

premium=null;
discount=null;
increment=null;
payTerm=null;
gstType=null;
recCreTaxInv=null;

areaHec=null;
yieldPerMin=null;
yieldPerMax=null;

delTerm=null;
weightTerm=null;
delPeriodStart=null;
delPeriodEnd=null;
vendorDecl=null;

gtaConNum=null;
rule=null;
conConditions=null;
conBNC=null;
gradeStandard=null;





//@wire (saveData,{opp: '$searchKey'}) Opportunity;

handleLoad(event){
    getData({ recordId:  this.recordId , rand: Math.random() })
    .then(data => {
       
        
        console.log(data);
        this.spreads=data.Spreads__c;
        this.tradeRecType=data.RecordTypeId;
        this.buyerCont=data.Buyer_s_Contact__c;

        this.actAs=data.AgVantage_Acting_as__c;
        this.comRateSeller=data.Commission_Rate_Unit__c;
        this.comRateBuyer=data.Commission_Rate_Unit_Buyer__c;
        this.comInvSeller=data.Commission_invoiced_to__c;
        this.comInvBuyer=data.Commission_invoiced_to_Buyer__c;
        this.brokerRep=null;
        this.busCredit=null;

        this.saleOrigin=data.Sale_Origin_Destination__c;
        this.grade=data.Grade__c;
        this.gradeSpread=data.Grade_Spreads__c;
        this.saleType=data.Type;

        this.conNum=null;
        this.variety=null;
        this.commodity=data.Commodity__c;
        this.conType=data.Contract_Type__c;
        this.cropYear=data.Crop_Year__c;
        this.tolerance=data.Tolerance__c;
        this.carryAmount=data.Carry_Amount__c;
        this.unitTime=data.Unit_of_Time__c;
        this.carryDateStart=data.Carry_Date_Start__c;
        this.carryDateEnd=data.Carry_Date_End__c;

        this.premium=data.Premium__c;
        this.discount=data.Discount__c;
        this.increment=data.Increments__c;
        this.payTerm=data.Payment_Terms__c;
        this.gstType=data.GST_Type__c;
        this.recCreTaxInv=data.Recipient_Created_Tax_Invoice_RCTI__c;

        this.areaHec=data.Area_hectares__c;
        this.yieldPerMin=data.Yield_units_per_ha_min__c;
        this.yieldPerMax=data.Yield_units_per_ha_max__c;
        this.transType=null;
        this.conDate=null;

        this.delTerm=data.Delivery_Terms__c;
       // this.freight=0;
       this.freightAcc=null;
       this.carrCon=null;
        this.weightTerm=data.Weight_Terms__c;
        this.delPeriodStart=data.Delivery_Period_Start__c;
        this.delPeriodEnd=data.Delivery_Period_End__c;
        this.vendorDecl=data.Vendor_Declarations__c;

        this.gtaConNum=data.GTA_Contract_Number__c;
        this.rule=data.Rules_Arbitra;
        this.conConditions=data.Contract_Conditions__c;
        this.conBNC=data.Confirmed_BNC__c;
        this.gradeStandard=data.Grade_Standards__c;
    })
    .catch(error => {
        alert(JSON.stringify(error));
        this.error = error;
    });
}
handleChangebrokerRep(event)
{
  
    this.brokerRep=event.detail.value;
}
handleChangebusCredit(event)
{
  
    this.busCredit=event.detail.value;
}
handleChangefreightAcc(event)
{
  
    this.freightAcc=event.detail.value;
}

handleChangetransType(event)
{
  
    this.transType=event.detail.value;
}


handleSuccess (){
    const evt = new ShowToastEvent({
        title: "Success!",
        message: "The Trades's record has been successfully saved.",
        variant: "success",
    });
    this.dispatchEvent(evt);
}

handleSubmit(event)
{
    //console.log('submitted data-->>'+JSON.stringify(event.detail));
    event.preventDefault(); 

    


   saveData({ opp: JSON.stringify(event.detail), recordId: this.recordId})
            .then(data => {
                this.handleSuccess();
                window.location.href = '/'+data;
            })
            .catch(error => {
                alert(JSON.stringify(error));
                this.error = error;
            });


}

handleSave(){
    alert('test');
}

handleClose(){
    this.dispatchEvent(new CloseActionScreenEvent());
 }
}