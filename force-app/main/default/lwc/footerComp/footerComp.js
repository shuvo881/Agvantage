import { LightningElement, track } from 'lwc';
import Logo from '@salesforce/resourceUrl/Logo';
// Example :- import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';

export default class FooterComp extends LightningElement {
    @track company_logo_small = Logo+'/Logos/logoSmall.png';
}