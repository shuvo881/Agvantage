public with sharing class ForgotPassController {
    public ForgotPassController() {

    }
    @AuraEnabled
    public static string customForgotPassword(String username){
        
        try {
            List <User> usr = [SELECT Id FROM User WHERE Email=: username LIMIT 1];
            if (!usr.isEmpty()){
                System.resetPassword(usr[0].Id, true);
                return 'Email send successfully.';
            }
            return 'The user does not exist.';

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}