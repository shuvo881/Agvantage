import { LightningElement, track } from 'lwc';
import appointment_form from '@salesforce/resourceUrl/appointment_form';


export default class FormsComp extends LightningElement {
    @track AppointemntForm =  appointment_form + '/appointment_form/Appointment-of-Grower-Agent.pdf'
}