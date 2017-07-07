//
//  AccountsViewController.m
//  iPitch V2
//
//  Created by Vineet on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "AccountsViewController.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShowCustomerDetails.h"
#import "ModelTrackingClass.h"
#import "SWRevealViewController.h"
#import "QuartzCore/CALayer.h"
#import "ShowAccountsViewController.h"
#import "Accounts.h"
#import "iPitchAnalytics.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "ZohoHelper.h"
#import "SearchAccounts.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"
#import "AccountCell.h"


@interface AccountsViewController ()

@end

@implementation AccountsViewController
@synthesize AccountScrollView, Accountsearch, filteredArray, buttonToggle,UserIcon, NotificationIcon, Searchbtn, horizontalLine, toolBarView;
@synthesize titleLabel;

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
    SearchAccountDetails = [[NSMutableArray alloc] init];
    [self.toolBarView bringSubviewToFront:Searchbtn];
    self.titleLabel.text=NSLocalizedString(@"MY_ACCOUNTS", @"My Accounts");
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    
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
    AccountArray = [[ NSMutableArray alloc] init];
    
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Dashboard_bg.png"]];
    // Do any additional setup after loading the view from its nib.
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Accounts"];
    
    // [self refreshAccountsDataFromCoreDataStore];
    [self loadAccountsGridView];
    [self.AccountScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    [ThemeHelper applyCurrentThemeToView];
}

- (IBAction)toggleButtonClicked:(id)sender{
    
}

- (IBAction)searchButtonClicked:(id)sender{
    [Accountsearch resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"SEARCHING", @"Searching...");
    [self performSelectorInBackground:@selector(FetchFromZoho) withObject:nil];
    
    
}


- (void)FetchFromZoho{
    
    
    [SearchAccountDetails removeAllObjects];
    [[ModelTrackingClass sharedInstance] setModelObject:Accountsearch.text forKey:@"AccountsearchText"];
    
    NSLog(@"model:%@",Accountsearch.text );
    ZohoHelper * zoho = [[ ZohoHelper alloc] init];
    [zoho searchAccountsFromZoho];
    [SearchAccountDetails addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"searchAccountArray"]];
    
    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SearchPopoverController presentPopoverFromRect:Accountsearch.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    AccountsSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    AccountsSearchtable.dataSource=self;
    AccountsSearchtable.delegate=self;
    [popoverContent.view addSubview:AccountsSearchtable];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)refreshAccountsDataFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [AccountArray removeAllObjects];
    
    [AccountArray addObjectsFromArray:fetchedObjects];
    
}




