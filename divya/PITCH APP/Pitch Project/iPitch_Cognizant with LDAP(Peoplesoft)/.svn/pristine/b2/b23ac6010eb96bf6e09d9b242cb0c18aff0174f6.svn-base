//
//  OpportunitiesViewController.m
//  iPitch V2
//
//  Created by Swarnava (376755) on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

/*
 
 THIS CLASS IS USED FOR SHOWING EXISTING OPPORTUNITY LISTS
 
 */

#import "OpportunitiesViewController.h"
#import "iPitchConstants.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShowCustomerDetails.h"
#import "ModelTrackingClass.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ShowOpportunityViewController.h"
#import "Opportunities.h"
#import "SNSDateUtils.h"
#import "iPitchAnalytics.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import "Potentials.h"
#import "ZohoHelper.h"
#import "ThemeHelper.h"
#import "SalesForceHelper.h"
#import "Opportunity.h"
#import "products.h"

@interface OpportunitiesViewController ()

@end

@implementation OpportunitiesViewController
@synthesize OpportunityScrollView, opportunitySearch, filteredArray, buttonToggle,UserIcon, NotificationIcon, Searchbtn, horizontalLine, toolBarView,titleLabel;

#pragma mark View Life Cycle

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
    
    self.titleLabel.text=NSLocalizedString(@"MY_OPPORTUNITIES", @"My Opportunities");
    SearchOpportunityDetails = [[NSMutableArray alloc]init];
    
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
    
    
    SWRevealViewController *revealController = self.revealViewController;
    [buttonToggle addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBarView addGestureRecognizer:revealController.panGestureRecognizer];
    
    
}
-(void) viewWillAppear:(BOOL)animated{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Opportunities"];
    
    // [self refreshOpportunitiesDataFromCoreDataStore];
    [self loadOpportunitiesGridView];
    
    [self.OpportunityScrollView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:TRUE];
    
    [ThemeHelper applyCurrentThemeToView];
    
}


- (IBAction)searchButtonClicked:(id)sender{
    [opportunitySearch resignFirstResponder];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText =  NSLocalizedString(@"SEARCHING", @"Searching...");
    [self performSelectorInBackground:@selector(FetchFromZoho) withObject:nil];
    
    
}


- (void)FetchFromZoho{
    
    [SearchOpportunityDetails removeAllObjects];
    [[ModelTrackingClass sharedInstance] setModelObject:opportunitySearch.text forKey:@"PotentialsearchText"];
    
    NSLog(@"model:%@",opportunitySearch.text );
    ZohoHelper * abc = [[ ZohoHelper alloc] init];
    [abc searchOpportunitiesFromZoho];
    [SearchOpportunityDetails addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"searchOpportunityArray"]];
    
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
    
    if([SearchPopoverController isPopoverVisible])
        [SearchPopoverController dismissPopoverAnimated:YES];
    SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SearchPopoverController presentPopoverFromRect:opportunitySearch.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    OpportunitySearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
    OpportunitySearchtable.dataSource=self;
    OpportunitySearchtable.delegate=self;
    [popoverContent.view addSubview:OpportunitySearchtable];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}




- (void)refreshOpportunitiesDataFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Opportunities"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    
    [OpportunityArray removeAllObjects];
    
    [OpportunityArray addObjectsFromArray:fetchedObjects];
    
}

