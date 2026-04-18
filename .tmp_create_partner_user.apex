String accountId = '001fj00000oIRugAAG';
String password = 'Teste@12345';
Long ts = DateTime.now().getTime();
String email = 'test.partner.login+' + String.valueOf(ts) + '@example.com';
String aliasValue = 'tp' + String.valueOf(ts).right(6);
if (aliasValue.length() > 8) aliasValue = aliasValue.substring(0,8);
String nickname = 'tpartner' + String.valueOf(ts);
Map<String, Object> out = new Map<String, Object>();
out.put('AccountId', accountId);
out.put('Username', email);
out.put('Password', password);
out.put('ContactId', null);
out.put('UserId', null);
out.put('ProfileId', null);
out.put('IsActive', null);
out.put('Success', false);
out.put('Errors', new List<Object>());
out.put('ProbableCause', null);

List<Object> errors = (List<Object>)out.get('Errors');

try {
    Account acct = [SELECT Id, Name, IsPartner, OwnerId, Owner.UserRoleId FROM Account WHERE Id = :accountId LIMIT 1];
    out.put('AccountName', acct.Name);
    out.put('AccountIsPartner', acct.IsPartner);
    out.put('AccountOwnerId', acct.OwnerId);
    out.put('AccountOwnerUserRoleId', acct.Owner.UserRoleId);

    Contact c = new Contact(
        AccountId = accountId,
        FirstName = 'Teste',
        LastName = 'PartnerLogin',
        Email = email
    );
    insert c;
    out.put('ContactId', c.Id);

    List<String> profileIds = new List<String>{ '00efj000008laOaAAI', '00efj000008laPWAAY' };
    Map<String, String> profileNames = new Map<String, String>{
        '00efj000008laOaAAI' => 'SDO-Partners',
        '00efj000008laPWAAY' => 'Partner Community Login User'
    };

    User createdUser;

    for (String pid : profileIds) {
        try {
            User u = new User(
                Username = email,
                Email = email,
                LastName = 'PartnerLogin',
                Alias = aliasValue,
                TimeZoneSidKey = 'America/Sao_Paulo',
                LocaleSidKey = 'pt_BR',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'pt_BR',
                CommunityNickname = nickname,
                ContactId = c.Id,
                ProfileId = pid,
                IsActive = true
            );
            insert u;
            createdUser = [SELECT Id, ProfileId, Username, IsActive FROM User WHERE Id = :u.Id LIMIT 1];
            break;
        } catch (Exception exUser) {
            Map<String, Object> err = new Map<String, Object>();
            err.put('Step', 'CreateUser');
            err.put('TriedProfileId', pid);
            err.put('TriedProfileName', profileNames.get(pid));
            err.put('Message', exUser.getMessage());
            errors.add(err);
        }
    }

    if (createdUser == null) {
        String probableCause = 'Falha ao criar usu?rio externo partner.';
        String combined = JSON.serialize(errors).toLowerCase();
        if (combined.contains('portal account owner must have a role')) {
            probableCause = 'O owner da account parceira n?o possui UserRoleId.';
        } else if (combined.contains('contact can be associated only with portal enabled account')) {
            probableCause = 'A account informada n?o est? habilitada como partner/portal.';
        } else if (combined.contains('profile')) {
            probableCause = 'Os perfis informados n?o s?o v?lidos para cria??o de usu?rio partner externo nesta org.';
        } else if (combined.contains('community nickname')) {
            probableCause = 'CommunityNickname n?o ?nico.';
        } else if (combined.contains('username')) {
            probableCause = 'Username globalmente duplicado.';
        }
        out.put('ProbableCause', probableCause);
    } else {
        out.put('UserId', createdUser.Id);
        out.put('ProfileId', createdUser.ProfileId);
        out.put('IsActive', createdUser.IsActive);
        System.setPassword(createdUser.Id, password);
        out.put('Success', true);
    }
} catch (Exception ex) {
    Map<String, Object> err = new Map<String, Object>();
    err.put('Step', 'General');
    err.put('Message', ex.getMessage());
    errors.add(err);
    String probableCause = 'Falha geral na cria??o do contato/usu?rio.';
    String msg = String.valueOf(ex.getMessage()).toLowerCase();
    if (msg.contains('insufficient access') || msg.contains('insufficient privileges')) {
        probableCause = 'Permiss?es insuficientes no org alvo.';
    } else if (msg.contains('invalid cross reference id')) {
        probableCause = 'AccountId ou ProfileId inv?lido para esta org.';
    }
    out.put('ProbableCause', probableCause);
}
System.debug('FINAL_JSON=' + JSON.serialize(out));