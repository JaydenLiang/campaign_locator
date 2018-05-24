/**
 * Created by jaydenliang on 2018-05-19.
 */
({
    jsLoaded: function(component, event, helper) {
        console.log("quick filter bar is loaded.");
    },
    //built-in event implementation: after component been rendered
    onRender: function(component, helper){
        console.log("call onRender");
        //change style for the active button based on day range
        var day_range = component.get("v.day_range");
        var status = component.get("v.status");
        //update day range button style
        var element = component.find('btn-day-'+day_range);
        if(element) {
            $A.util.removeClass(element, 'btn-secondary');
            $A.util.addClass(element, 'btn-primary');
        }
        //update status button style
        var btn_class = '';
        if(status) {
            switch (status.key) {
                case "inprogress":
                    btn_class = 'warning';
                    break;
                case "planned":
                    btn_class = 'success';
                    break;
                default:
                    btn_class = 'info';
            }
            var element = component.find('btn-status-' + status.key);
            if (element) {
                $A.util.removeClass(element, 'btn-secondary');
                $A.util.addClass(element, 'btn-' + btn_class);
            }
        }
    },
    //event handler: when campaign list is updated
    onCampaignListLoaded: function (component, event){
        console.log("call onCampaignListLoaded");
        // var day_range = event.getParam("day_range");
        // component.set("v.day_range", day_range);
    },
    //attribute value-change handler:
    //on attribute: status
    onStatusChanged: function (component, event, helper){
        console.log("call onStatusChanged");
        var status = event.getParam("oldValue");
        if(!status) return;
        var btn_class = '';
        //de-activate button with old value
        var id_string = 'btn-status-'+status.key;

        switch (status.key){
            case "inprogress":
                btn_class = 'warning';
                break;
            case "planned":
                btn_class = 'success';
                break;
            default:
                btn_class = 'info';
        }
        var element = component.find(id_string);
        if(element) {
            $A.util.removeClass(element, 'btn-' + btn_class);
            $A.util.addClass(element, 'btn-secondary');
        }
    },
    //attribute value-change handler:
    //on attribute: day range
    onDayRangeChanged: function (component, event, helper){
        console.log("call onDayRangeChanged");
        var day_range = event.getParam("oldValue");
        //de-activate button with old value
        var id_string = 'btn-day-'+day_range;
        var element = component.find(id_string);
        if(element) {
            $A.util.removeClass(element, 'btn-primary');
            $A.util.addClass(element, 'btn-secondary');
        }
    },
    //fire a lightning component event: to reload the campaign list
    reloadList: function(component, event, helper){
        var day_range = event.currentTarget.dataset.dayrange;
        var status_key = event.currentTarget.dataset.statkey;
        var status_val = event.currentTarget.dataset.statval;
        var status = {};
        if(day_range) {
            component.set("v.day_range", day_range);
        }
        if(status_key && status_val) {
            status = {key:status_key, val:status_val};
            component.set("v.status", status);
        }
        var event = $A.get("e.c:EventCampaignLocatorReloadList");
        event.setParams({day_range: component.get("v.day_range"), status: component.get("v.status")});
        event.fire();
    }
})