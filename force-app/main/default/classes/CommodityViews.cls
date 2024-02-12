public with sharing class CommodityViews 
{
    public string                       strDataTable    {get; private set;}
    private list<wrapperCommodityView>   lstCView;

    public class wrapperCommodityView
    {
        public string strCommodity      {get; private set;}
        public string strInstrument     {get; private set;}
        public string srtContract       {get; private set;}
        public decimal dLast            {get; private set;}
        public decimal dPrevious        {get; private set;}
        public string strChange         {get; private set;}    
        public string strChangePer      {get; private set;}
        public string strYTDHigh        {get; private set;}
        public string strYTDLow         {get; private set;}
        public string strBasisUSD       {get; private set;}
        public string strBasisAUD       {get; private set;}
        public string strUSDUOM         {get; private set;}
        public string strAUDUOM         {get; private set;}

        public wrapperCommodityView(Commodity_View__c sCV)
        {
            this.strCommodity   = sCV.Commodity__c;
            this.strInstrument  = sCV.Instrument__c;
            this.srtContract    = sCV.Contract__c;
            this.dLast          = sCV.Last__c;
            this.dPrevious      = sCV.Previous__c;
            this.strChange      = sCV.Change__c;
            this.strChangePer   = sCV.P_Change__c;
            this.strYTDHigh     = sCV.YTD_High__c;
            this.strYTDLow      = sCV.YTD_Low__c;
            this.strBasisUSD    = sCV.Basis_USD__c;
            this.strBasisAUD    = sCV.Basis_AUD__c;
            this.strUSDUOM      = sCV.USD_UOM__c;
            this.strAUDUOM      = sCV.AUD_UOM__c;
        }
    }

    public CommodityViews()
    {
        lstCView = new list<wrapperCommodityView>();
    }

    public void init()
    {
        date dtToday = system.today();
        // Load today's data
        lstCView = loadCommodity(dtToday);
        // If no data found load yesterdays data
        if(lstCView.isEmpty())
        {
            dtToday = dtToday.addDays(-1);
            lstCView = loadCommodity(dtToday);
        }

        strDataTable = JSON.serialize(lstCView);
    }

    private list<wrapperCommodityView> loadCommodity(date dtDate)
    {
        list<wrapperCommodityView>   lstReturn = new list<wrapperCommodityView>();

        for(Commodity_View__c sCV : [select id,Commodity__c,Instrument__c,Contract__c,Last__c,Change__c,P_Change__c,Previous__c,
                                            YTD_High__c,YTD_Low__c,Basis_USD__c,Basis_AUD__c,USD_UOM__c,AUD_UOM__c
                                    from    Commodity_View__c 
                                    where   Commodity__c <> null
                                    and     Date__c =: dtDate])
        {
            lstReturn.add(new wrapperCommodityView(sCV));
        }

        return lstReturn;
    }
}