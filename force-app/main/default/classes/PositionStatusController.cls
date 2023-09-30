public with sharing class PositionStatusController {
    @AuraEnabled(Cacheable=true)
    public static List<PositionStatus> getPositionStatusForContact(Id contactId) {
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
                TrainerCertAgreementReceived__c,
                TrainerStatus__c,
                GW_Volunteers__Volunteer_Status__c
            FROM Contact
            WHERE Id = :contactId
        ];
        List<PositionStatus> statuses = getStatusForPositions(person);

        PositionStatus other = getOtherStatus(contactId);
        if (other != null) {
            statuses.add(other);
        }
        return statuses;
    }

    // We want the position status to be in this order, the Positions set for the contact
    // may not be in this order
    private String[] POSITIONS = new string[] {
        'Volunteer',
        'Team Facilitator',
        'Puppy Raiser',
        'Board',
        'Client',
        'Trainer',
        'Other Programs'
    };

    private static List<PositionStatus> getStatusForPositions(Contact person) {
        Set<String> positions = new Set<string>(person.Positions__c.split(';'));
        List<PositionStatus> statuses = new List<PositionStatus>();
        for (string position : POSITIONS) {
            switch on (position) {
                when 'Volunteer' {
                    if (positions.contains(position))
                        statuses.add(new PositionStatus(position, person.GW_Volunteers__Volunteer_Status__c));
                }

                when 'Team Facilitator' {
                    if (
                        positions.contains(position) ||
                        positions.contains('Team Facilitator Lead')
                    ) {
                        string status = fineTuneStatus(
                            person.FacilitatorStatus__c,
                            person.FacilitatorCertAgreementReceived__c
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }

                when 'Puppy Raiser' {
                    if (positions.contains(position)) {
                        string status = fineTuneStatus(
                            person.PuppyRaiserStatus__c,
                            person.PuppyCertAgreementReceived__c
                            );
                        statuses.add(new PositionStatus(position, status));
                    }
                }

                when 'Board' {
                    if (positions.contains('Board Member'))
                        statuses.add(new PositionStatus(position, person.BoardMemberStatus__c));
                }

                when 'Client' {
                    if (positions.contains(position)) {
                        string status = fineTuneStatus(
                            person.ClientStatus__c,
                            person.ClientCertificationValidUntil__c.addDays(-365)
                        );
                        statuses.add(new PositionStatus(position, status));
                    }
                }

                when 'Trainer' {
                    if (positions.contains(position)) {
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
