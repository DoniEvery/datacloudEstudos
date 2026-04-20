global class LightningForgotPasswordController {

    public LightningForgotPasswordController() {

    }

    @AuraEnabled
    public static String forgotPassword(String username, String checkEmailUrl) {
        try {
            if(!Site.isValidUsername(username)) {
                return Label.Site.invalid_email;
            }

            Boolean sent = Site.forgotPassword(username);

            // Fallback: em alguns cenários de Experience Cloud o método acima
            // retorna sem erro mas não dispara email de recuperação.
            if (!sent) {
                User usr = [SELECT Id, Email, Username FROM User WHERE Username = :username LIMIT 1];
                System.ResetPasswordResult resetResult = System.resetPassword(usr.Id, false);
                String tempPassword = resetResult != null ? resetResult.getPassword() : null;

                if (usr.Email != null) {
                    Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                    msg.setToAddresses(new String[] { usr.Email });
                    msg.setSubject('Recuperação de senha - donidone');
                    msg.setPlainTextBody(
                        'Olá,\n\n' +
                        'Recebemos uma solicitação de recuperação de senha para o usuário: ' + usr.Username + '.\n\n' +
                        'Senha temporária: ' + tempPassword + '\n\n' +
                        'Acesse a página de login da comunidade e altere sua senha após entrar.\n\n' +
                        'Se você não solicitou esta ação, ignore este email.'
                    );
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
                }
            }

            ApexPages.PageReference checkEmailRef = new PageReference(checkEmailUrl);
            aura.redirect(checkEmailRef);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();
        }
    }

    @AuraEnabled
    global static String setExperienceId(String expId) {    
        // Return null if there is no error, else it will return the error message 
        try {
            if (expId != null) {
                Site.setExperienceId(expId);               
            }
            return null; 
        } catch (Exception ex) {
            return ex.getMessage();            
        }        
    } 
}