public with sharing class PositionStatusController {
    @AuraEnabled(Cacheable=true)
    public static List<PositionStatus> getPositionStatusForContact(
        Id contactId
    ) {
        Contact person = [
            SELECT
                Positions__c,
                BoardMemberStatus__c,
                ClientStatus__c,
                ClientCertificationValidUntil__c,
                FacilitatorStatus__c,
                FacilitatorCertificationValidUntil__c,
                PuppyRaiserStatus__c,
                PuppyCertAgreementReceived__c,
                StandaloneStatus__c,
                TrainerStatus__c,
                TrainerCertificationValidUntil__c,
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
        if (string.isBlank(person.Positions__c)) {
            return statuses;
        }
        Set<String> positions = new Set<string>(person.Positions__c.split(';'));
        for (string position : POSITION_LIST) {
            switch on (position) {
                when 'Volunteer' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.IsVolunteer__c.isAccessible()
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
                        Schema.sObjectType.Contact.fields.FacilitatorCertificationValidUntil__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.FacilitatorStatus__c,
                            person.FacilitatorCertificationValidUntil__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Puppy Raiser' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.PuppyCertAgreementReceived__c.isAccessible()
                    ) {
                        Date validUntil = null;
                        if (person.PuppyCertAgreementReceived__c != null) {
                            validUntil = person.PuppyCertAgreementReceived__c.addMonths(
                                12
                            );
                        }
                        string status = fineTuneStatus(
                            person.PuppyRaiserStatus__c,
                            validUntil
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
                        string status = fineTuneStatus(
                            person.ClientStatus__c,
                            person.ClientCertificationValidUntil__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }
                when 'Trainer' {
                    if (
                        positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.TrainerStatus__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.TrainerCertificationValidUntil__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.TrainerStatus__c,
                            person.TrainerCertificationValidUntil__c
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

    // Determine when action is needed based on cert valid until date
    private static string fineTuneStatus(string status, Date certDate) {
        Date today = Date.today();
        if ((status.contains('Active') || status.contains('Certified')) && certDate != null) {
            if (certDate < today) {
                status = 'Action Needed';
            } else if (certDate.addDays(-90) < today) {
                status = 'Action Needed Soon';
            }
        }
        return status;
    }
}
