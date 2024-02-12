public class StockEmailListPublicCtrl {
    
    // public List<Available_Stock__c> selectedStockList {get;set;}
    public List<Available_Stock__c> selectedStockList {get;set;}
    public String publicPageUrl {get;set;}

    public StockEmailListPublicCtrl(){

        List<Available_Stock__c> availableStockList = new List<Available_Stock__c>();
        Set<String> stockIds = new Set<String>();

        String ids = Apexpages.currentPage().getParameters().get('ids');
        if(ids!=null){
            for(String str : ids.split(',')){
                stockIds.add(str);
            }
            
        }

        for(Available_Stock__c stock : [Select Id, 
        Account__r.Name, 
        Seller_Representative__r.Name, 
        Grade2__c,
        Name,
        Status__c,
        Commodity__c,
        Contract_Type__c,
        Crop_Year__c,
        Quantity__c,
        Tolerance__c,
        Tolerance__r.Name,
        Sale_Origin_Destination__c,
        Site_Available_Stocks__c,     
        Site_Available_Stocks__r.GPS__Latitude__s,     
        Site_Available_Stocks__r.GPS__Longitude__s,     
        Farm_Distance_km__c,
        Farm_Direction__c,
        Farm_Nearest_Town__c,
        Farm_Location_State__c,
        Farm_Road_Name__c,
        Delivery_Terms__c,
        Price_Offered__c,
        Price_Target__c,
        Grade_Spreads__c,
        Payment_Terms__c,
        Delivery_Period_Start__c,
        Delivery_Period_End__c,
        Farm_Location__r.GPS__Latitude__s,
        Farm_Location__r.GPS__Longitude__s,
        Farm_Location__c,
        Comments__c,
        Variety__c,
        Size__c,
        Conditions__c,
        Last_Bid_Date__c,
        Other_Contaminants__c
        From Available_Stock__c Where Id IN :stockIds Order By Commodity__c ASC]){

            stock.Other_Contaminants__c = 'black';

            if(stock.Status__c=='Open'){
                stock.Other_Contaminants__c = 'green';
            }else if(stock.Status__c=='Traded'){
                stock.Other_Contaminants__c = 'red';
            }else if(stock.Status__c=='Expired'){
                stock.Other_Contaminants__c = 'red1';
            }else if(stock.Status__c=='Closed'){
                stock.Other_Contaminants__c = 'red2';
            }

            List<String> farmLocationGPS = new List<String>();

            if(stock.Sale_Origin_Destination__c=='Ex-Farm/FOT'){
                
                farmLocationGPS = new List<String>();

                if(stock.Farm_Location__r.GPS__Latitude__s!=null)
                    farmLocationGPS.add(String.valueOf(stock.Farm_Location__r.GPS__Latitude__s));

                if(stock.Farm_Location__r.GPS__Longitude__s!=null)
                    farmLocationGPS.add(String.valueOf(stock.Farm_Location__r.GPS__Longitude__s));

                stock.Variety__c = String.join(farmLocationGPS, ',');
            }else{
                farmLocationGPS = new List<String>();
                
                if(stock.Site_Available_Stocks__r.GPS__Latitude__s!=null)
                    farmLocationGPS.add(String.valueOf(stock.Site_Available_Stocks__r.GPS__Latitude__s));
                if(stock.Site_Available_Stocks__r.GPS__Longitude__s!=null)
                    farmLocationGPS.add(String.valueOf(stock.Site_Available_Stocks__r.GPS__Longitude__s));

                stock.Variety__c = String.join(farmLocationGPS, ',');

            }

            stock.Price_Offered__c = ((stock.Price_Offered__c==null)?0:stock.Price_Offered__c) / stock.Quantity__c;
            stock.Price_Target__c = stock.Price_Target__c / stock.Quantity__c;
            // stock.Delivery_Period_Start__c = DateTime.valueOf(stock.Delivery_Period_Start__c).format('d/m/Y');
            // stock.Delivery_Period_End__c = DateTime.valueOf(stock.Delivery_Period_End__c).format('d/m/Y');
            // stock.Last_Bid_Date__c = DateTime.valueOf(stock.Last_Bid_Date__c).format('d/m/Y');

            stock.Condition__c = String.valueOf(stock.Tolerance__r.Name);

            List<String> cropYearStr = new List<String>();

            String[] cropYearSp = stock.Crop_Year__c.split('/');

            for(String s : cropYearSp){
                if(s=='2020'){
                    cropYearStr.add('20');
                }else{
                    cropYearStr.add(s.replace('20',''));
                }
            }

            stock.Crop_Year__c = String.join(cropYearStr, '/');

            Decimal price = 0.00;

            if(stock.Price_Offered__c!=null){
                stock.Size__c = 'Offered';
                price = stock.Price_Offered__c;
            }
            if(stock.Price_Target__c!=null){
                stock.Size__c = 'Target';
                price = stock.Price_Target__c;
            }

            stock.Price_Target__c = price.setScale(2);


            List<String> conNote = new List<String>();

            if(stock.Conditions__c!=null){
                conNote.add(stock.Conditions__c);
            }

            if(stock.Comments__c!=null){
                conNote.add(stock.Comments__c);
            }

            stock.Conditions__c = String.join(conNote, ' / ');

            availableStockList.add(stock);
        }

        this.selectedStockList = availableStockList;

    }

    public String getStockList() {

        System.debug('this.selectedStockList-->'+this.selectedStockList);

        List<wrapperObj> woList = new List<wrapperObj>();

        for(Available_Stock__c a : selectedStockList){
            wrapperObj wo = new wrapperObj();

            wo.bgColor = a.Other_Contaminants__c;
            wo.Id = a.Id;
            wo.Other_Contaminants = a.Other_Contaminants__c;
            wo.Name = a.Name;
            wo.Last_Bid_Date = (a.Last_Bid_Date__c==null)?'':a.Last_Bid_Date__c.format();
            wo.Status = a.Status__c;
            wo.Sale_Origin_Destination = a.Sale_Origin_Destination__c;
            wo.Commodity = a.Commodity__c;
            wo.Crop_Year = a.Crop_Year__c;
            wo.Grade = a.Grade2__c;
            wo.Contract_Type = a.Contract_Type__c;
            wo.Quantity = String.valueOf(a.Quantity__c);
            wo.Delivery_Terms = a.Delivery_Terms__c;
            wo.Condition = a.Condition__c;
            wo.Farm_Location_State = a.Farm_Location_State__c;
            wo.Variety = a.Variety__c;
            wo.Size = a.Size__c;
            wo.Price_Target = String.valueOf(a.Price_Target__c);
            wo.Grade_Spreads = a.Grade_Spreads__c;
            wo.Payment_Terms = a.Payment_Terms__c;
            wo.Delivery_Period_Start = (a.Delivery_Period_Start__c==null)?'':a.Delivery_Period_Start__c.format();
            wo.Delivery_Period_End = (a.Delivery_Period_End__c==null)?'':a.Delivery_Period_End__c.format();
            wo.Conditions = a.Conditions__c;
            wo.test2 = 'test,test'.split(',');
            woList.add(wo);
        }

        return JSON.serialize(woList);
    }   


    public class wrapperObj {

        public String Id {get;set;}
        public String Other_Contaminants {get;set;}
        public String Name {get;set;}
        public String Last_Bid_Date {get;set;}
        public String Status {get;set;}
        public String Sale_Origin_Destination {get;set;}
        public String Commodity {get;set;}
        public String Crop_Year {get;set;}
        public String Grade {get;set;}
        public String Contract_Type {get;set;}
        public String Quantity {get;set;}
        public String Delivery_Terms {get;set;}
        public String Condition {get;set;}
        public String Farm_Location_State {get;set;}
        public String Variety {get;set;}
        public String Size {get;set;}
        public String Price_Target {get;set;}
        public String Grade_Spreads {get;set;}
        public String Payment_Terms {get;set;}
        public String Delivery_Period_Start {get;set;}
        public String Delivery_Period_End {get;set;}
        public String Conditions {get;set;}
        public String[] test2 {get;set;}
        public String bgColor {get;set;}

    }

}