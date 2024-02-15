import { LightningElement, track } from 'lwc';
import banner_imgs from '@salesforce/resourceUrl/banner_imgs';


export default class HeroComp extends LightningElement {
    @track bannerImg1 = banner_imgs + '/banner/banner1.jpg';
    @track bannerImg2 = banner_imgs + '/banner/banner2.jpg';
    @track bannerImg3 = banner_imgs + '/banner/banner3.jpg';
}