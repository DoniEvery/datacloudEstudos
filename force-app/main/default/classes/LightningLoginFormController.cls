global class LightningLoginFormController {

    public LightningLoginFormController() {
        
    }

    @AuraEnabled
    public static String login(String username, String password, String startUrl) {
        try {
            // Se startURL contém login, remover startUrl (evitar loop recursivo)
            if (String.isNotBlank(startUrl) && (startUrl.toLowerCase().contains('/login'))) {
                startUrl = null;
            }
            
            ApexPages.PageReference lgn = Site.login(username, password, startUrl);
            aura.redirect(lgn);
            return null;
        }
        catch (Exception ex) {
            return ex.getMessage();            
        }
    }

    @AuraEnabled
    public static String loginLwc(String username, String password, String startUrl) {
        // Se startURL contém login, remover startUrl (evitar loop recursivo)
        if (String.isNotBlank(startUrl) && (startUrl.toLowerCase().contains('/login'))) {
            startUrl = null;
        }
        
        Integer maxRetries = 3;
            Integer retryDelay = 500;
        
        for (Integer i = 0; i < maxRetries; i++) {
            try {
                ApexPages.PageReference lgn = Site.login(username, password, startUrl);
                if (lgn != null) {
                    return lgn.getUrl();
                }
                return null;
            } catch (Exception ex) {
                if (i < maxRetries - 1) {
                    retryDelay = retryDelay * 2;
                        System.debug(LoggingLevel.WARN, 'Login attempt ' + (i + 1) + ' failed: ' + ex.getMessage());
                    Long startTime = DateTime.now().getTime();
                    while (DateTime.now().getTime() - startTime < retryDelay) {
                            // delay
                    }
                } else {
                        System.debug(LoggingLevel.ERROR, 'Login failed after ' + maxRetries + ' attempts');
                        return 'Erro de conexão. Tente novamente.';
                }
            }
        }
            return 'Erro desconhecido.';
    }
    
    @AuraEnabled
    public static Boolean getIsUsernamePasswordEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getUsernamePasswordEnabled();
    }

    @AuraEnabled
    public static Boolean getIsSelfRegistrationEnabled() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getSelfRegistrationEnabled();
    }

    @AuraEnabled
    public static String getSelfRegistrationUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        if (authConfig.getSelfRegistrationEnabled()) {
            return authConfig.getSelfRegistrationUrl();
        }
        return null;
    }

    @AuraEnabled
    public static String getForgotPasswordUrl() {
        Auth.AuthConfiguration authConfig = getAuthConfig();
        return authConfig.getForgotPasswordUrl();
    }
    
    @TestVisible
    private static Auth.AuthConfiguration getAuthConfig(){
        Id networkId = Network.getNetworkId();
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(networkId,'');
        return authConfig;
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