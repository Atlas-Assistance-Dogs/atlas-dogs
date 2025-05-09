public inherited sharing class TeamService{
  public TeamService(){
    this.patRepo = new PublicAccessTestRepository();
    this.dogRepo = new DogRepository();
    this.contactRepo = new ContactRepository();
    this.teamRepo = new TeamRepository();
    this.relationshipRepo = new RelationshipRepository();
    this.emailServ = new EmailService();
  }

  @TestVisible
  private TeamService(TeamRepository teamRepo, PublicAccessTestRepository patRepo, RelationshipRepository relationshipRepo, EmailService emailServ, DogRepository dogRepo, ContactRepository contactRepo){
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
  public void setClientDogRelationShip(Team__c newTeam){
    // See if there is an existing relationship between the dog and client
    List<DogRelationShip__c> relationShips = dogRepo.getRelationships(newTeam.Client__c, newTeam.Dog__c);

    if (relationShips.size() == 0){
      DogRelationShip__c relationShip = new DogRelationShip__c(
        Contact__c = newTeam.Client__c, 
        Dog__c = newTeam.Dog__c, 
        Type__c = 'Client'
      );
      dogRepo.createRelationship(relationShip);
    } else{
      // add client to the type if not already there
      for (DogRelationShip__c relationShip : relationShips){
        if (relationShip.Type__c != null && relationShip.Type__c.contains('Client')){
          return;
        }
      }
      // otherwise, add Client to the first relationship (should be the only one)
      DogRelationShip__c relationShip = relationShips[0];
      if (String.isBlank(relationShip.Type__c)){
        relationShip.Type__c = 'Client';
      } else{
        relationShip.Type__c = relationShip.Type__c + ';Client';
      }
      dogRepo.modifyRelationship(relationShip);
    }
  }

  // Update client status.  This is meant to be called from the team update trigger.
  public void updateClientStatus(Team__c team){
    Contact client = contactRepo.getClientStatus(team.Client__c);

    if (client != null){
      Dog__c dog = dogRepo.getById(team.Dog__c);
      client.ClientCertificationValidUntil__c = team.PatValidUntil__c;
      client.ClientStatus__c = team.Status__c;
      client.ClientInitialCertificationDate__c = team.InitialCertificationDate__c;
      client.ClientFacilitatorAvailability__c = team.FacilitatorAvailability__c;
      if (dog != null){
        client.ClientDog__c = dog.Name;
      }
      contactRepo.modify(client);
    }
  }

  // Update client status.  This is meant to be called from the team update trigger.
  public void updateDogStatus(Team__c team){
    Dog__c dog = dogRepo.getById(team.Dog__c);

    if (dog != null){
      dog.Status__c = team.Status__c;
      dog.XrayRequired__c = team.XrayRequired__c;
      dogRepo.modify(dog);
    }
  }

  // Update PAT information
  public void updatePatInformation(Set<Id> teamIds){
    List<Team__c> teams = teamRepo.getByIds(teamIds);

    for (Team__c team : teams){
      List<PublicAccessTest__c> passingPats = patRepo.getPassing(team.Id);
      if (passingPats.isEmpty()){
        team.PatValidUntil__c = null;
      } else if (team.PatValidUntil__c != passingPats[0].ValidUntil__c){
        team.PatValidUntil__c = passingPats[0].ValidUntil__c;
      }
      team.PatCount__c = passingPats.size();
    }

    teamRepo.modify(teams);
  }

  // Set InitialCertificationDate when first ClientCertAgreementReceived.
  // Called from TeamTriggerBefore
  public void setTeamHandler(List<Team__c> teams) {
    for (Team__c team : teams) {
      if (team.ClientCertAgreementReceived__c != null && team.InitialCertificationDate__c == null) {
        team.InitialCertificationDate__c = team.ClientCertAgreementReceived__c;
      }
    }
  }

  // Set the client/facilitator relationship.
  // This is meant to be called from the team update trigger.
  public void setClientFacilitatorRelationShip(Team__c newTeam){
    if (newTeam.Facilitator__c == null)
      return;
    // nothing to do
    // See if there is an existing relationship between the client and facilitator
    List<npe4__Relationship__c> relationShips = relationshipRepo.getForPair(newTeam.Client__c, newTeam.Facilitator__c, 'Team Faciliator');

    // see if there is an existing relationship object to use
    for (npe4__Relationship__c relationShip : relationShips){
      if (relationShip.npe4__Status__c == 'Current'){
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

}