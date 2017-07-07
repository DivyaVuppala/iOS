//
//  AccountListTableViewController.m
//  Pitch
//
//  Created by Divya Vuppala on 03/04/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "AccountListTableViewController_iPhone.h"
#import "AccountListCell_iPhone.h"
#import "AddOpportunityViewController_iPhone.h"
#import "iPitchConstants.h"

@interface AccountListTableViewController_iPhone ()

@end

@implementation AccountListTableViewController_iPhone

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationItem.title=@"Accounts";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
     accountArray=SAppDelegateObject.acntArray;
    
    UINib *nib=[UINib nibWithNibName:@"AccountListCell_iPhone" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"AccountsCell"];
    
   // NSLog(@"%@",accountArray.description);
 
    

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
    return accountArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
   AccountListCell_iPhone *cell=[tableView dequeueReusableCellWithIdentifier:@"AccountsCell" forIndexPath:indexPath];
    
    SearchAccounts *accountObj=[accountArray objectAtIndex:indexPath.row];
     cell.textLabel.text=accountObj.companyName;
     cell.detailTextLabel.text=accountObj.companyID;
    
    
    
    // Configure the cell...
    
    return cell;
}

#pragma mark -toBeRemoved

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    AddOpportunityViewController *aovc=[[AddOpportunityViewController alloc]initWithNibName:@"AddOpportunityViewController" bundle:nil];
//    [self.navigationController pushViewController:aovc animated:YES];
//    
    DetailAccountViewController_iPhone * accountView=[[DetailAccountViewController_iPhone alloc]init];
    accountView.receivedAccountID=[self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
    accountView.receivedAccountName=[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:accountView animated:YES];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