-(void)getAccountDetailsFromZoho:(Accounts *)AccountObject
{
    
    SalesForceHelper *salesForceHelper=[[SalesForceHelper alloc]init];
    [salesForceHelper fetchActivitiesForID:AccountObject.accountID parentModuleType:WhatModuleType];
    [salesForceHelper fetchOpportunitiesForID:AccountObject.accountID];
    [salesForceHelper TagActivitiesToAccounts];
    [salesForceHelper TagOpportunitiesToAccounts];
    [salesForceHelper fetchNotesForParentID:AccountObject.accountID];
    
    
    AccountObject.notesTaggedToAccount= [salesForceHelper fetchNotesforPrimaryID:AccountObject.accountID];
    
    
    [self performSelectorOnMainThread:@selector(udpateAfterAccountDetails:) withObject:AccountObject waitUntilDone:YES];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchAccountDetails count];
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
    if (indexPath.row %2 == 0)
        cell.imageView.image=[UIImage imageNamed:@"account1.png"];
    else
        cell.imageView.image=[UIImage imageNamed:@"account2.png"];
    
    [cell.imageView.layer setCornerRadius:6];
    [cell.imageView.layer setMasksToBounds:YES];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //  [cell.textLabel setText:[NSString stringWithFormat:@"%@", ((SearchAccounts *) [SearchAccountDetails objectAtIndex:indexPath.row]).AccountName]];
    
    [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[Utils colorFromHexString:@"275d75"]];
    
    
    //  [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@", ((SearchAccounts *) [SearchAccountDetails objectAtIndex:indexPath.row]).AccountIndustry]];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [cell.detailTextLabel setTextAlignment:UITextAlignmentLeft];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    
    //[cell.detailTextLabel setText:[NSString stringWithFormat:@"%@,%@", ((Accounts *) [self.filteredArray objectAtIndex:indexPath.row]).accountType,((Accounts *) [self.filteredArray objectAtIndex:indexPath.row]).accountNo]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SearchPopoverController dismissPopoverAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    SearchAccounts *user = [SearchAccountDetails objectAtIndex:indexPath.row];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    //  NSString *accountID = user.AccountID;
    
    ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    Accounts *  AccountObject1;
    //   if (![zohocheck checkAttributeWithAttributeName:@"accountID" InEntityWithEntityName:@"Accounts" ForPreviousItems:accountID inContext:context] )
    //    {
    
    //        AccountObject1 = [NSEntityDescription
    //   insertNewObjectForEntityForName:@"Accounts"
    //   inManagedObjectContext:context];
    
    //        AccountObject1.accountName = user.AccountName;
    //        AccountObject1.accountID = user.AccountID;
    //        AccountObject1.acconuntPhoneNo = user.AccountPhoneNo;
    //        AccountObject1.accountNo = user.AccountNo;
    //        AccountObject1.accountType = user.AccountType;
    //        AccountObject1.accountOwnerShip = user.OwnerShip;
    //        AccountObject1.accountWebSite = user.Website;
    //        AccountObject1.accountIndustry = user.AccountIndustry;
    //        AccountObject1.mailingCity = user.MailingCity;
    //        AccountObject1.mailingCountry = user.MailingCountry;
    //        AccountObject1.mailingState = user.MailingState;
    //        AccountObject1.mailingStreet = user.MailingStreet;
    //        AccountObject1.mailingZIP = user.MailingZIP;
    //        AccountObject1.annualRevenue = user.AnnualRevenue;
    //        AccountObject1.numberOfEmployees = user.employees;
    //        AccountObject1.parentAccountId = user.ParentAccountId;
    
    
    //    }
    
    //   else
    //    {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:context]];
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", accountID];
    // [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count]>0)
    {
        
        //            AccountObject1=(Accounts *)[results objectAtIndex:0];
        //            AccountObject1.accountName = user.AccountName;
        //            AccountObject1.accountID = user.AccountID;
        //            AccountObject1.acconuntPhoneNo = user.AccountPhoneNo;
        //            AccountObject1.accountNo = user.AccountNo;
        //            AccountObject1.accountType = user.AccountType;
        //            AccountObject1.accountOwnerShip = user.OwnerShip;
        //            AccountObject1.accountWebSite = user.Website;
        //            AccountObject1.accountIndustry = user.AccountIndustry;
        //            AccountObject1.mailingCity = user.MailingCity;
        //            AccountObject1.mailingCountry = user.MailingCountry;
        //            AccountObject1.mailingState = user.MailingState;
        //            AccountObject1.mailingStreet = user.MailingStreet;
        //            AccountObject1.mailingZIP = user.MailingZIP;
        //            AccountObject1.annualRevenue = user.AnnualRevenue;
        //            AccountObject1.numberOfEmployees = user.employees;
        //            AccountObject1.parentAccountId = user.ParentAccountId;
        
        
    }
    //   }
    
    
    //  NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(getAccountDetailsFromZoho:) withObject:AccountObject1];
}

