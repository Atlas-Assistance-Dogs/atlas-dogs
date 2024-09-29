public inherited sharing class TeamService {

    public TeamService() {
        this.patRepo = new PublicAccessTestRepository();
        this.dogRepo = new DogRepository();
        this.contactRepo = new ContactRepository();
        this.teamRepo = new TeamRepository();
        this.relationshipRepo = new RelationshipRepository();
        this.emailServ = new EmailService();
    }
    @TestVisible
    private TeamService(TeamRepository teamRepo, PublicAccessTestRepository patRepo, RelationshipRepository relationshipRepo, EmailService emailServ, DogRepository dogRepo,
    ContactRepository contactRepo) {
        this.patRepo = patRepo;
        this.dogRepo = dogRepo;
        this.contactRepo = contactRepo;
        this.teamRepo = teamRepo;
        this.relationshipRepo = relationshipRepo;
        this.emailServ = emailServ;
    }
    private PublicAccessTestRepository patRepo;
    private ContactRepository contactRepo;
    private DogRepository dogRepo;
    private TeamRepository teamRepo;
    private RelationshipRepository relationshipRepo;
    private EmailService emailServ;

    // Set the dog/client relationship.
    // This is meant to be called from the team update trigger.
    public void setClientDogRelationShip(Team__c newTeam) {
        // See if there is an existing relationship between the dog and client
        List<DogRelationShip__c> relationShips = dogRepo.getRelationships(newTeam.Client__c, newTeam.Dog__c);

        if (relationShips.size() == 0) {
            DogRelationShip__c relationShip = new DogRelationShip__c(
                Contact__c = newTeam.Client__c,
                Dog__c = newTeam.Dog__c,
                Type__c = 'Client'
            );
            dogRepo.createRelationship(relationShip);
        } else {
            // add client to the type if not already there
            for (DogRelationShip__c relationShip : relationShips) {
                if (
                    relationShip.Type__c != null &&
                    relationShip.Type__c.contains('Client')
                ) {
                    return;
                }
            }
            // otherwise, add Client to the first relationship (should be the only one)
            DogRelationShip__c relationShip = relationShips[0];
            if (String.isBlank(relationShip.Type__c)) {
                relationShip.Type__c = 'Client';
            } else {
                relationShip.Type__c = relationShip.Type__c + ';Client';
            }
            dogRepo.modifyRelationship(relationShip);
        }
    }

    // Update client status.  This is meant to be called from the team update trigger.
    public void updateClientStatus(Team__c team) {
        Contact client = contactRepo.getClientStatus(team.Client__c);

        if (client != null) {
            Dog__c dog = dogRepo.getById(team.Dog__c);
            client.ClientCertificationValidUntil__c = team.PatValidUntil__c;
            client.ClientStatus__c = team.Status__c;
            client.ClientInitialCertificationDate__c = team.InitialCertificationDate__c;
            client.ClientFacilitatorAvailability__c = team.FacilitatorAvailability__c;
            if (dog != null) {
                client.ClientDog__c = dog.Name;
            }
            contactRepo.modify(client);
        }
    }

    // Update client status.  This is meant to be called from the team update trigger.
    public void updateDogStatus(Team__c team) {
        Dog__c dog = dogRepo.getById(team.Dog__c);

        if (dog != null) {
            dog.Status__c = team.Status__c;
            dogRepo.modify(dog);
        }
    }

    // Update PAT information
    public void updatePatInformation(Set<Id> teamIds) {
        List<Team__c> teams = [
            SELECT Id, Client__c, PatValidUntil__c, PatCount__c
            FROM Team__c
            WHERE Id IN :teamIds
        ];

        for (Team__c team : teams) {
            List<PublicAccessTest__c> passingPats = patRepo.getPassing(team.Id);
            if (passingPats.isEmpty()) {
                team.PatValidUntil__c = null;
            } else if (team.PatValidUntil__c != passingPats[0].ValidUntil__c) {
                team.PatValidUntil__c = passingPats[0].ValidUntil__c;
            }
            team.PatCount__c = passingPats.size();
        }
        teamRepo.modify(teams);
    }
    // Set the client/facilitator relationship.
    // This is meant to be called from the team update trigger.
    public void setClientFacilitatorRelationShip(Team__c newTeam) {
        if (newTeam.Facilitator__c == null)
            return; // nothing to do
        // See if there is an existing relationship between the client and facilitator
        List<npe4__Relationship__c> relationShips = relationshipRepo.getForPair(newTeam.Client__c, newTeam.Facilitator__c, 'Team Faciliator');

        // see if there is an existing relationship object to use
        for (npe4__Relationship__c relationShip : relationShips) {
            if (relationShip.npe4__Status__c == 'Current') {
                return;
            }
            // Set the status to current if not
            relationShip.npe4__Status__c = 'Current';
            relationshipRepo.modify(relationShip);
            return;
        }
        // if we made it to here, there isn't an existing relationship, so create a new one
        npe4__Relationship__c relationShip = new npe4__Relationship__c(
            npe4__Contact__c = newTeam.Client__c,
            npe4__RelatedContact__c = newTeam.Facilitator__c,
            npe4__Type__c = 'Team Faciliator',
            npe4__Status__c = 'Current'
        );
        relationshipRepo.create(relationShip);
    }

    // Remind the client in a Team to submit training logs
    public void remindClients() {
        List<Team__c> teams = teamRepo.getByStatus('In Training');
        if (teams.isEmpty()) return;
        // Loop through the teams and remind the clients that haven't logged this week
        Id orgAddressId = emailServ.getOrgEmailAddressId();
        EmailTemplate template = emailServ.getTemplate('ClientLogReminder');

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (Team__c team : teams) {
            emails.add(
                createEmail(
                    team.Id,
                    team.Client__c,
                    template.Id,
                    orgAddressId
                )
            );
        }
        emailServ.sendEmail(emails);
    }

    // Remind the client facilitators to submit training logs
    public void remindFacilitators() {
        List<Team__c> teams = teamRepo.getByStatus('In Training');
        if (teams.isEmpty()) return;

        // Get the org email address and template
        Id orgAddressId = emailServ.getOrgEmailAddressId();
        EmailTemplate template = emailServ.getTemplate('FacilitatorLogReminder');

        Map<Id, Id> teamContactIds = new Map<Id, Id>();
        for (Team__c team : teams) {
            teamContactIds.put(team.Client__c, team.Id);
        }

        List<npe4__Relationship__c> relationships = relationshipRepo.getCurrentRelated(teamContactIds.keySet(), 'Team Faciliator');

        // Loop through the teams and remind the faciltators for them
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for (npe4__Relationship__c relationship : relationships) {
            emails.add(
                createEmail(
                    teamContactIds.get(relationship.npe4__Contact__c),
                    relationship.npe4__RelatedContact__c,
                    template.Id,
                    orgAddressId
                )
            );
        }
        emailServ.sendEmail(emails);
    }

    private Messaging.SingleEmailMessage createEmail(
        Id teamId,
        Id contactId,
        Id templateId,
        Id emailAddressId
    ) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if (emailAddressId != null) {
            mail.setOrgWideEmailAddressId(emailAddressId);
        }   
        mail.setTargetObjectId(contactId);
        //Change with Template ID
        mail.setTemplateId(templateId);

        //Record ID for which letter will be generated
        mail.setWhatId(teamId);
        mail.setBccSender(false);
        mail.setUseSignature(false);
        // mail.setSenderDisplayName('Atlas Assistance Dogs');
        mail.setSaveAsActivity(false);
        return mail;
    }
}
