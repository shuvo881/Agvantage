import { LightningElement, track, api } from 'lwc';

export default class TflwcLookupSearchComponent extends LightningElement {
    
    @track searchKey;
    @api placeholder;
    @api label;
    @api errorDetails;


    handleChange(event){

        this.searchKey = event.target.value;

        clearTimeout(this.delayTimeout);

        if(this.searchKey.length > 1000){
            this.delayTimeout = setTimeout(() => {
                const searchEvent = new CustomEvent(
                    'change', 
                    { 
                        detail : this.searchKey
                    }
                );
                this.dispatchEvent(searchEvent);
            }, 3000);
        }

        const searchKey = event.target.value;


    //     event.preventDefault();
    //     const searchEvent = new CustomEvent(
    //         'change', 
    //         { 
    //             detail : searchKey
    //         }
    //     );
    //     this.dispatchEvent(searchEvent);
    }
}