/*- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
 {
 [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
 [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Accounts Screen" withAction:@"Search Clicked" withLabel:nil withValue:nil];
 UIViewController* popoverContent = [[UIViewController alloc] init];
 popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
 SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
 [SearchPopoverController presentPopoverFromRect:AccountsSearchBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 AccountsSearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
 AccountsSearchtable.dataSource=self;
 AccountsSearchtable.delegate=self;
 [popoverContent.view addSubview:AccountsSearchtable];
 }
 
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
 [self filterContentForSearchText:AccountsSearchBar.text];
 }
 
 - (void)filterContentForSearchText:(NSString*)searchText
 {
 // Update the filtered array based on the search text and scope.
 
 // Remove all objects from the filtered search array
 [self.filteredArray removeAllObjects];
 
 // Filter the array using NSPredicate
 //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",searchText];
 
 NSMutableArray *tempArray = [[NSMutableArray alloc]init];
 
 for (int i=0; i<[AccountArray count]; i++) {
 Accounts *user = (Accounts *)[AccountArray objectAtIndex:i];
 NSString * UserName = user.accountName;
 
 if ([self string:UserName containsString:searchText]) {
 [tempArray addObject:user];
 }
 
 }
 
 self.filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];
 
 [AccountsSearchtable reloadData];
 }
 
 - (BOOL) string :(NSString *)string containsString: (NSString*) substring
 {
 NSRange range = [ [string lowercaseString]  rangeOfString : [substring lowercaseString]];
 BOOL found = ( range.location != NSNotFound );
 return found;
 }
 
 
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


- (void)viewDidUnload {
    [self setTitleLabel:nil];
    [super viewDidUnload];
    
}

#pragma mark CHANGES BY SWARNAVA

//Design and display data in Account list

- (void)loadAccountsGridView
{
    
    int y = 0;
    int columnNumber = 0;
    CGFloat contentSize=155;
    
    for(UIView *tView in AccountScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    
    AccountScrollView.showsHorizontalScrollIndicator=YES;
    
    if(SAppDelegateObject.acntArray)
    {
        for(int i = 0; i <[SAppDelegateObject.acntArray count]; ++i)
        {
            AccountCell * innerView = [[AccountCell alloc]init];
            
            innerView.backgroundColor=[UIColor whiteColor];
            
            innerView.frame = CGRectMake(columnNumber*320+40,y, 300, 70);
            
            [innerView.layer setCornerRadius:6];
            
            accountBtn = [[UIButton alloc]init];
            accountBtn.frame = CGRectMake(0,0, 300, 100);
            accountBtn.tag = i;
            [accountBtn setBackgroundColor:[UIColor clearColor]];
            [accountBtn addTarget:self action:@selector(ShowCustomerPage:)forControlEvents:UIControlEventTouchUpInside];
            
            [innerView addSubview:accountBtn];
            
            SearchAccounts *userObject = [SAppDelegateObject.acntArray objectAtIndex:i];
            
            if (i%2 == 0)
                innerView.customerIcon.image=[UIImage imageNamed:@"account1.png"];
            else
                innerView.customerIcon.image=[UIImage imageNamed:@"account2.png"];
            
            [innerView.customerIcon.layer setCornerRadius:6];
            [innerView.customerIcon.layer setMasksToBounds:YES];
            
            innerView.companyName.text=userObject.companyName;
            innerView.companyId.text = userObject.companyID;
            
            if (columnNumber == 2)
            {
                columnNumber = 0;
                y+=130;
                contentSize=y+110;
                [AccountScrollView setContentSize:CGSizeMake(1024, contentSize)];
                
            }
            else {
                columnNumber++;
            }
            [AccountScrollView addSubview:innerView];
            
        }
    }
}

//Gets called on tapping any of the Accounts

-(void)ShowCustomerPage:(id)sender
{
    UIButton *temp=(UIButton*)sender;
    SearchAccounts *user = [SAppDelegateObject.acntArray objectAtIndex:temp.tag];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Accounts Screen" withAction:@"Account Clicked" withLabel:user.companyName withValue:nil];
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");
    
    [self  udpateAfterAccountDetails:user];
}
-(void)udpateAfterAccountDetails:(SearchAccounts *)accountObject
{
    if(self.revealViewController.frontViewPosition == FrontViewPositionRight)
        [self.revealViewController revealToggleAnimated:YES];
    
    ShowAccountsViewController *viewController = [[ShowAccountsViewController alloc] initWithNibName:@"ShowAccountsViewController" bundle:Nil];
    viewController.AccObject = accountObject;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end