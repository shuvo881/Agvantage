import { LightningElement, api } from 'lwc';

export default class quickCottonLookupRecordList extends LightningElement {
    @api record;
    @api fieldname;
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