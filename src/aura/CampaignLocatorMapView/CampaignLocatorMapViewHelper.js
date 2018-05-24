/**
 * Created by jaydenliang on 2018-05-19.
 */
({
    //handler: navigate to a campaign by id
    navigateToCampaignView : function(campaignId) {
        //fire a visualforce page event for navigating
        var event = $A.get("e.force:navigateToSObject");
        if(event){
            event.setParams({
                "recordId": campaignId
            });
            event.fire();
        }
    }
})