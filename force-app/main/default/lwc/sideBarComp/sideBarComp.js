import { LightningElement, track } from 'lwc';
import Icons from '@salesforce/resourceUrl/SideBar';
// Example :- import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';

export default class SideBarComp extends LightningElement {

    @track fb = Icons + '/SideBar/fb.png';
    @track twitter = Icons + '/SideBar/twitter.png';
    @track subscribe = Icons + '/SideBar/Subscribe-Button.png';

}