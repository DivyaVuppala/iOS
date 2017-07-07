//
//  OpportunityListViewController.m
//  Pitch
//
//  Created by Divya Vuppala on 08/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "OpportunityListViewController_iPhone.h"
#import "OpportunityListTableViewCell_iPhone.h"


@interface OpportunityListViewController_iPhone ()

@end

@implementation OpportunityListViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title=@"Opportunities";
    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(MoveToAddOpportunity)];
    self.navigationItem.rightBarButtonItem=rightBarButton;
    
    opportunitiesArray= SAppDelegateObject.opportArray;

    UINib *nib=[UINib nibWithNibName:@"OpportunityListTableViewCell_iPhone" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"OpportunityCell"];


}

-(void)MoveToAddOpportunity
{
    AddMyOpportunityViewController_iPhone *amovc=[[AddMyOpportunityViewController_iPhone alloc]init];
    [self.navigationController pushViewController:amovc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return opportunitiesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OpportunityListTableViewCell_iPhone *cell = [tableView dequeueReusableCellWithIdentifier:@"OpportunityCell" forIndexPath:indexPath];
    
    // Configure the cell...
    Opportunity *opportunityObject=opportunitiesArray[indexPath.row];
    cell.customerNameLabel.text=opportunityObject.CustomerName;
    cell.opportunityNameLabel.text=opportunityObject.OpportunityName;
    cell.opportunityIDLabel.text=opportunityObject.OpportunityId;
    cell.TCVLabel.text=opportunityObject.TCV;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
