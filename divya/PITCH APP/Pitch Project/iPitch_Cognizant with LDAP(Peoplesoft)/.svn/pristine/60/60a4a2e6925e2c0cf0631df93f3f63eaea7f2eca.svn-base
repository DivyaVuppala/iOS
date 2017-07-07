//
//  CustomerViewController.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "CustomerViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShowCustomerDetails.h"
#import "AppDelegate.h"
#import "ModelTrackingClass.h"
#import "SWRevealViewController.h"
#import "QuartzCore/CALayer.h"
#import "Customers.h"
#import "iPitchAnalytics.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "ZohoHelper.h"
#import "Lead.h"
#import "AsyncImageView.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"
#import "AddEditCustomerViewController.h"

@interface CustomerViewController ()<AddEditCustomerStatusDelegate>
@end

@implementation CustomerViewController
@synthesize customerScrollView, customersearch, filteredArray, buttonToggle, UserIcon, NotificationIcon, Searchbtn, horizontalLine;
@synthesize titleLabel;

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.toolBarView bringSubviewToFront:Searchbtn];
    self.titleLabel.text= NSLocalizedString(@"MY_CUSTOMERS", @"My Customers");
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    SearchcustomerDetails = [[NSMutableArray alloc] init];
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
         buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
         buttonToggle.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_list_view.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
    }
    
    
     customersArray = [[NSMutableArray alloc]init];
    
    // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    // Do any additional setup after loading the view from its nib.
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
}



- (void) viewWillAppear:(BOOL)animated{
    [self refreshCustomerDataFromCoreDataStore];
    [self loadCustomersGridView];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Customers"];
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    [self.customerScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [ThemeHelper applyCurrentThemeToView];

}

- (void)viewDidUnload
{
    [self setTitleLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (IBAction)toggleButtonClicked:(id)sender{
    
}


- (IBAction)searchButtonClicked:(id)sender{
    [customersearch resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"SEARCHING", @"Searching...");
    [self performSelectorInBackground:@selector(FetchFromZoho) withObject:nil];
    
    
}


- (void)FetchFromZoho{
    
    [SearchcustomerDetails removeAllObjects];
    [[ModelTrackingClass sharedInstance] setModelObject:customersearch.text forKey:@"searchText"];
    
    NSLog(@"model:%@",customersearch.text );
    ZohoHelper * abc = [[ ZohoHelper alloc] init];
    [abc SearchContactsFromZoho];
    [SearchcustomerDetails addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"searchContactArray"]];
    
    
    [self performSelectorOnMainThread:@selector(updateAfterSearchCall) withObject:nil waitUntilDone:YES];
}

- (void)updateAfterSearchCall
{
    [HUD hide:YES];
   
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    
    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];
    
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SearchPopoverController presentPopoverFromRect:customersearch.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    CustomerSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    CustomerSearchtable.dataSource=self;
    CustomerSearchtable.delegate=self;
    [popoverContent.view addSubview:CustomerSearchtable];
    

}

-(void)refreshCustomerDataFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [customersArray removeAllObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                                   ascending:YES selector:@selector(localizedStandardCompare:)];
    
    [customersArray addObjectsFromArray:[fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]]];
    
    NSLog(@"customersArray :%@", customersArray);
}

