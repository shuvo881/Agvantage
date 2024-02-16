import { LightningElement, track } from 'lwc';
import all_banners from '@salesforce/resourceUrl/all_banners';

export default class AboutUsBannerComp extends LightningElement {
    @track banner = all_banners + '/all_banner/about_us.jpg'
}