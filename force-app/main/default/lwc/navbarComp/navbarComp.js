import { LightningElement, track } from 'lwc';
import Logo from '@salesforce/resourceUrl/Logo';
import Banners from '@salesforce/resourceUrl/banner_imgs';
import SearchIcon from '@salesforce/resourceUrl/search_bar_img';

//import bootstrap from '@salesforce/resourceUrl/bootstrap_community';
// Example :- import TRAILHEAD_LOGO from '@salesforce/resourceUrl/trailhead_logo';'
export default class NavbarComp extends LightningElement {
    
    @track company_logo = Logo + '/Logos/logoBig.png';

    @track company_Banner_1 = Banners + '/banner/banner1.jpg';
    @track company_Banner_2 = Banners + '/banner/banner2.jpg';
    @track company_Banner_3 = Banners + '/banner/banner3.jpg';

    @track SearchIcon = SearchIcon + '/search_bar_img/search.png';
    
    
    
    
    
    
    
    
    
    
    
    // renderedCallback(){
    //     Promise.all([
    //         loadScript(this, bootstrap + '/bootstrap-5.0.2-dist/css/bootstrap.min.css'),
    //         loadScript(this, bootstrap + '/bootstrap-5.0.2-dist/bootstrap.js'),
    //     ])
    //     .then(() => {
    //         console.log('Bootstrap Working');
    //     })
    //     .catch(err => {
    //         console.log(err);
    //     })
    // }
}