-(void)loadCustomersGridView
{
    

    int row = 0;
    int column = 0;
    CGFloat contentSize=155;
    
    for(UIView *tView in customerScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    [customerScrollView setContentSize:CGSizeMake(0, contentSize)];
    
    customerScrollView.showsHorizontalScrollIndicator=YES;
    

    for(int i = 0; i <[customersArray count]+1; ++i)
    {
        if(i<[customersArray count])
        {
        CustomerViewCell * innerView = [[CustomerViewCell alloc]init];

        innerView.backgroundColor=[UIColor whiteColor];
        
        innerView.frame = CGRectMake(column*320+40, row*130+50, 300, 100);

        [innerView.layer setCornerRadius:5];
        dummyBtn = [[UIButton alloc]init];
        dummyBtn.frame = CGRectMake(0,0, 300, 100);
        dummyBtn.tag = i;
        
        [dummyBtn setBackgroundColor:[UIColor clearColor]];
        [dummyBtn addTarget:self action:@selector(ShowCustomerPage:)forControlEvents:UIControlEventTouchUpInside];
        
        [innerView addSubview:dummyBtn];
        
        Customers *userObject = [customersArray objectAtIndex:i];
        
       /* if (i%2 == 0)
            innerView.customerIcon.image=[UIImage imageNamed:@"user_icon_3.png"];
        else*/
           
        innerView.customerIcon.image=[UIImage imageNamed:DEFAULT_USER_ICON];
        if(userObject.customerImageURL.length>0)
        [innerView.customerIcon setImageURL:[NSURL URLWithString:userObject.customerImageURL]];
        [innerView.customerIcon.layer setMasksToBounds:YES];
        [innerView.customerIcon.layer setCornerRadius:6];
        
        innerView.customerName.text=[NSString stringWithFormat:@"%@ %@", userObject.firstName, userObject.lastName];
        innerView.customerDesignation.text =[NSString stringWithFormat:@"%@, %@", userObject.mailingStreet, userObject.mailingCity];
        innerView.customerCompany.text =[NSString stringWithFormat:@"%@, %@", userObject.mailingState, userObject.mailingCountry];

        if (column == 2)
        {
            column = 0;
            row++;
            contentSize=contentSize+155;
            [customerScrollView setContentSize:CGSizeMake(0, contentSize)];
            
        }
        else {
            column++;
        }
        [customerScrollView addSubview:innerView];
            
        }
        
        else
        {
            
            UIView *innerView=[self addNewContactViewWithFrame:CGRectMake(column*320+40, row*130+50, 300, 100)];
            [customerScrollView addSubview:innerView];
        }
        
    }

}

- (UIView *)addNewContactViewWithFrame:(CGRect)tRect
{
    UIView *addNewLeadView=[[UIView alloc]initWithFrame:tRect];
    [addNewLeadView.layer setCornerRadius:5];
    
    [addNewLeadView setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.2]];
    
    UIImageView *addNewLeadImage=[[UIImageView alloc]initWithFrame:CGRectMake((tRect.size.width -80)/2,(tRect.size.height -80)/2, 80, 80)];
    [addNewLeadImage.layer setCornerRadius:5];
    [addNewLeadImage.layer setMasksToBounds:YES];
    
    [addNewLeadImage setImage:[UIImage imageNamed:@"add_user_icon.png"]];
    [addNewLeadView addSubview:addNewLeadImage];
    
    UIButton *dummyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    dummyButton.frame = CGRectMake(0,0, 300, 100);
    [dummyButton setBackgroundColor:[UIColor clearColor]];
    [dummyButton addTarget:self action:@selector(addNewCustomerClicked)forControlEvents:UIControlEventTouchUpInside];
    
    [addNewLeadView addSubview:dummyButton];
    
    return addNewLeadView;
}

-(void)ShowCustomerPage:(id)sender
{


    
    UIButton *temp=(UIButton*)sender;
    NSLog(@"temp tag: %d", temp.tag);
    Customers *user = [customersArray objectAtIndex:temp.tag];
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Screen" withAction:@"Customer Clicked" withLabel:user.firstName withValue:nil];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");

    [self performSelectorInBackground:@selector(getCustomerDetailsFromZoho:) withObject:user.customerID];
    
}



-(void)getCustomerDetailsFromZoho:(NSString *)customerID
{
    /*NSString * contactid = @"Contacts";
    NSString *relatedid = @"contactid";
    
    
    ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    [zohocheck FetchRelatedActivitiesForEntity: contactid :customerID];
    [zohocheck TagActivitiesToContact];
    [zohocheck FetchRelatedOpportunitiesForEntity:relatedid :customerID];
    notes= [zohocheck fetchNotesForRecordID:customerID inModule:contactid];
    [zohocheck TagOpportunitiesToContact];*/
    
    SalesForceHelper *salesForceHelper=[[SalesForceHelper alloc]init];
    [salesForceHelper fetchActivitiesForID:customerID parentModuleType:WhoModuleType];
    [salesForceHelper TagActivitiesToContact];
    [salesForceHelper fetchNotesForParentID:customerID];

    NSMutableSet *notes=[salesForceHelper fetchNotesforPrimaryID:customerID];

    dispatch_sync(dispatch_get_main_queue(), ^{
    
        NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Customers" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", customerID];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            Customers *customerObject1=(Customers *)[results objectAtIndex:0];
            [customerObject1 addNotesTaggedToCustomer:notes];
            if (![context save:&error]) {
                NSLog(@"Sorry could note save notes for customer: %@",[error localizedDescription]);
            } ;
            [self performSelectorOnMainThread:@selector(udpateAfterCustomerDetails:) withObject:customerObject1 waitUntilDone:YES];

        }

    });
    
}


