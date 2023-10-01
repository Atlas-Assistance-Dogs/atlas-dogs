public with sharing class PositionStatusController {
    @AuraEnabled(Cacheable=true)
    public static List<PositionStatus> getPositionStatusForContact(Id contactId) {
        List<string> fields = new List<String>();
        if (Schema.sObjectType.Contact.fields.Positions__c.isAccessible()) {
            fields.add('Positions__c');
        }
        if (Schema.sObjectType.Contact.fields.BoardMemberStatus__c.isAccessible()) {
            fields.add('BoardMemberStatus__c');
        }
        if (Schema.sObjectType.Contact.fields.ClientCertificationValidUntil__c.isAccessible()) {
            fields.add('ClientCertificationValidUntil__c');
        }
        if (Schema.sObjectType.Contact.fields.ClientStatus__c.isAccessible()) {
            fields.add('ClientStatus__c');
        }
        if (Schema.sObjectType.Contact.fields.FacilitatorCertAgreementReceived__c.isAccessible()) {
            fields.add('FacilitatorCertAgreementReceived__c');
        }
        if (Schema.sObjectType.Contact.fields.FacilitatorStatus__c.isAccessible()) {
            fields.add('FacilitatorStatus__c');
        }
        if (Schema.sObjectType.Contact.fields.PuppyRaiserStatus__c.isAccessible()) {
            fields.add('PuppyRaiserStatus__c');
        }
        if (Schema.sObjectType.Contact.fields.PuppyCertAgreementReceived__c.isAccessible()) {
            fields.add('PuppyCertAgreementReceived__c');
        }
        if (Schema.sObjectType.Contact.fields.TrainerCertAgreementReceived__c.isAccessible()) {
            fields.add('TrainerCertAgreementReceived__c');
        }
        if (Schema.sObjectType.Contact.fields.TrainerStatus__c.isAccessible()) {
            fields.add('TrainerStatus__c');
        }
        if (Schema.sObjectType.Contact.fields.GW_Volunteers__Volunteer_Status__c.isAccessible()) {
            fields.add('GW_Volunteers__Volunteer_Status__c');
        }
        Contact person = (Contact)Database.query(String.format('SELECT {0} FROM Contact WHERE Id = \'\'{1}\'\'', new List<Object> { String.join(fields, ','), contactId}));
        List<PositionStatus> statuses = getStatusForPositions(person);

        PositionStatus other = getOtherStatus(contactId);
        if (other != null) {
            statuses.add(other);
        }
        return statuses;
    }

    // We want the position status to be in this order, the Positions set for the contact
    // may not be in this order
    public final static String[] POSITION_LIST = new string[] {
        'Volunteer',
        'Team Facilitator',
        'Puppy Raiser',
        'Board',
        'Client',
        'Trainer',
        'Other'
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
                    if (positions.contains(position) && Schema.sObjectType.Contact.fields.GW_Volunteers__Volunteer_Status__c.isAccessible()) {
                        statuses.add(new PositionStatus(position, person.GW_Volunteers__Volunteer_Status__c));
                    }
                }

                when 'Team Facilitator' {
                    if ((positions.contains(position) ||
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
                    if (positions.contains(position) &&
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
                    if (positions.contains('Board Member') &&
                        Schema.sObjectType.Contact.fields.BoardMemberStatus__c.isAccessible()
                    ) {
                        statuses.add(new PositionStatus(position, person.BoardMemberStatus__c));
                    }
                }

                when 'Client' {
                    if (positions.contains(position) &&
                        Schema.sObjectType.Contact.fields.ClientStatus__c.isAccessible() &&
                        Schema.sObjectType.Contact.fields.ClientCertificationValidUntil__c.isAccessible()
                    ) {
                        string status = fineTuneStatus(
                            person.ClientStatus__c,
                            person.ClientCertificationValidUntil__c.addDays(-365)
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }

                when 'Trainer' {
                    if (positions.contains(position) &&
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
            }
        }
        return statuses;
    }

    private static string fineTuneStatus(string status, Date certDate) {
        Date today =  Date.today();
        if (
            status == 'Active' ||
            (status == 'Certified' && certDate != null)
        ) {
            if (certDate.addDays(365) < today) {
                status = 'Action Needed';
            } else if (certDate.addDays(270) < today) {
                status = 'Action Needed Soon';
            }
        }
        return status;
    }

    private static PositionStatus getOtherStatus(Id recordId) {
        List<ProgramAssignment__c> programAssignments = ProgramAssignmentController.getProgramAssignments(recordId);
        if (programAssignments == null)
            return null;
        PositionStatus otherPrograms = new PositionStatus();
        otherPrograms.position = 'Other';
        for (ProgramAssignment__c pa : programAssignments) {
            if (pa.Program__c != null && pa.Program__r.Standalone__c) {
                // we want to prioritize 'In Progress' as a status
                if (pa.Status__c == 'In Progress') {
                    otherPrograms.status = pa.Status__c;
                    break; // we don't care about any other programs
                } else {
                    otherPrograms.status = 'Decertifed/Suspended';
                }
            }
        }
        if (otherPrograms.status == null) {
            return null;
        }
        return otherPrograms;
    }

}
