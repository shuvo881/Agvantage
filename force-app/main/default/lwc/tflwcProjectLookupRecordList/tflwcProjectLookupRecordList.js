import { LightningElement, api } from 'lwc';


export default class TflwcProjectLookupRecordList extends LightningElement {
    @api record;
    @api fieldname;
    @api buyerId;
    @api iconname;


    handleSelect(event){


        event.preventDefault();
        const selectedRecord = new CustomEvent(
            "select",
            {
                detail : this.record.Id
            }
        );
        this.dispatchEvent(selectedRecord);
    } 
}