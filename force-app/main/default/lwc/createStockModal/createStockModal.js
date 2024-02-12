import { LightningElement,api,track,wire } from 'lwc';

import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveData from '@salesforce/apex/getContactforStock.saveData';
import getData from '@salesforce/apex/getContactforStock.getData';

export default class CreateStockModal extends LightningElement {
    @api recordId;
    sellerTradeName=null;
    sellerRep=null;
handleLoad(event){
    //alert("recordId"+this.recordId);

    getData({ recordId:  this.recordId , rand: Math.random() })
    .then(data => {
        this.sellerTradeName=data.AccountId;
       this.sellerRep=this.recordId;



    })
    .catch(error => {
        alert(JSON.stringify(error));
        this.error = error;
    });
}

handleClose(){
    this.dispatchEvent(new CloseActionScreenEvent());
 }

 handleSuccess (){
    const evt = new ShowToastEvent({
        title: "Success!",
        message: "The Stock's record has been successfully saved.",
        variant: "success",
    });
    this.dispatchEvent(evt);
}


 handleSubmit(event)
 {
     //console.log('submitted data-->>'+JSON.stringify(event.detail));
     event.preventDefault(); 
 //alert(JSON.stringify(event.detail));
 
    saveData({ stock: JSON.stringify(event.detail), rand: Math.random()})
             .then(data => {
                 this.handleSuccess();
                 window.location.href = '/'+data;
             })
             .catch(error => {
                 alert(JSON.stringify(error));
                 this.error = error;
             });
 
 
 }

}