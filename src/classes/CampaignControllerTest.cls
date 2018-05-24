/**
 * CampaignControllerTest
 */
@isTest
public class CampaignControllerTest {
    private void insertTestData() {

    }
    
    @isTest static void test_findAllAvailable(){
        List<Campaign> result;
        Exception ex = null;
        //smoke test
        try{
            result = CampaignController.findAllAvailable(1, 'Planned');
        }
        catch(QueryException e){
            ex = e;
        }
        finally {
            System.assert(ex == null, 'exception caught in smoke test');
        }

        //failure test
        //expect to catch an exception for negative number input
        ex = null;
        try{
            result = CampaignController.findAllAvailable(-1, '');
        }
        catch(QueryException e){
            ex = e;
        }
        finally {
            System.assert(ex != null && (ex instanceof QueryException), 'exception for negative number not caught in failure test');
        }

        Date today = System.today();
        Boolean has1, has2, has3, has4, has5, has6, has7, has8, has9, has10;

        //test data

        //#1: start date < today, end date < today, status null
        Campaign testCampaign1 = new Campaign();
        testCampaign1.Name = 'Test Campaign 1';
        testCampaign1.StartDate = today.addDays(-10); // 10 days before today
        testCampaign1.EndDate = today.addDays(-5); // 5 days before today
        insert testCampaign1;

        //#2: start date < today, end date > today, status 'in progress'
        Campaign testCampaign2 = new Campaign();
        testCampaign2.Name = 'Test Campaign 2';
        testCampaign2.StartDate = today.addDays(-10); // 10 days before today
        testCampaign2.EndDate = today.addDays(+5); // 5 days after today
        testCampaign2.Status = 'In Progress';
        insert testCampaign2;

        //#3: start date = today, end date > today, status 'in progress'
        Campaign testCampaign3 = new Campaign();
        testCampaign3.Name = 'Test Campaign 3';
        testCampaign3.StartDate = today; // today
        testCampaign3.EndDate = today.addDays(+5); // 5 days after today
        testCampaign3.Status = 'In Progress';
        insert testCampaign3;

        //#4: start date = today, end date = today, status 'in progress'
        Campaign testCampaign4 = new Campaign();
        testCampaign4.Name = 'Test Campaign 4';
        testCampaign4.StartDate = today; // today
        testCampaign4.EndDate = today; // today
        testCampaign4.Status = 'In Progress';
        insert testCampaign4;

        //#5: start date > today, end date > today, status 'in progress'
        Campaign testCampaign5 = new Campaign();
        testCampaign5.Name = 'Test Campaign 5';
        testCampaign5.StartDate = today.addDays(+5); // 5 days after today
        testCampaign5.EndDate = today.addDays(+10); // 10 days after today
        testCampaign5.Status = 'In Progress';
        insert testCampaign5;

        //#6: start date > today, end date > today, status 'Planned'
        Campaign testCampaign6 = new Campaign();
        testCampaign6.Name = 'Test Campaign 6';
        testCampaign6.StartDate = today.addDays(+5); // 5 days after today
        testCampaign6.EndDate = today.addDays(+10); // 10 days after today
        testCampaign6.Status = 'Planned';
        insert testCampaign6;

        //#7: start date = today + 1, end date > today, status 'Planned'
        Campaign testCampaign7 = new Campaign();
        testCampaign7.Name = 'Test Campaign 7';
        testCampaign7.StartDate = today.addDays(+1); // 1 days after today
        testCampaign7.EndDate = today.addDays(+60); // 60 days after today
        testCampaign7.Status = 'Planned';
        insert testCampaign7;

        //#8: start date = today + 10, end date = today + 60, status 'Planned'
        Campaign testCampaign8 = new Campaign();
        testCampaign8.Name = 'Test Campaign 8';
        testCampaign8.StartDate = today.addDays(+10); // 10 days after today
        testCampaign8.EndDate = today.addDays(+60); // 60 days after today
        testCampaign8.Status = 'Planned';
        insert testCampaign8;

        //#9: start date < today, end date = today, status 'in progress'
        Campaign testCampaign9 = new Campaign();
        testCampaign9.Name = 'Test Campaign 9';
        testCampaign9.StartDate = today.addDays(-10); // 10 days before today
        testCampaign9.EndDate = today; // today
        testCampaign9.Status = 'In Progress';
        insert testCampaign9;

        //#10: start date < today, end date < today, status 'in progress'
        Campaign testCampaign10 = new Campaign();
        testCampaign10.Name = 'Test Campaign 10';
        testCampaign10.StartDate = today.addDays(-60); // 60 days before today
        testCampaign10.EndDate = today.addDays(-10); // 10 days before today
        testCampaign10.Status = 'In Progress';
        insert testCampaign10;

        //test find day range: 0 (start today or end today, not specified status
        result = CampaignController.findAllAvailable(0, '');
        //expect to have records
        //expect to contain: #3, #4, #9
        //expect to not contain: #1, #2, #5, #8
        System.assert(result.size() > 0, 'should contain at least 1 record');

        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9  = has10 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign1.Name)){
                has1 = true;
            }
            else if(item.Name.equals(testCampaign2.Name)){
                has2 = true;
            }
            else if(item.Name.equals(testCampaign3.Name)){
                has3 = true;
            }
            else if(item.Name.equals(testCampaign4.Name)){
                has4 = true;
            }
            else if(item.Name.equals(testCampaign5.Name)){
                has5 = true;
            }
            else if(item.Name.equals(testCampaign8.Name)){
                has8 = true;
            }
            else if(item.Name.equals(testCampaign9.Name)){
                has9 = true;
            }
        }
        System.assert(has3 && has4 && has9, 'failed for [day range: 0, any status] [case 3('+has3+') ,4('+has4+'), 9('+has9+')]');
        System.assert(!(has1 || has2 || has5 || has8), 'failed for [day range: 0, not specified] [case 1('+has1+'), 2('+has2+'), 5('+has5+'), 8('+has8+')]');

        //normal cases day range: 1, any status
        result = CampaignController.findAllAvailable(1, '');
        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9  = has10 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign7.Name)){
                has7 = true;
            }
        }
        System.assert(has7, 'failed for [day range: 1, in progress] [case 7 ('+has7+')]');

        //normal cases day range: 1, any status
        result = CampaignController.findAllAvailable(1, '');
        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9  = has10 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign7.Name)){
                has7 = true;
            }
        }
        System.assert(has7, 'failed for [day range: 1, in progress] [case 7 ('+has7+')]');

        //normal cases day range: 10, status Planned
        result = CampaignController.findAllAvailable(10, 'Planned');
        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9  = has10 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign8.Name)){
                has8 = true;
            }
        }
        System.assert(has8, 'failed for [day range: 10, planned] [case 8 ('+has8+')]');

        //normal case day range 365, status 'In Progress'
        //expect to have #5, #9
        //expect to not have #10
        result = CampaignController.findAllAvailable(365, 'In Progress');
        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9  = has10 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign5.Name)){
                has5 = true;
            }
            else if(item.Name.equals(testCampaign9.Name)){
                has9 = true;
            }
            else if(item.Name.equals(testCampaign10.Name)){
                has10 = true;
            }
        }
        System.assert(has5 && has9 && !has10, 'failed for [day range: 365, in progress] [case 5 ('+has5+'), case 9 ('+has9+'), case 10 ('+has10+')]');

        //special cases day range: 5, any status
        //expect to have #6
        //expect to not have #8
        result = CampaignController.findAllAvailable(5, '');
        has1 = has2 = has3 = has4 = has5 = has6 = has7 = has8 = has9 = false;
        for(Campaign item : result){
            if(item.Name.equals(testCampaign6.Name)){
                has6 = true;
            }
            else if(item.Name.equals(testCampaign8.Name)){
                has8 = true;
            }
        }
        System.assert(has6, 'failed for [day range: 5, any status] [case 6('+has6+')]');
        System.assert(!has8, 'failed for [day range: 5, any status] [case 8('+has8+')]');
    }
}