-(void)getopportunityDetailsFromZoho:(Opportunities *)opportunityObject
{
    
    
    /* NSString * opportunityid = @"Potentials";
     ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
     [zohocheck FetchRelatedActivitiesForEntity: opportunityid :opportunityObject.opportunityID];
     [zohocheck TagActivitiesToOpportunities];
     [opportunityObject addNotesTaggedToOpportunity:[zohocheck fetchNotesForRecordID:opportunityObject.opportunityID inModule:opportunityid]];*/
    
    SalesForceHelper *salesForceHelper=[[SalesForceHelper alloc]init];
    [salesForceHelper fetchActivitiesForID:opportunityObject.opportunityID parentModuleType:WhatModuleType];
    [salesForceHelper TagActivitiesToOpportunities];
    [salesForceHelper fetchNotesForParentID:opportunityObject.opportunityID];
    opportunityObject.notesTaggedToOpportunity=[salesForceHelper fetchNotesforPrimaryID:opportunityObject.opportunityID];
    
    [self performSelectorOnMainThread:@selector(udpateAfteropportunityDetails:) withObject:opportunityObject waitUntilDone:YES];
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [OpportunityArray count];
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
        cell.imageView.image=[UIImage imageNamed:@"user_icon_4.png"];
    else
        cell.imageView.image=[UIImage imageNamed:@"user_icon_3.png"];
    
    [cell.imageView.layer setCornerRadius:6];
    [cell.imageView.layer setMasksToBounds:YES];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", ((Potentials *) [SearchOpportunityDetails objectAtIndex:indexPath.row]).PotentialName]];
    
    [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [cell.textLabel setTextAlignment:UITextAlignmentLeft];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[Utils colorFromHexString:@"275d75"]];
    
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Closing Date: %d-%@-%d",[SNSDateUtils componentsForDate:((Potentials *) [SearchOpportunityDetails objectAtIndex:indexPath.row]).ClosingDate].day, [SNSDateUtils monthNameForMonthInNumber:[SNSDateUtils componentsForDate:((Potentials *) [SearchOpportunityDetails objectAtIndex:indexPath.row]).ClosingDate].month  withFullMonthName:NO], [SNSDateUtils componentsForDate:((Potentials *) [SearchOpportunityDetails objectAtIndex:indexPath.row]).ClosingDate].year]
     ];
    
    [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [cell.detailTextLabel setTextAlignment:UITextAlignmentLeft];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    // [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@,%@", ((Opportunities *) [self.filteredArray objectAtIndex:indexPath.row]).opportunityDescription,((Opportunities *) [self.filteredArray objectAtIndex:indexPath.row]).opportunityClosingDate]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [SearchPopoverController dismissPopoverAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Potentials *user = [SearchOpportunityDetails objectAtIndex:indexPath.row];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    
    NSString *opportunityID = user.PotentialID;
    
    
    
    //checking for duplications
    ZohoHelper * zohocheck = [[ZohoHelper alloc] init];
    
    Opportunities *  opportunityObject1;
    
    if (![zohocheck checkAttributeWithAttributeName:@"opportunityID" InEntityWithEntityName:@"Opportunities" ForPreviousItems:opportunityID inContext:context] )
    {
        
        opportunityObject1 = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Opportunities"
                              inManagedObjectContext:context];
        
        
        opportunityObject1.opportunityName = user.PotentialName;
        opportunityObject1.opportunityID = user.PotentialID;
        opportunityObject1.opportunityDescription = user.PotentialDescription;
        opportunityObject1.opportunityAmount = user.Amount;
        opportunityObject1.opportunityClosingDate = user.ClosingDate;
        opportunityObject1.opportunityRelatedToAccountID = user.AccountID;
        opportunityObject1.opportunityRelatedToAccountName = user.AccountName;
        opportunityObject1.opportunityRelatedToContactID = user.ContactID;
        opportunityObject1.opportunityRelatedToContactName = user.ContactName;
        opportunityObject1.opportunityProbability = user.PotentialProbability;
        opportunityObject1.opportunityRevenue = user.PotentialRevenue;
        opportunityObject1.opportunityStage = user.PotentialStage;
        opportunityObject1.opportunityType = user.PotentialType;
        
        
        
    }
    
    else
    {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Opportunities" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"opportunityID == %@", opportunityID];
        [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            
            opportunityObject1=(Opportunities *)[results objectAtIndex:0];
            opportunityObject1.opportunityName = user.PotentialName;
            opportunityObject1.opportunityID = user.PotentialID;
            opportunityObject1.opportunityDescription = user.PotentialDescription;
            opportunityObject1.opportunityAmount = user.Amount;
            opportunityObject1.opportunityClosingDate = user.ClosingDate;
            opportunityObject1.opportunityRelatedToAccountID = user.AccountID;
            opportunityObject1.opportunityRelatedToAccountName = user.AccountName;
            opportunityObject1.opportunityRelatedToContactID = user.ContactID;
            opportunityObject1.opportunityRelatedToContactName = user.ContactName;
            opportunityObject1.opportunityProbability = user.PotentialProbability;
            opportunityObject1.opportunityRevenue = user.PotentialRevenue;
            opportunityObject1.opportunityStage = user.PotentialStage;
            opportunityObject1.opportunityType = user.PotentialType;
            
            
        }
    }
    
    
    
    
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Sorry, couldn't save Customers %@", [error localizedDescription]);
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText =  NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(getopportunityDetailsFromZoho:) withObject:opportunityObject1];
    
    
    
    
    
}

