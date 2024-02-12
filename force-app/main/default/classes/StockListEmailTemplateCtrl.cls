public class StockListEmailTemplateCtrl {
    
    // public List<Available_Stock__c> selectedStockList {get;set;}
    public Map<String, List<Available_Stock__c>> selectedStockList {get;set;}
    public String publicPageUrl {get;set;}

    public StockListEmailTemplateCtrl(){

        try {
        System.debug('StockListEmailTemplateCtrl-->start');

        // List<Available_Stock__c> stockObjMap = new List<Available_Stock__c>();
        Map<String, List<Available_Stock__c>> stockObjMap = new Map<String, List<Available_Stock__c>>();

        List<Email_Template_Temp_Values__c> stockCustomSettingList = new List<Email_Template_Temp_Values__c>();

        Set<String> stockIds = new Set<String>();

        //System.debug('Email_Template_Temp_Values__c-->'+Email_Template_Temp_Values__c);

        for(Email_Template_Temp_Values__c stock : [Select Stock_Id__c From Email_Template_Temp_Values__c]){
            stockIds.add(stock.Stock_Id__c);
        }

        System.debug('stockIds-->'+stockIds);

        Stock_Email_Settings__c ses = [Select Site_Url__c From Stock_Email_Settings__c Limit 1];

        System.debug('ses-->'+ses);

        List<String> stockIdList = new List<String>(stockIds);
        publicPageUrl = ses.Site_Url__c+'?ids='+String.join(stockIdList, ',');

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

            //System.debug('stock-->'+JSON.serializePretty(stock));

            stock.Other_Contaminants__c = 'black';
            System.debug('Status__c-->start');
            if(stock.Status__c=='Open'){
                stock.Other_Contaminants__c = 'green';
            }else if(stock.Status__c=='Traded'){
                stock.Other_Contaminants__c = 'red';
            }else if(stock.Status__c=='Expired'){
                stock.Other_Contaminants__c = '#a4a404';
            }else if(stock.Status__c=='Closed'){
                stock.Other_Contaminants__c = '#a10319';
            }
            System.debug('Status__c-->end');

            List<String> farmLocationGPS = new List<String>();

            System.debug('Sale_Origin_Destination__c-->start');
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
            System.debug('Sale_Origin_Destination__c-->end');

            stock.Price_Offered__c = ((stock.Price_Offered__c==null)?0:stock.Price_Offered__c) / (stock.Quantity__c==null?0:stock.Quantity__c);
            stock.Price_Target__c = (stock.Price_Target__c==null?0:stock.Price_Target__c) / (stock.Quantity__c==null?0:stock.Quantity__c);
            // stock.Delivery_Period_Start__c = DateTime.valueOf(stock.Delivery_Period_Start__c).format('d/m/Y');
            // stock.Delivery_Period_End__c = DateTime.valueOf(stock.Delivery_Period_End__c).format('d/m/Y');
            // stock.Last_Bid_Date__c = DateTime.valueOf(stock.Last_Bid_Date__c).format('d/m/Y');

            stock.Condition__c = String.valueOf(stock.Tolerance__c==null?'':stock.Tolerance__r.Name);

            List<String> cropYearStr = new List<String>();
            System.debug('cropYearSp-->start');
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
            System.debug('cropYearSp-->end');

            System.debug('Price_Offered__c-->start');

            if(stock.Price_Offered__c!=null){
                stock.Size__c = 'Offered';
                price = stock.Price_Offered__c;
            }
            if(stock.Price_Target__c!=null){
                stock.Size__c = 'Target';
                price = stock.Price_Target__c;
            }

            stock.Price_Target__c = price.setScale(2);

            System.debug('Price_Offered__c-->end');
            System.debug('stock.Commodity__c-->'+stock.Commodity__c);

            if(stock.Commodity__c !=null && !stockObjMap.containsKey(stock.Commodity__c)){
                stockObjMap.put(stock.Commodity__c, new List<Available_Stock__c>());
            }

            System.debug('Conditions__c-->start');
            stockObjMap.get(stock.Commodity__c).add(stock);

            List<String> conNote = new List<String>();

            if(stock.Conditions__c!=null){
                conNote.add(stock.Conditions__c);
            }

            if(stock.Comments__c!=null){
                conNote.add(stock.Comments__c);
            }

            stock.Conditions__c = String.join(conNote, ' / ');
            System.debug('Conditions__c-->end');
            // stockObjMap.add(stock);
        }


        
        selectedStockList = stockObjMap;

        System.debug('StockListEmailTemplateCtrl-->publicPageUrl-->'+publicPageUrl);
        System.debug('StockListEmailTemplateCtrl-->stocks-->'+selectedStockList);
            
        } catch (Exception ex) {
            System.debug('StockListEmailTemplateCtrl-->error-->'+ex.getMessage());
            
        } finally {
           // delete [Select Id From Email_Template_Temp_Values__c];
        }


    }

    public Map<String, List<Available_Stock__c>> getStockList() {

        return selectedStockList;
    }   


}