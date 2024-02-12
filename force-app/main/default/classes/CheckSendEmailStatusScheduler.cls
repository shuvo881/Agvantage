public class CheckSendEmailStatusScheduler implements Schedulable {

    public static Check_Email_Status_Scheduler__c customSetting {
        get {
            return [Select Id, Scheduler_Name__c, Stop__c, Interval__c From Check_Email_Status_Scheduler__c];
        }
        set;
    }

    public CheckSendEmailStatusScheduler(){

        List<Contact> contactList = [SELECT ID, Email FROM Contact WHERE Email != Null];
        System.debug('Number of contacts having email address: ' + contactList.size());
        Set<String> seenEmails = new Set<String>();
        Set<String> duplicateEmail = new Set<String>();
        for (Contact c: contactList)  {
            if (!seenEmails.contains(c.Email)) {
                seenEmails.add(c.Email);
            }
            else {
                duplicateEmail.add(c.Email);
            }
        }
        List<String> duplicateEmailList = new List<String>(duplicateEmail);
        
        List<Contact> duplicateContactEmails = [SELECT ID, Email FROM Contact WHERE Email IN :duplicateEmailList];
        List<Contact> updateList = new List<Contact>();
        
        for(Contact c : duplicateContactEmails ){
            c.Multiple_Contact_Records__c = true;
            updateList.add(c);
        }
        
        System.debug('Number of contacts having same email address: ' + updateList.size());
        if(updateList.size() > 0){
            update updateList;
        }

    }

    public void execute(SchedulableContext ctx) {

        if(customSetting.Stop__c==false){
            CronTrigger[] existingJobs = [SELECT Id,CronJobDetailId,CronJobDetail.Name FROM CronTrigger WHERE CronJobDetail.Name = :customSetting.Scheduler_Name__c];
            for (CronTrigger existingJob: existingJobs) {
                System.abortJob(existingJob.Id);
            }
    
            CheckSendEmailStatusScheduler ses = new CheckSendEmailStatusScheduler ();
            Datetime dt = Datetime.now();
            dt = dt.addMinutes((Integer)customSetting.Interval__c);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
            Id schedId = System.Schedule(customSetting.Scheduler_Name__c, timeForScheduler, ses);
    
            // System.schedule(CheckSendEmailStatusScheduler.customSetting.Scheduler_Name__c, '0 48 * * * ?', new CheckSendEmailStatusScheduler());

        }

     
     }

}