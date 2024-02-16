import { LightningElement,track } from 'lwc';
import Icons from '@salesforce/resourceUrl/SideBar';

export default class SideBarRightComp extends LightningElement {
    @track fb = Icons + '/SideBar/fb.png';
    @track twitter = Icons + '/SideBar/twitter.png';
    @track subscribe = Icons + '/SideBar/Subscribe-Button.png';
}