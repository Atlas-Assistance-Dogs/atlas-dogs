public with sharing class PositionStatusController {
    @AuraEnabled(Cacheable=true)
    public static List<PositionStatus> getPositionStatusForContact(
        Id contactId
    ) {
        System.debug(contactId);
        Contact person = [
            SELECT
                Positions__c,
                BoardMemberStatus__c,
                ClientCertificationValidUntil__c,
                ClientStatus__c,
                FacilitatorCertAgreementReceived__c,
                FacilitatorStatus__c,
                PuppyRaiserStatus__c,
                PuppyCertAgreementReceived__c,
                StandaloneStatus__c,
                TrainerCertAgreementReceived__c,
                TrainerStatus__c,
                GW_Volunteers__Volunteer_Status__c
            FROM Contact
            WHERE Id = :contactId
        ];
        List<PositionStatus> statuses = getStatusForPositions(person);
        return statuses;
    }

    // We want the position status to be in this order, the Positions set for the contact
    // may not be in this order
    public final static String[] POSITION_LIST = new List<string>{
        'Volunteer',
        'Team Facilitator',
        'Puppy Raiser',
        'Board',
        'Client',
        'Trainer',
        'Standalone'
    };

    private static List<PositionStatus> getStatusForPositions(Contact person) {
        List<PositionStatus> statuses = new List<PositionStatus>();
        if (person.Positions__c == null) {
            return statuses;
        }
        Set<String> positions = new Set<string>(person.Positions__c.split(';'));
        for (string position : POSITION_LIST) {
            switch on (position) {
                when 'Volunteer' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.GW_Volunteers__Volunteer_Status__c.isAccessible()
                    ) {
                        statuses.add(
                            new PositionStatus(
                                position,
                                person.GW_Volunteers__Volunteer_Status__c
                            )
                        );
                    }
                }
                when 'Team Facilitator' {
                    if (
                        (positions.contains(position) ||
                        positions.contains('Team Facilitator Lead')) &&
                        Schema.sObjectType.Contact.fields.FacilitatorStatus__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.FacilitatorCertAgreementReceived__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.FacilitatorStatus__c,
                            person.FacilitatorCertAgreementReceived__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Puppy Raiser' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.BoardMemberStatus__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.PuppyRaiserStatus__c,
                            person.PuppyCertAgreementReceived__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Board' {
                    if (
                        positions.contains('Board Member') &&
                        Schema.sObjectType.Contact.fields.BoardMemberStatus__c.isAccessible()
                    ) {
                        statuses.add(
                            new PositionStatus(
                                position,
                                person.BoardMemberStatus__c
                            )
                        );
                    }
                }
                when 'Client' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.ClientStatus__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.ClientCertificationValidUntil__c.isAccessible()
                    ) {
                        Date certDate = null;
                        if (person.ClientCertificationValidUntil__c != null) {
                            certDate = person.ClientCertificationValidUntil__c.addDays(
                                -365
                            );
                        }
                        string status = fineTuneStatus(
                            person.ClientStatus__c,
                            certDate
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Trainer' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.TrainerStatus__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.TrainerCertAgreementReceived__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.TrainerStatus__c,
                            person.TrainerCertAgreementReceived__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Standalone' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.StandaloneStatus__c.isAccessible()
                    ) {
                        statuses.add(
                            new PositionStatus(
                                position,
                                person.StandaloneStatus__c
                            )
                        );
                    }
                }
            }
        }
        return statuses;
    }

    private static string fineTuneStatus(string status, Date certDate) {
        Date today = Date.today();
        if (status == 'Active' || (status == 'Certified' && certDate != null)) {
            if (certDate.addDays(365) < today) {
                status = 'Action Needed';
            } else if (certDate.addDays(270) < today) {
                status = 'Action Needed Soon';
            }
        }
        return status;
    }
}
