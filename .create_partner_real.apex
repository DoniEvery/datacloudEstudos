String targetEmail = 'adonikan@gmail.com';
Id accountId = '001fj00000oIRugAAG';
Id profileId = '00efj000008laOaAAI';
Id networkId = '0DBfj0000020enVGAQ';
String initialPassword = 'Teste@12345';
Map<String, Object> out = new Map<String, Object>();
List<String> attemptedUsernames = new List<String>();
List<String> attemptErrors = new List<String>();

try {
    List<User> existingMatches = [
        SELECT Id, Username, Email, ProfileId, Profile.Name, ContactId, IsActive
        FROM User
        WHERE Username = :targetEmail OR Email = :targetEmail
    ];
    out.put('existingUserMatches', existingMatches);

    Contact partnerContact;
    List<Contact> existingContacts = [
        SELECT Id, FirstName, LastName, Email, AccountId, Account.Name
        FROM Contact
        WHERE Email = :targetEmail
        LIMIT 1
    ];
    if (!existingContacts.isEmpty()) {
        partnerContact = existingContacts[0];
    } else {
        partnerContact = new Contact(
            FirstName = 'Adonikan',
            LastName = 'PartnerReal',
            Email = targetEmail,
            AccountId = accountId
        );
        insert partnerContact;
    }
    out.put('contactLookup', partnerContact);

    if (partnerContact.AccountId != accountId) {
        out.put('success', false);
        out.put('error', 'Existing contact with the target email belongs to a different account.');
        out.put('probableCause', 'The email is already attached to a contact outside Acme Partners, preventing a safe partner-user linkage under the requested account.');
    } else {
        User partnerUser;
        List<User> reusableUsers = [
            SELECT Id, Username, Email, ProfileId, Profile.Name, ContactId, IsActive
            FROM User
            WHERE Email = :targetEmail AND ProfileId = :profileId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];
        if (!reusableUsers.isEmpty()) {
            partnerUser = reusableUsers[0];
            if (!partnerUser.IsActive) {
                partnerUser.IsActive = true;
                update partnerUser;
                partnerUser = [SELECT Id, Username, Email, ContactId, IsActive FROM User WHERE Id = :partnerUser.Id];
            }
            out.put('reused', true);
        } else {
            out.put('reused', false);
            String ts = String.valueOf(Datetime.now().getTime());
            List<String> usernames = new List<String>{
                targetEmail,
                'adonikan+partnerreal@gmail.com',
                'adonikan+partnerreal' + ts + '@gmail.com'
            };

            for (String candidateUsername : usernames) {
                attemptedUsernames.add(candidateUsername);
                String nickname = 'adonikanpartner' + String.valueOf(Datetime.now().getTime());
                User newUser = new User(
                    Username = candidateUsername,
                    Email = targetEmail,
                    LastName = 'PartnerReal',
                    Alias = 'adonreal',
                    TimeZoneSidKey = 'America/Sao_Paulo',
                    LocaleSidKey = 'pt_BR',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'pt_BR',
                    CommunityNickname = nickname,
                    ContactId = partnerContact.Id,
                    ProfileId = profileId,
                    IsActive = true
                );

                Database.SaveResult userInsert = Database.insert(newUser, false);
                if (userInsert.isSuccess()) {
                    partnerUser = [SELECT Id, Username, Email, ContactId, IsActive FROM User WHERE Id = :userInsert.getId()];
                    break;
                }

                List<String> currentErrors = new List<String>();
                Boolean retryableDuplicate = false;
                for (Database.Error e : userInsert.getErrors()) {
                    String msg = String.valueOf(e.getStatusCode()) + ': ' + e.getMessage();
                    currentErrors.add(msg);
                    String lowerMsg = e.getMessage() == null ? '' : e.getMessage().toLowerCase();
                    if (lowerMsg.contains('username') || lowerMsg.contains('duplicate username') || lowerMsg.contains('already exists')) {
                        retryableDuplicate = true;
                    }
                }
                attemptErrors.add(String.join(currentErrors, ' | '));
                if (!retryableDuplicate) {
                    break;
                }
            }

            if (partnerUser == null) {
                out.put('success', false);
                out.put('attemptedUsernames', attemptedUsernames);
                out.put('attemptErrors', attemptErrors);
                String combinedErrors = String.join(attemptErrors, ' || ');
                out.put('error', combinedErrors);
                String probableCause = 'User creation failed due to validation, sharing, or external-user provisioning restrictions.';
                String lowerCombined = combinedErrors == null ? '' : combinedErrors.toLowerCase();
                if (lowerCombined.contains('username')) {
                    probableCause = 'All candidate usernames were unavailable because Salesforce usernames are globally unique.';
                } else if (lowerCombined.contains('portal account owner must have a role')) {
                    probableCause = 'The owner of Acme Partners likely does not have a role, which blocks partner-user creation.';
                } else if (lowerCombined.contains('community nickname')) {
                    probableCause = 'The generated community nickname was not accepted as unique or valid.';
                } else if (lowerCombined.contains('contact')) {
                    probableCause = 'The selected contact may not be eligible for partner-user creation.';
                }
                out.put('probableCause', probableCause);
            }
        }

        if (partnerUser != null) {
            Integer groupCount = [SELECT count() FROM NetworkMemberGroup WHERE ParentId = :profileId AND NetworkId = :networkId];
            out.put('NetworkMemberGroupExists', groupCount > 0);

            Integer membershipCount = [SELECT count() FROM NetworkMember WHERE MemberId = :partnerUser.Id AND NetworkId = :networkId];
            Integer finalMembershipCount = membershipCount;
            if (membershipCount == 0) {
                finalMembershipCount = [SELECT count() FROM NetworkMember WHERE MemberId = :partnerUser.Id AND NetworkId = :networkId];
                if (finalMembershipCount == 0) {
                    out.put('success', false);
                    out.put('error', 'Network membership was not present in donidone after user provisioning.');
                    out.put('probableCause', 'The user was created, but the requested community membership did not materialize automatically for this profile/network combination.');
                }
            }

            System.setPassword(partnerUser.Id, initialPassword);
            partnerUser = [SELECT Id, Username, Email, ContactId, IsActive FROM User WHERE Id = :partnerUser.Id];

            out.put('success', !out.containsKey('error'));
            out.put('Username', partnerUser.Username);
            out.put('Email', partnerUser.Email);
            out.put('UserId', partnerUser.Id);
            out.put('ContactId', partnerUser.ContactId);
            out.put('Password', initialPassword);
            out.put('IsActive', partnerUser.IsActive);
            out.put('NetworkId', networkId);
            out.put('NetworkMembershipCount', finalMembershipCount);
            out.put('attemptedUsernames', attemptedUsernames);
            out.put('attemptErrors', attemptErrors);
        }
    }
} catch (Exception e) {
    String message = e.getMessage();
    String probableCause = 'Unexpected Apex execution failure.';
    String lowerMessage = message == null ? '' : message.toLowerCase();
    if (lowerMessage.contains('portal account owner must have a role')) {
        probableCause = 'The owner of Acme Partners likely does not have a role, which blocks partner-user creation.';
    } else if (lowerMessage.contains('username')) {
        probableCause = 'A required username was unavailable or invalid.';
    } else if (lowerMessage.contains('network')) {
        probableCause = 'Community/network setup prevented membership provisioning.';
    }
    out.put('success', false);
    out.put('error', message);
    out.put('probableCause', probableCause);
    out.put('stackTrace', e.getStackTraceString());
    out.put('attemptedUsernames', attemptedUsernames);
    out.put('attemptErrors', attemptErrors);
}

System.debug(LoggingLevel.ERROR, 'RESULT_JSON:' + JSON.serialize(out));
