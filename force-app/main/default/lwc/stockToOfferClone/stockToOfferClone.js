import { LightningElement, api, } from 'lwc';
// import StockClones from '@salesforce/apex/OffertoStockClone.StockClone';
import offerToStock from '@salesforce/apex/OffertoStockClone.offerToStock';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class StockToOfferClone extends LightningElement {

    connectedCallback() {
        var url = new URL(window.location.href);
        
        var getRecordId =  url.searchParams.get("recordId");
        alert(getRecordId);
        offerToStock({ recordId: getRecordId })
                .then(result => {
                    // alert(result);
                    console.log('result: ' + result);
                    
                    if(result != null && result.startsWith('a2o')){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Stock cloned successfully',
                                variant: 'success',
                            })
                        );
                        window.location.href = '/lightning/r/Stock__c/' + result + '/view';
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'Stock cloning failed',
                                variant: 'error',
                            })
                        );
                    }
                })
                .catch(error => {
                    console.log('error:'+ error);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'An error occurred while cloning the Stock',
                            variant: 'error'
                        })
                    );
            });
    }
}