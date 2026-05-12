/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        
        // Se startURL contém login, remover startUrl (evitar loop recursivo)
        if (String.isNotBlank(startUrl) && (startUrl.toLowerCase().contains('/login'))) {
            startUrl = null;
        }
        
        return Site.login(username, password, startUrl);
    }
    
   	global SiteLoginController () {}
}