/*- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
 {
 [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
 
 [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Opportunity Screen" withAction:@"Search Clicked" withLabel:nil withValue:nil];
 UIViewController* popoverContent = [[UIViewController alloc] init];
 popoverContent.contentSizeForViewInPopover=CGSizeMake(300, 350);
 SearchPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
 [SearchPopoverController presentPopoverFromRect:OpportunitySearchBar.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 OpportunitySearchtable =[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 300, 350) style:UITableViewStylePlain];
 OpportunitySearchtable.dataSource=self;
 OpportunitySearchtable.delegate=self;
 [popoverContent.view addSubview:OpportunitySearchtable];
 }
 
 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
 {
 [self filterContentForSearchText:OpportunitySearchBar.text];
 }
 
 - (void)filterContentForSearchText:(NSString*)searchText
 {
 // Update the filtered array based on the search text and scope.
 
 // Remove all objects from the filtered search array
 [self.filteredArray removeAllObjects];
 
 // Filter the array using NSPredicate
 //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",searchText];
 
 NSMutableArray *tempArray = [[NSMutableArray alloc]init];
 
 for (int i=0; i<[OpportunityArray count]; i++) {
 Opportunities *user = (Opportunities *)[OpportunityArray objectAtIndex:i];
 NSString * UserName = user.opportunityName;
 
 if ([self string:UserName containsString:searchText]) {
 [tempArray addObject:user];
 }
 
 }
 
 self.filteredArray = [[NSMutableArray alloc] initWithArray:tempArray];
 
 [OpportunitySearchtable reloadData];
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

//Design and Display data in Opportunity LIST

-(void)loadOpportunitiesGridView
{
    int columnNumber = 0;
    int y = 0;
    CGFloat contentSize=155;
    
    for(UIView *tView in OpportunityScrollView.subviews)
    {
        if (![tView isKindOfClass:[UIImageView class]]) {
            [tView removeFromSuperview];
        }
    }
    
    
    OpportunityScrollView.showsHorizontalScrollIndicator=YES;
    
    if(SAppDelegateObject.opportArray)
    {
        for(int i = 0; i <[SAppDelegateObject.opportArray count]; ++i)
        {
            CustomerViewCell * innerView = [[CustomerViewCell alloc]init];
            
            innerView.backgroundColor=[UIColor whiteColor];
            
            innerView.frame = CGRectMake(columnNumber*320+40,y, 300, 100);
            
            [innerView.layer setCornerRadius:5];
            
            opportunityButton = [[UIButton alloc]init];
            opportunityButton.frame = CGRectMake(0,0, 300, 100);
            opportunityButton.tag = i;
            
            [opportunityButton setBackgroundColor:[UIColor clearColor]];
            [opportunityButton addTarget:self action:@selector(ShowCustomerPage:)forControlEvents:UIControlEventTouchUpInside];
            
            [innerView addSubview:opportunityButton];
            
            Opportunity *opportunityObject=[SAppDelegateObject.opportArray objectAtIndex:i];
            
            
            if (i%2 == 0)
                innerView.customerIcon.image=[UIImage imageNamed:@"user_icon_4.png"];
            else
                innerView.customerIcon.image=[UIImage imageNamed:@"user_icon_3.png"];
            
            [innerView.customerIcon.layer setCornerRadius:6];
            [innerView.customerIcon.layer setMasksToBounds:YES];
            
            
            innerView.customerName.text=opportunityObject.OpportunityName;
            [innerView.customerName setFont:[UIFont fontWithName:FONT_BOLD size:16]];
            innerView.opportunityIdValue.text = opportunityObject.OpportunityId;
            innerView.txtDesc.text = opportunityObject.CustomerName;
            
            //bring thousand seperator
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
            [formatter setGroupingSeparator:@","];
            [formatter setGroupingSize:3];
            [formatter setUsesGroupingSeparator:YES];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            innerView.TVCValue.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[opportunityObject.TCV doubleValue]]];
            [innerView.customerDesignation setFont:[UIFont fontWithName:FONT_BOLD size:12]];
            [innerView.customerCompany setFont:[UIFont fontWithName:FONT_BOLD size:12]];
            innerView.customerDesignation.text = opportunityObject.OpportunityName;
            
            
            if (columnNumber == 2)
            {
                columnNumber = 0;
                y+=130;
                
                contentSize = y + 140;
                [OpportunityScrollView setContentSize:CGSizeMake(1024, contentSize)];
            }
            else {
                columnNumber++;
            }
            
            [OpportunityScrollView addSubview:innerView];
            
        }
    }
    
}

-(void)ShowCustomerPage:(id)sender
{
    
    UIButton *temp=(UIButton*)sender;

    Opportunity *opportunityObject = [SAppDelegateObject.opportArray objectAtIndex:temp.tag];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Opportunity Screen" withAction:@"Opportunity Clicked" withLabel:opportunityObject.OpportunityName withValue:nil];
    [self udpateAfteropportunityDetails:opportunityObject];
}

//Gets called on tapping a perticular opportunity

-(void)udpateAfteropportunityDetails:(Opportunity *)opportunityObject
{
    
    if(self.revealViewController.frontViewPosition == FrontViewPositionRight)
        [self.revealViewController revealToggleAnimated:YES];
    
    
    ShowOpportunityViewController *viewController = [[ShowOpportunityViewController alloc] initWithNibName:@"ShowOpportunityViewController" bundle:Nil];
    viewController.PotentialObject = opportunityObject;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
