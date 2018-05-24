/**
 * Created by jaydenliang on 2018-05-19.
 */
({
    //even trigger: fire an event for campaign list item selected
    onCampaignListItemSelected : function(component) {
        var event = $A.get("e.c:EventCampaignLocatorListItemSelected");
        event.setParams({"campaign": component.get("v.campaign")});
        event.fire();
    }
})