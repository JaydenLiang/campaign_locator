/**
 * Created by jaydenliang on 2018-05-19.
 */
({
    //event handler: when a particular script source file is loaded.
    jsLoaded: function(component, event, helper) {
        console.log("call jsLoaded");
        var map = L.map('map',
            {
                // zoomControl: false,
                zoomControl: true,
                zoom:1,
                // zoomAnimation:false,
                // fadeAnimation:true,
                // markerZoomAnimation:true,
                tap: false
            })
            .setView([20.4507534, -159.7497679], 14);
        L.tileLayer(
            'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
            {
                attribution: 'Tiles © Esri'
            }).addTo(map);
        //set a marker group to container all markers
        var marker_group = L.layerGroup();
        //TODO: to better handle markers when zooming
        /*
        map.on("zoomstart", function (e) {
            console.log("zoomstart");
        });
        map.on("zoomend", function (e) {
            console.log("zoomend");
        });
        */

        map.addLayer( marker_group );
        //store objects to component for later uses
        component.set("v.map", map);
        component.set("v.marker_group", marker_group);
    },
    //event handler: campaign list been updated.
    onCampaignListLoaded: function(component, event, helper){
        // Add markers
        var map = component.get('v.map');
        var marker_group = component.get('v.marker_group');
        var campaigns = event.getParam('campaigns');
        var firstGeoLoc;//setup a center point to pan the map
        //giving different colors to map items with different statuses
        function getCampaignClassByStatus(status){
            var class_string = "";
            switch (status.toString().toLowerCase()){
                case "in progress":
                    class_string = "in-progress";
                    break;
                case "planned":
                    class_string = "planned";
                    break;
                case "aborted":
                    class_string = "aborted";
                    break;
                case "completed":
                    class_string = "completed";
                    break;
                default:
                    class_string = "default";
            }
            return class_string;
        }
        if(marker_group) {
            //clear all existing markers before redrawing campaign markers on the map
            marker_group.clearLayers();
            //redraw campaign markers on the map
            for (var i = 0; i < campaigns.length; i++) {
                var campaign = campaigns[i];
                //store the first campaign geolocations as the center point
                var latLng = [campaign.Geolocation__Latitude__s, campaign.Geolocation__Longitude__s];
                if (latLng[0] !== undefined && latLng[0] !== null && latLng[1] !== undefined && latLng[1] !== null) {
                    if (i == 0) {
                        firstGeoLoc = [latLng[0], latLng[1]];
                    }
                    //place the marker, bind a tooltip
                    L.marker(latLng, {campaign: campaign})
                        .bindTooltip("<span class='marker-tooltip status-" + getCampaignClassByStatus(campaign.Status)
                            + "'><b>" + campaign.Status + "</b></span><br/>Start:" + campaign.StartDate + "<br/>End:" + campaign.EndDate,
                            {
                                permanent: true,
                                direction: 'top'
                            })
                        .addTo(marker_group)
                        //bind a click event handler to navigate to the campaign view
                        .on('click', function (event) {
                            helper.navigateToCampaignView(event.target.options.campaign.Id);
                        });
                }
            }
            ;
        }
        //pan the map to the first campaign on list
        if(firstGeoLoc != undefined) map.panTo(firstGeoLoc);
    },
    //event handler: when a campaign list item is selected
    onCampaignListItemSelected: function(component, event, helper){
        var map = component.get('v.map');
        var campaign = event.getParam('campaign');
        //if campaign is available
        if(campaign !== null){
            //if map available,  campaign has geolocation, zoom to the marker
            if(map !== undefined && campaign.Geolocation__Latitude__s !== undefined && campaign.Geolocation__Longitude__s !== undefined){
                map.panTo([campaign.Geolocation__Latitude__s, campaign.Geolocation__Longitude__s]);
            }
            //if camapaign not has geolocation, navigate to campaign view
            else{
                helper.navigateToCampaignView(campaign.Id);
            }
        }
    }
})