trigger LeadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore){
        // All Before Logic
        LeadService.scoreLeads(Trigger.New);
    }else if(Trigger.isAfter){
        LeadService.routeLeads(Trigger.New);
        LeadService.updateLastAssignedDateOnUser(Trigger.New,Trigger.OldMap);
    }
}