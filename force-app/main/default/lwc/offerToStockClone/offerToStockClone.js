import { LightningElement, api, } from 'lwc';
// import StockClones from '@salesforce/apex/OffertoStockClone.StockClone';
import stockToOffer from '@salesforce/apex/OffertoStockClone.stockToOffer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class OfferToStockClone extends LightningElement {
    connectedCallback() {
        var url = new URL(window.location.href);
        var getRecordId = url.searchParams.get("recordId");
            stockToOffer({ recordId: getRecordId })
                .then(result => {
                    // alert(result);
                    console.log('result: ' + result);
                    
                    if(result != null && result.startsWith('a02')){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Offer cloned successfully',
                                variant: 'success',
                            })
                        );
                        window.location.href = '/lightning/r/Available_Stock__c/' + result + '/view';
                    } else {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                message: 'Offer cloning failed',
                                variant: 'error',
                            })
                        );
                    }
                })
                .catch(error => {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error',
                            message: 'An error occurred while cloning the offer',
                            variant: 'error'
                        })
                    );
            });
    }
}