public without sharing class ChartController {

    public String recordRelatedGrades { get; set; }
 public String recordBids { get; set; }
 public String recordRelatedGradeBids { get; set; }
 public Date selectedStartDateTime { get; set; }
 public Date selectedEndDateTime { get; set; }
 String theRecordID;
 Date theStartDate;
  Date theEndDate;
    public void init(){

        this.theRecordID = System.currentPageReference().getParameters().get('recordID');
        this.theStartDate = Date.valueOf(System.currentPageReference().getParameters().get('startDate'));
        this.theEndDate =  Date.valueOf(System.currentPageReference().getParameters().get('endDate'));

        recordRelatedGrades=getGrades(this.theRecordID);
        recordBids=getAllSelectedBids(this.theRecordID,this.theStartDate,this.theEndDate);
        recordRelatedGradeBids=getBidByGrade(this.theRecordID,this.theStartDate,this.theEndDate);

        selectedStartDateTime = Date.valueOf(System.currentPageReference().getParameters().get('startDate'));
        selectedEndDateTime = Date.valueOf(System.currentPageReference().getParameters().get('endDate'));
    }
    public PageReference redirectToTarget() {
        // Redirect to the target Visualforce page with a parameter
        PageReference targetPage = Page.HistoricalGraph; // Replace with the actual target page name
        targetPage.getParameters().put('recordID', this.theRecordID);
        targetPage.getParameters().put('startDate', (String.valueOf(selectedStartDateTime)));
        targetPage.getParameters().put('endDate', (String.valueOf(selectedEndDateTime)));
        targetPage.setRedirect(true);
        return targetPage;
    }


    @RemoteAction
        public static String getBidByGrade(String recordId,Date theStartDate,Date theEndDate) {
            Set<String> tempGradeBids=getGradesList(recordId);
            
Map<String, List<Bid__c>> bidsMap = new Map<String, List<Bid__c>>();
            for(String varbid:tempGradeBids)
            {
 Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c From Bid__c Where Id=:recordId Limit 1];
if(bidDetail.Grade__c!=varbid)
{
 List<Bid__c> bidList =[Select Id, Farming_Region_Name__c, Buyer_Name_Text__c, Price_Change__c, Site__c, Default_Date__c, Site__r.Name, Site_Name__c,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start__c, Delivery_End__c, Default_Date_Time__c, Grade__c, Price__c From Bid__c Where Site__c=:bidDetail.Site__c AND Commodity__c=:bidDetail.Commodity__c AND Crop_Year__c=:bidDetail.Crop_Year__c AND Sale_Origin_Destination__c=:bidDetail.Sale_Origin_Destination__c AND Grade__c=:varbid AND Default_Date__c >= :theStartDate AND Default_Date__c <= :theEndDate ORDER BY Default_Date__c DESC, Price__c DESC];

          
            List<Bid__c> itemsToShow = new List<Bid__c>();

            String previous_bid_date='';
            for (Bid__c bid:bidList)
            {
                if(String.valueOf(bid.Default_Date__c)==previous_bid_date)
                {
                    previous_bid_date=String.valueOf(bid.Default_Date__c);
                }
                else{
                    previous_bid_date=String.valueOf(bid.Default_Date__c);
                    itemsToShow.add(bid);
                }
                
            }
            bidsMap.put(varbid, itemsToShow);
            }

}
           

           return JSON.serialize(bidsMap);

           
        }

@RemoteAction
        public static String getGrades(String recordId) {
            Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c From Bid__c Where Id=:recordId Limit 1];

            List<Bid__c> bidList =[Select Id, Grade__c From Bid__c Where Site__c=:bidDetail.Site__c AND Commodity__c=:bidDetail.Commodity__c AND Crop_Year__c=:bidDetail.Crop_Year__c AND Sale_Origin_Destination__c=:bidDetail.Sale_Origin_Destination__c];

           Set<String> options = new Set<String>();
           for (Bid__c bid:bidList)
           {
              options.add(bid.Grade__c);
               
           }
           return JSON.serialize(options);
        }
@RemoteAction
        public static Set<String> getGradesList(String recordId) {
            Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c From Bid__c Where Id=:recordId Limit 1];

            List<Bid__c> bidList =[Select Id, Grade__c From Bid__c Where Site__c=:bidDetail.Site__c AND Commodity__c=:bidDetail.Commodity__c AND Crop_Year__c=:bidDetail.Crop_Year__c AND Sale_Origin_Destination__c=:bidDetail.Sale_Origin_Destination__c];

           Set<String> options = new Set<String>();
           for (Bid__c bid:bidList)
           {
              options.add(bid.Grade__c);
               
           }
           return options;
        }


      @RemoteAction
      public static String getAllSelectedBids(String recordId,Date theStartDate,Date theEndDate){

      
        Bid__c bidDetail = [Select Id, Site__c, Commodity__c, Grade__c, Crop_Year__c,Delivery_Start__c,Delivery_End__c,Sale_Origin_Destination__c From Bid__c Where Id=:recordId Limit 1];

        List<Bid__c> bidList = [Select Id, Farming_Region_Name__c, Buyer_Name_Text__c, Price_Change__c, Site__c, Default_Date__c, Site__r.Name, Site_Name__c,  Buyer_Name__c, Buyer_Name__r.Name,  Bidders_Contact__c, Sale_Origin_Destination__c, Bidders_Contact__r.Name, Name, Commodity__c, Crop_Year__c, Delivery_Start__c, Delivery_End__c, Default_Date_Time__c, Grade__c, Price__c  From Bid__c Where Site__c=:bidDetail.Site__c And Commodity__c=:bidDetail.Commodity__c And Grade__c=:bidDetail.Grade__c and Crop_Year__c=:bidDetail.Crop_Year__c AND Sale_Origin_Destination__c=:bidDetail.Sale_Origin_Destination__c AND Default_Date__c >= :theStartDate AND Default_Date__c <= :theEndDate ORDER BY Default_Date__c DESC, Price__c DESC];
        
        List<Bid__c> itemsToShow = new List<Bid__c>();

        String previous_bid_date='';
        for (Bid__c bid:bidList)
        {
            if(String.valueOf(bid.Default_Date__c)==previous_bid_date)
            {
                previous_bid_date=String.valueOf(bid.Default_Date__c);
            }
            else{
                previous_bid_date=String.valueOf(bid.Default_Date__c);
                itemsToShow.add(bid);
            }
            
        }
        return JSON.serialize(itemsToShow);
        

    }
}