-(void)udpateAfterCustomerDetails:(Customers *)customerObject
{
    [HUD hide:YES];
    
    ShowCustomerDetails *viewController = [[ShowCustomerDetails alloc] initWithNibName:@"ShowCustomerDetails" bundle:Nil];
    viewController.customerObject=customerObject;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchcustomerDetails count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    Lead * leadobject = [ SearchcustomerDetails objectAtIndex:indexPath.row];
    
    cell.imageView.image=[UIImage imageNamed:DEFAULT_USER_ICON];
    if(leadobject.customerImageURL.length>0)
    [cell.imageView setImageURL:[NSURL URLWithString:leadobject.customerImageURL]];
    
    [cell.imageView.layer setCornerRadius:6];
    [cell.imageView.layer setMasksToBounds:YES];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@",leadobject.FirstName,leadobject.LastName]];
    [cell.textLabel setTextColor:[Utils colorFromHexString:@"275d75"]];

    
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.detailTextLabel setTextAlignment:UITextAlignmentLeft];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",leadobject.AccountName]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SearchPopoverController dismissPopoverAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    Lead *user = [SearchcustomerDetails objectAtIndex:indexPath.row];
     NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
        
    NSString *customerID = user.ContactID;
    
     //checking for duplications
    ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    
    if (![zohocheck checkAttributeWithAttributeName:@"customerID" InEntityWithEntityName:@"Customers" ForPreviousItems:customerID inContext:context] )
    {

    Customers * customerObject1 = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Customers"
                                       inManagedObjectContext:context];
        
    
    customerObject1.firstName = user.FirstName;
    customerObject1.customerID =  user.ContactID;
    customerObject1.lastName = user.LastName;
    customerObject1.emailID = user.Email;
    customerObject1.department = user.Department;
    customerObject1.phoneNumber = user.Phone;
    customerObject1.descriptionAboutCustomer = user.Description;
    customerObject1.accountID = user.ACCOUNTID;
    customerObject1.accountName = user.AccountName;
    customerObject1.mailingCity = user.MailingCity;
    customerObject1.mailingCountry = user.MailingCountry;
    customerObject1.mailingStreet = user.MailingStreet;
    customerObject1.mailingState = user.MailingState;
    customerObject1.mailingZIP = user.MailingZIP;
    customerObject1.skypeID = user.skypeID;
    customerObject1.twitterID = user.TwitterID;
    customerObject1.customerImageURL=user.customerImageURL;


    }
    
    else
    {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Customers" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", customerID];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            
            Customers *customerObject1=(Customers *)[results objectAtIndex:0];
            customerObject1.firstName = user.FirstName;
            customerObject1.lastName = user.LastName;
            customerObject1.emailID = user.Email;
            customerObject1.department = user.Department;
            customerObject1.phoneNumber = user.Phone;
            customerObject1.descriptionAboutCustomer = user.Description;
            customerObject1.accountID = user.ACCOUNTID;
            customerObject1.accountName = user.AccountName;
            customerObject1.mailingCity = user.MailingCity;
            customerObject1.mailingCountry = user.MailingCountry;
            customerObject1.mailingStreet = user.MailingStreet;
            customerObject1.mailingState = user.MailingState;
            customerObject1.mailingZIP = user.MailingZIP;
            customerObject1.skypeID = user.skypeID;
            customerObject1.twitterID = user.TwitterID;
            customerObject1.customerImageURL=user.customerImageURL;
            customerObject1.customerID=user.ContactID;

        }
    }
    
    

    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText =  NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(getCustomerDetailsFromZoho:) withObject:customerID];
    
}

/*- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

     [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Screen" withAction:@"Search Clicked" withLabel:nil withValue:nil];
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SearchPopoverController presentPopoverFromRect:customersSearchBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    CustomerSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    CustomerSearchtable.dataSource=self;
    CustomerSearchtable.delegate=self;
    [popoverContent.view addSubview:CustomerSearchtable];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:customersSearchBar.text];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredArray removeAllObjects];
    
	// Filter the array using NSPredicate
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",searchText];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    
        [[ModelTrackingClass sharedInstance] setModelObject:searchText forKey:@"searchText"];
    for (int i=0; i<[customersArray count]; i++) {
        Customers *user = (Customers *)[customersArray objectAtIndex:i];
        NSString * UserName =  [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        
        if ([self string:UserName containsString:searchText]) {
            [tempArray addObject:user];
        }
        
    }
    
    self.filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    [CustomerSearchtable reloadData];
}

- (BOOL) string :(NSString *)string containsString: (NSString*) substring
{
    NSRange range = [ [string lowercaseString]  rangeOfString : [substring lowercaseString]];
    BOOL found = ( range.location != NSNotFound );
    return found;
}
 
 */

#pragma mark Customer Edit Fields

- (void)addNewCustomerClicked {
    
    
    AddEditCustomerViewController *editVC=[[AddEditCustomerViewController alloc]initWithNibName:@"AddEditCustomerViewController" bundle:nil];
    editVC.delegate=self;
    editVC.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:editVC animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                          self.view.bounds.size.height/2 - 325,
                          650, 650);
    r = [self.view convertRect:r toView:editVC.view.superview.superview];
    editVC.view.superview.frame = r;
}

#pragma mark AddEditCustomerViewController Delgates

-(void)customerDataSavedSuccessfully
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= @"Customer Details Saved Successfully!!";
    
    [self refreshCustomerDataFromCoreDataStore];
    [self loadCustomersGridView];
}

-(void)customerDataSaveFailedWithError:(NSError *)error
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText=@"Sorry could not Save Customer Details";
    
    NSLog(@"error: %@",error.localizedDescription);
}


@end
