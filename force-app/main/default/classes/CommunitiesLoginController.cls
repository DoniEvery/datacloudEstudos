/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
    	String startUrl = System.currentPageReference().getParameters().get('startURL');
    	String displayType = System.currentPageReference().getParameters().get('display');
        
        // Se startURL contém login, remover startUrl (evitar loop recursivo)
        if (String.isNotBlank(startUrl) && (startUrl.toLowerCase().contains('/login'))) {
            startUrl = null;
        }
        
        return Network.forwardToAuthPage(startUrl, displayType);
    }
}