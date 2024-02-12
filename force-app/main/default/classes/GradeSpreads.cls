/**
*  Purpose         :    Controller for GradeSpreads VF page. 
*  Created By      :    Nashir (CattleDogdigital)
*  Created Date    :    2020-07-06 
*  Revision Logs   :    V_1.0 - Created 
**/
public class GradeSpreads 
{
    public Opportunity sOpportunity {get; set;}
    public list<Grade> lstGrades	{get; set;}
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////
    ////// Consrtuctor and init Function
    public GradeSpreads(ApexPages.StandardController controller)
    {
        sOpportunity = loadOppty(controller.getId());
        lstGrades = new list<Grade>();
    }
    
    public void init()
    {
        if(sOpportunity.Grade__c != null && sOpportunity.Grade_Spreads__c == null)
        {
            String[] lstSpread = sOpportunity.Grade__c.split(';');
                       
            for(string sKey : lstSpread)
            {
                lstGrades.add(new Grade(sKey.trim(), ''));                
           	}          
        }
        else if(sOpportunity.Grade__c != null)
        {
            String[] lstSpread = sOpportunity.Grade_Spreads__c.split(',');           
            integer i = 1;
            for(string sSpread : lstSpread)
            {                
                String[] arrKeyVal = sSpread.split(':');
                system.debug('arrKeyVal:'+arrKeyVal);
                system.debug('arrKeyVal[0]:'+arrKeyVal[0]);
                system.debug('arrKeyVal[1]:'+arrKeyVal[1]); 
                Grade sGrade = new Grade(arrKeyVal[0], arrKeyVal[1].trim());
                sGrade.iOrder = i;
                lstGrades.add(sGrade);
                i++;
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////// Public Function
    public void actionSave()
    {
		string strSpread = '';
        map<integer, Grade> mapsOrderToVal = new map<integer, Grade>();
        
        for(Grade sGrade : lstGrades)
        {
            mapsOrderToVal.put(sGrade.iOrder, sGrade);
        }
        
        for(integer i=1; i<=lstGrades.size(); i++)
        {
            Grade sGrade = mapsOrderToVal.get(i);
            strSpread += sGrade.strGradeName + ': ' + sGrade.dValue + ', ';
        }
        /*
        for(Grade sGrade : lstGrades)
        {
            strSpread += sGrade.strGradeName + ': ' + sGrade.dValue + ', ';
        }
        */
        strSpread = strSpread.left(strSpread.length()-2);
        
        sOpportunity.Grade_Spreads__c = strSpread;
        
        update sOpportunity;
    }
    
    public PageReference actionBack() 
    {        
        PageReference newPage = new PageReference('/' + sOpportunity.id);
        return newPage.setRedirect(true);
    }
    
    public class Grade
    {
        public string strGradeName 	{get; set;}
        public string dValue		{get; set;}
        public integer 	iOrder 		{get; set;}
        
        public Grade(string GradeName, string dVal)
        {
            this.strGradeName = GradeName;
            this.dValue = dVal;
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////// Private Function
    private Opportunity loadOppty(id sId)
    {
        return [select id,Commodity__c,Grade_Spreads__c,Grade__c from Opportunity where id=:sId];
    }
}