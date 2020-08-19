public without sharing class LeadService {

    /**
     * Round robin routes the leads to users that have Available for Leads set to true on their User
     *
     * @param leadsToRoute the leads that should be assigned to the users
     */
    public static void routeLeads(List<Lead> leads){
        List<User> activeSalesPeople = [SELECT Id, Last_Lead_Assigned__c
            FROM User
            WHERE Available_For_Leads__c = TRUE
            ORDER BY Last_Lead_Assigned__c ASC NULLS FIRST];
        if(activeSalesPeople.size() < 1){
            return;
        }

        List<Lead> leadsToRoute = new List<Lead>();
        for(Lead l : leads){
            if(String.valueOf(l.OwnerId).startsWith('00G')){
                leadsToRoute.add(l);
            }
        }

        for(Integer i=0;i<leadsToRoute.size();i++){
            Lead lead = leadsToRoute[i];
            Integer salesPersonIndex = Math.mod(i,activeSalesPeople.size());
            lead.OwnerId = activeSalesPeople[salesPersonIndex].Id;
        }

        Database.DMLOptions dmlOptions = new Database.DMLOptions();
        dmlOptions.emailHeader.triggerUserEmail = true;
        Database.update(leadsToRoute,dmlOptions);
    }

    /**
     * Updates the Last Assigned Date to today on the User records based on the Lead Owners in the leads list provided
     *
     * @param leads - leads that have just been assigned to users
     */
    public static void updateLastAssignedDateOnUser(List<Lead> leads, Map<Id,Lead> oldLeads){
        List<User> usersToUpdate = new List<User>();
        for(Lead l : leads){
            if(String.valueOf(l.OwnerId).startsWith('005')
                    && (oldLeads == null || oldLeads.get(l.Id).OwnerId != l.OwnerId)
                    ){
                usersToUpdate.add(new User(Id = l.OwnerId,Last_Lead_Assigned__c = datetime.now()));
            }
        }
        update usersToUpdate;
    }

    // Lead scoring constants - set by the sales team
    private static final Map<String,Integer> LEAD_SOURCE_SCORES = new Map<String,Integer>{
        'Web' => 50,
        'Phone Inquiry' => 75,
        'Partner Referral' => 80,
        'Purchased List' => 10,
        'Other' => 0
    };
    private static final Integer HAVE_PHONE = 20; // If we have the phone number, the score goes up this many
    private static final Integer HAVE_EMAIL = 10; // If we have the email address, the score goes up this many

    /**
     * Score the Leads based on their lead source and the fields we have
     *
     * @param leads
     */
    public static void scoreLeads(List<Lead> leads){
        for(Lead l:leads){
            Integer score = 0;
            if(l.LeadSource != null && LEAD_SOURCE_SCORES.containsKey(l.LeadSource)){
                score += LEAD_SOURCE_SCORES.get(l.LeadSource);
            }
            if(l.Email != null) score += HAVE_EMAIL;
            if(l.Phone != null) score += HAVE_PHONE;
            l.Lead_Score__c = score;
        }
    }
}