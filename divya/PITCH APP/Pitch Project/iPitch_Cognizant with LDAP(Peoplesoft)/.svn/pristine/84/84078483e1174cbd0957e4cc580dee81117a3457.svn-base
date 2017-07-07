//
//  LeadsListViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 2/4/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "LeadsListViewController.h"

#import "ModelTrackingClass.h"

#import "AppDelegate.h"

#import "LoginViewController.h"

#import "Customers.h"

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface LeadsListViewController ()

@end

@implementation LeadsListViewController

@synthesize tableSource=_tableSource;
@synthesize filteredArray=_filteredArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    self.tableSource=[[NSMutableArray alloc]initWithArray:fetchedObjects];
    
    NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"FirstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    /*self.tableSource=[[NSMutableArray alloc]initWithArray:[[ModelTrackingClass sharedInstance]  getModelObjectForKey:@"MasterUsersArray"]];
    NSSortDescriptor *alphaDesc = [[NSSortDescriptor alloc] initWithKey:@"userName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];*/
     
    [self.tableSource sortUsingDescriptors:[NSArray arrayWithObject:alphaDesc]];
    alphaDesc = nil;
    self.title=@"Select Recipients";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem=doneButton;

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)pop
{
    [SAppDelegateObject.viewController.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        
    {    return [self.filteredArray count];
    }
    
    else{
        return [self.tableSource count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", ((Customers *) [self.filteredArray objectAtIndex:indexPath.row]).firstName,((Customers *) [self.filteredArray objectAtIndex:indexPath.row]).lastName]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@,%@", ((Customers *) [self.filteredArray objectAtIndex:indexPath.row]).mailingCity,((Customers *) [self.filteredArray objectAtIndex:indexPath.row]).mailingStreet]];
       
        if (indexPath.row %2 == 0)
            cell.imageView.image=[UIImage imageNamed:@"user_icon_3.png"];
        else
            cell.imageView.image=[UIImage imageNamed:@"user_icon_4.png"];
    }
    
    else{
    
        [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", ((Customers *) [self.tableSource objectAtIndex:indexPath.row]).firstName,((Customers *) [self.tableSource objectAtIndex:indexPath.row]).lastName]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@,%@", ((Customers *) [self.tableSource objectAtIndex:indexPath.row]).mailingCity,((Customers *) [self.tableSource objectAtIndex:indexPath.row]).mailingStreet]];
        
        if (indexPath.row %2 == 0)
            cell.imageView.image=[UIImage imageNamed:@"user_icon_3.png"];
        else
            cell.imageView.image=[UIImage imageNamed:@"user_icon_4.png"];

    }

          
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView cellForRowAtIndexPath:indexPath].accessoryType=UITableViewCellAccessoryCheckmark;
    
    
    NSManagedObjectID *customerID=((Customers *)[self.tableSource objectAtIndex:indexPath.row]).objectID ;
     [[NSNotificationCenter defaultCenter ]postNotificationName:@"RecipientsAddedToEvent" object: customerID];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredArray removeAllObjects];
        
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[self.tableSource count]; i++) {

   
            if ([self string:((Customers *) [self.tableSource objectAtIndex:i]).firstName containsString:searchText] || [self string:((Customers *) [self.tableSource objectAtIndex:i]).lastName containsString:searchText] ) {
                [tempArray addObject:((Customers *) [self.tableSource objectAtIndex:i])];
            }
    }
    
    self.filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    
}

- (BOOL) string :(NSString *)string containsString: (NSString*) substring
{
    NSRange range = [ [string lowercaseString]  rangeOfString : [substring lowercaseString]];
    BOOL found = ( range.location != NSNotFound );
    return found;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

@end
