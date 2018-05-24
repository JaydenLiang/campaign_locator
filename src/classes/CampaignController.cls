//TODO:
//Enforcing CRUD and FLS (see: https://developer.salesforce.com/page/Enforcing_CRUD_and_FLS)
/**
 * CampaignController
 */
public class CampaignController {
    /**
     * find all campaigns currently open, or will open in day_range, or will end in day_range
     * with/without a specified status
     *
     * @param status
     *
     * @return
     */
    @AuraEnabled
    public static List<Campaign> findAllAvailable(Integer day_range, String status) {
        String status_clause = '';
        if(status != null && status.equalsIgnoreCase('In Progress')){
            status_clause = 'Status = \'In Progress\' AND ';
        }
        else if(status != null && status.equalsIgnoreCase('Planned')){
            status_clause = 'Status = \'Planned\' AND ';
        }
        //TODO: could add support to more status, default to one status
        else{
            status_clause = 'Status != null AND ';
        }
        String query_string = 'SELECT id, Name, GeoLocation__Longitude__s, GeoLocation__Latitude__s, status, startDate, endDate'
                + ' FROM Campaign'
                + ' WHERE ' + status_clause
                + ' (StartDate = TODAY OR StartDate IN (NEXT_N_DAYS:' + day_range + ')'
                + ' OR EndDate = TODAY OR EndDate IN (NEXT_N_DAYS:' + day_range + ')) ORDER BY StartDate ASC';
        return Database.query(query_string);
    }
}