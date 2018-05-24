/**
 * Created by jaydenliang on 2018-05-19.
 */
({
    //Initialization
    doInit : function(component, event) {
        var day_range = 7;
        var action = component.get("c.findAllAvailable");
        action.setParams({day_range: day_range, status: "all"});
        action.setCallback(this, function(reaction) {
            component.set("v.campaigns", reaction.getReturnValue());
            window.setTimeout($A.getCallback(function() {
                var event = $A.get("e.c:EventCampaignLocatorListLoaded");
                event.setParams({
                    "campaigns": reaction.getReturnValue(),
                    "day_range": day_range
                });
                event.fire();
            }), 500);
        });
        $A.enqueueAction(action);
    },
    //Action to reload of the campaign list
    onReloadCampaignList : function (component, event) {
        console.log("call onReloadCampaignList");
        //parameters to filter campaigns (which will be passed to backend
        var day_range = event.getParam("day_range");
        var status = event.getParam("status");
        //get a method reference to backend controller: CampaignController.findAllAvailable
        var action = component.get("c.findAllAvailable");

        action.setParams({day_range:day_range, status:status.val});
        //set a callback to fire a lightning component event
        action.setCallback(this, function(reaction) {
            component.set("v.campaigns", reaction.getReturnValue());
            window.setTimeout($A.getCallback(function() {
                var event = $A.get("e.c:EventCampaignLocatorListLoaded");
                event.setParams({
                    "campaigns": reaction.getReturnValue(),
                    "day_range": day_range
                });
                event.fire();
            }), 500);
        });
        //take action
        $A.enqueueAction(action);
    }
})