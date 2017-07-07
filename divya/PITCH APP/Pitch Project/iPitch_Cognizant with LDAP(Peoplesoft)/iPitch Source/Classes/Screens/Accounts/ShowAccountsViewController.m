//
//  ShowAccountsViewController.m
//  iPitch V2
//
//  Created by Swarnava (376755) on 27/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

/*
 
 THIS CLASS IS USED FOR SHOWING ACCOUNT DETAILS
 
 */


#import "ShowAccountsViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ShowCustomerDetails.h"
#import "AppDelegate.h"
#import "ModelTrackingClass.h"
#import "SWRevealViewController.h"
#import "QuartzCore/CALayer.h"
#import "iPitchConstants.h"
#import "AddedEventViewController.h"
#import "ShowOpportunityViewController.h"
#import "Events.h"
#import "Twitter.h"
#import "Utils.h"
#import "AsyncImageView.h"
#import "iPitchAnalytics.h"
#import "iPitchConstants.h"
#import "AsyncImageView.h"
#import "Notes.h"
#import "ZohoHelper.h"
#import "AddEventViewController.h"
#import "AddNewOpportunityController.h"
#import "ThemeHelper.h"

@interface ShowAccountsViewController ()

{
    NSString *accountID;
}
@end

@implementation ShowAccountsViewController

@synthesize  accountIndustry, accountName, accountType, sendAppointment, recipient360Button, Backbutton, AccountDetailView, OtherCustomerView, profileIconBtn,SocialCustomerView, AccObject, SocialCustomerTableView, ActivityTable, OpportunityTable, horizontalLine;
@synthesize socialFeedsActivityIndicator, NotificationIcon, UserIcon, Searchbtn;

@synthesize socialFeedsTitleLabel,activitiesTitleLabel,contactsTitleLabel,upcomingAppointmentsLabel, AccountDetailLabel;
@synthesize titleLabel,accountIconImageView,accountAddressLabel,accountEditButton,accountPhoneNumberLabel,accountNumberOfEmployees;
@synthesize name,ID,IDValue,nameValue,companyName,companyID;

#define PRODUCTS_SOLD 0
#define PRODUCTS_PITCHED 1
#define RECOMMENDED_PRODUCTS 2

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])


#pragma mark ViewLifeCycle

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
    
    
    [self.companyName setFont:[UIFont fontWithName:FONT_BOLD size:22]];
    self.companyName.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.companyID setFont:[UIFont fontWithName:FONT_BOLD size:22]];
    self.companyID.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    self.AccountDetailLabel.text=NSLocalizedString(@"ACCOUNT_DETAIL", @"Account Details");
    self.titleLabel.text=NSLocalizedString(@"ACCOUNT_OVERVIEW", @"Account Overview");
    self.contactsTitleLabel.text=NSLocalizedString(@"CONTACTS", @"Contacts");
    self.activitiesTitleLabel.text=NSLocalizedString(@"ACTIVITIES", @"Activities");
    // self.oppTitleLabel.text=NSLocalizedString(@"OPPORTUNITIES", @"Opportunities");
    self.socialFeedsTitleLabel.text=NSLocalizedString(@"SOCIAL_FEEDS", @"Social Feeds");
    self.upcomingAppointmentsLabel.text=NSLocalizedString(@"UPCOMING_APPOINTMENTS", @"Upcoming Appointments");
    
    [self.accountIconImageView.layer setCornerRadius:6];
    [self.accountIconImageView.layer setMasksToBounds:YES];
    customersArray=[[ NSMutableArray alloc] init];
    socialFeedsArray = [[NSMutableArray alloc]init];
    
    //[self refreshCurrentAccountDataFromCoreDataStore];
    [self loadAccountData];
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_btn.png.png"]];
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_back_btn.png"]];
    }
    
    self.ActivityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    self.OpportunityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    
    [AccountDetailView.layer setCornerRadius:5];
    [OtherCustomerView.layer setCornerRadius:5];
    [SocialCustomerView.layer setCornerRadius:5];
    
    [self.accountName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.accountName setTextAlignment:UITextAlignmentLeft];
    [self.accountName setBackgroundColor:[UIColor clearColor]];
    self.accountName.textColor = [Utils colorFromHexString:@"275d75"];
    
    [self.accountIndustry setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.accountIndustry setTextAlignment:UITextAlignmentLeft];
    [self.accountIndustry setBackgroundColor:[UIColor clearColor]];
    self.accountIndustry.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    [self.accountType setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.accountType setTextAlignment:UITextAlignmentLeft];
    [self.accountType setBackgroundColor:[UIColor clearColor]];
    self.accountType.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    [self.accountPhoneNumberLabel setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [self.accountPhoneNumberLabel setTextAlignment:UITextAlignmentLeft];
    [self.accountPhoneNumberLabel setBackgroundColor:[UIColor clearColor]];
    self.accountPhoneNumberLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.accountAddressLabel setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [self.accountAddressLabel setTextAlignment:UITextAlignmentLeft];
    [self.accountAddressLabel setBackgroundColor:[UIColor clearColor]];
    self.accountAddressLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.accountNumberOfEmployees setFont:[UIFont fontWithName:FONT_BOLD size:14]];
    [self.accountNumberOfEmployees setTextAlignment:UITextAlignmentLeft];
    [self.accountNumberOfEmployees setBackgroundColor:[UIColor clearColor]];
    self.accountNumberOfEmployees.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesAddedForAccount:) name:NOTES_ADDED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesDeletedForAccount:) name:NOTES_DELETED_NOTIFICATION object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Account Details"];
    [self.navigationController setNavigationBarHidden:YES];
    [ThemeHelper applyCurrentThemeToView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Core Data Store Helpers

- (void)refreshCurrentAccountDataFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Accounts"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", accountID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count]>0)
    {
        self.AccObject=(Accounts *)[fetchedObjects objectAtIndex:0];
        [self loadAccountData];
        
    }
}



#pragma mark socialFeeds

- (void)loadSocialFeed
{
    [self.socialFeedsActivityIndicator startAnimating];
    [self performSelectorInBackground:@selector(startLoadingSocialFeeds) withObject:nil];
}

-(void)startLoadingSocialFeeds
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetsLoaded:) name:@"tweetsLoaded" object:nil];
    [Twitter getTweetsFortwitterID:@"vineet18iitr"];
    
}

-(void)tweetsLoaded:(NSNotification *)notification
{
    
    [socialFeedsArray addObjectsFromArray:notification.object];
    [self performSelectorOnMainThread:@selector(updateTweets) withObject:nil waitUntilDone:YES];
}


-(void)updateTweets
{
    NSLog(@"Tweets: %@", socialFeedsArray);
    [SocialCustomerTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [self.socialFeedsActivityIndicator stopAnimating];
    [self.socialFeedsActivityIndicator setHidden:YES];
}

#pragma mark TableView Datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
        return 47;
    else if (tableView.tag == 2)
        return 47;
    else if (tableView.tag == 3)
        return 80;
    else if (tableView.tag == 4)
        return 100;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (tableView.tag == 1)
    //       // return [AccObject.eventsTaggedToAccount count];
    //    else if (tableView.tag == 2)
    //        //return [AccObject.opportunitiesTaggedToAccount count];
    //    else if (tableView.tag == 3)
    //        return [socialFeedsArray count];
    //    else if (tableView.tag == 4)
    //        return [customersArray count];
    //    else
    return 0;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    else
    {
        for (UIView *subview in cell.contentView.subviews)
            [subview removeFromSuperview];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (tableView.tag == 4)
    {
        
        UIImageView *profileIcon = [[UIImageView alloc]init];
        profileIcon.image=[UIImage imageNamed:DEFAULT_USER_ICON];
        profileIcon.frame = CGRectMake(15, 25, 50, 50);
        [profileIcon.layer setCornerRadius:6];
        [profileIcon.layer setMasksToBounds:YES];
        
        Customers *userObject = [customersArray objectAtIndex:indexPath.row];
        if(userObject.customerImageURL.length>0)
            [profileIcon setImageURL:[NSURL URLWithString:userObject.customerImageURL]];
        
        UILabel *custOmerName = [[UILabel alloc]init];
        custOmerName.frame = CGRectMake(80, 15, 150, 22);
        custOmerName.text = [NSString stringWithFormat:@"%@ %@",userObject.firstName, userObject.lastName];
        [custOmerName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
        [custOmerName setTextAlignment:UITextAlignmentLeft];
        [custOmerName setBackgroundColor:[UIColor clearColor]];
        custOmerName.textColor = [Utils colorFromHexString:@"275d75"];
        
        
        UILabel *custDesig = [[UILabel alloc]init];
        custDesig.frame = CGRectMake(80, 40, 180, 18);
        custDesig.text = userObject.mailingCity;
        [custDesig setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [custDesig setTextAlignment:UITextAlignmentLeft];
        [custDesig setBackgroundColor:[UIColor clearColor]];
        custDesig.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        
        UILabel *custOrg = [[UILabel alloc]init];
        custOrg.frame = CGRectMake(80, 60, 180, 18);
        custOrg.text = userObject.mailingStreet;
        [custOrg setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [custOrg setTextAlignment:UITextAlignmentLeft];
        [custOrg setBackgroundColor:[UIColor clearColor]];
        custOrg.textColor = [Utils colorFromHexString:@"6d6c6c"];
        
        
        [cell.contentView addSubview:profileIcon];
        [cell.contentView addSubview:custOmerName];
        [cell.contentView addSubview:custDesig];
        [cell.contentView addSubview:custOrg];
    }
    
    else if (tableView.tag == 3)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        
        /*if ( indexPath.row %2 ==0)
         {
         //  cell.imageView.image = [UIImage imageNamed:@"linkedin_user1.png"];
         }
         else
         {
         // cell.imageView.image = [UIImage imageNamed:@"linkedin_user2.png"];
         
         }*/
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.imageView setImage:[UIImage imageNamed:@"twitter_loading.png"]];
        [cell.imageView setImageURL:[NSURL URLWithString:[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]]];
        
        [cell.imageView.layer setCornerRadius:6.0];
        [cell.imageView.layer setMasksToBounds:YES];
        
        UIImageView *SocialImage = [[UIImageView alloc]init];
        SocialImage.frame = CGRectMake(260, 55, 18, 18);
        SocialImage.image = [UIImage imageNamed:@"twitter_icon.png"];
        
        [cell.textLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [cell.textLabel setTextAlignment:UITextAlignmentLeft];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        cell.textLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [cell.textLabel setNumberOfLines:2];
        
        cell.textLabel.text = [[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"text"];
        
        [cell.detailTextLabel setFont:[UIFont fontWithName:FONT_REGULAR size:12]];
        cell.detailTextLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
        cell.detailTextLabel.text = [[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"created_at"] substringToIndex:20];
        
        [cell.contentView addSubview:SocialImage];
    }
    
    else if (tableView.tag == 2)
    {
        UILabel *OppLabel = [[UILabel alloc]init];
        OppLabel.frame = CGRectMake(80, 20, 400, 18);
        [OppLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [OppLabel setTextAlignment:UITextAlignmentLeft];
        [OppLabel setBackgroundColor:[UIColor clearColor]];
        OppLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [OppLabel setNumberOfLines:0];
        
        UIView *sideViews = [[UIView alloc]init];
        sideViews.frame = CGRectMake(0, 0, 4, 47);
        
        cell.contentView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
        // Opportunities *potentialObject = [[AccObject.opportunitiesTaggedToAccount allObjects]objectAtIndex:indexPath.row];
        // OppLabel.text =potentialObject.opportunityName;
        
        
        {
            if (indexPath.row == 0)
            {
                
                sideViews.backgroundColor = [Utils colorFromHexString: @"83a811"];
                UIImageView *medalImage = [[UIImageView alloc]init];
                medalImage.frame= CGRectMake(540, 10, 16, 23);
                medalImage.image = [UIImage imageNamed:@"medal_icon.png"];
                [cell.contentView addSubview:medalImage];
            }
            
            else
            {
                
                sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
                
                
            }
            
        }
        [cell.contentView addSubview:OppLabel];
        [cell.contentView addSubview:sideViews];
    }
    
    else if (tableView.tag == 1)
    {
        UILabel *ActivityLabel = [[UILabel alloc]init];
        ActivityLabel.frame = CGRectMake(80, 20, 400, 18);
        [ActivityLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
        [ActivityLabel setTextAlignment:UITextAlignmentLeft];
        [ActivityLabel setBackgroundColor:[UIColor clearColor]];
        ActivityLabel.textColor = [Utils colorFromHexString:@"6d6c6c"];
        [ActivityLabel setNumberOfLines:0];
        
        UIView *sideViews = [[UIView alloc]init];
        sideViews.frame = CGRectMake(0, 0, 4, 47);
        cell.contentView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
        
        //  Events *activityObject = [[AccObject.eventsTaggedToAccount allObjects] objectAtIndex:indexPath.row];
        
        //  ActivityLabel.text =activityObject.eventTitle;
        
        
        {
            
            if (indexPath.row == 0)
            {
                
                sideViews.backgroundColor = [Utils colorFromHexString: @"83a811"];
                
            }
            
            else
            {
                
                sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
                
                
            }
        }
        [cell.contentView addSubview:ActivityLabel];
        [cell.contentView addSubview:sideViews];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    return view;
}

#pragma mark TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
     UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
     
     cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
     if ( tableView.tag ==2)
     {
     Opportunities * opportunitytObject =  [[ self.AccObject.opportunitiesTaggedToAccount allObjects] objectAtIndex:indexPath.row];
     [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
     
     [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Account Detail Screen" withAction:@"Opportunity Clicked" withLabel:opportunitytObject.opportunityName withValue:nil];
     
     ShowOpportunityViewController *viewController = [[ShowOpportunityViewController alloc] initWithNibName:@"ShowOpportunityViewController" bundle:nil];
     viewController.PotentialObject = opportunitytObject;
     [self.navigationController pushViewController:viewController animated:YES];
     
     
     }
     else if (tableView.tag == 1)
     {
     Events *event = [[self.AccObject.eventsTaggedToAccount allObjects] objectAtIndex:indexPath.row];
     [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
     
     [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Account Detail Screen" withAction:@"Activity Clicked" withLabel:event.eventTitle withValue:nil];
     CalendarViewController *calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
     
     calendarViewController.sDayViewController.events=event;
     [[ModelTrackingClass sharedInstance] setModelObject:event.eventStartDate forKey:@"currentDay"];
     
     RearMasterTableViewController *rearViewController = [[RearMasterTableViewController alloc] init];
     
     SWRevealViewController *mainRevealController =
     [[SWRevealViewController alloc] initWithRearViewController:rearViewController frontViewController:calendarViewController];
     
     mainRevealController.rearViewRevealWidth = 200;
     mainRevealController.rearViewRevealOverdraw = 150;
     mainRevealController.bounceBackOnOverdraw = NO;
     mainRevealController.stableDragOnOverdraw = YES;
     [mainRevealController setFrontViewPosition:FrontViewPositionLeft];
     
     
     [self.navigationController pushViewController:mainRevealController animated:YES];
     
     [[NSNotificationCenter defaultCenter]postNotificationName:@"EventClickedFromDashboard" object:event];}
     
     */
    
}




-(IBAction)profileIconClicked:(id)sender
{
    //    cispview = [[SalesProcessViewController alloc] init];
    //    [self.navigationController pushViewController:cispview animated:YES];
}

-(IBAction)BackbuttonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


//Gets called on tapping + buton for Adding opportunity



- (IBAction)addEventToAccountButtonPressed:(id)sender {
    /*
     AddEventViewController *addNewEventController=[[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
     addNewEventController.eventRelatedToModule=AccountsModule;
     addNewEventController.eventRelatedToID=self.AccObject.accountID;
     addNewEventController.delegate=self;
     addNewEventController.modalPresentationStyle=UIModalPresentationFormSheet;
     [self presentModalViewController:addNewEventController animated:YES];
     CGRect r = CGRectMake(self.view.bounds.size.width/2 - 335,
     self.view.bounds.size.height/2 - 320,
     670, 640);
     r = [self.view convertRect:r toView:addNewEventController.view.superview.superview];
     addNewEventController.view.superview.frame = r;
     */
    
}

-(void)eventSaved:(Events *)event
{
    [self.ActivityTable reloadData];
}

-(void)eventCancelled
{
}

-(IBAction)sendAppointment:(id)sender
{
    UIViewController* popoverContent = [[UIViewController alloc] init];
    popoverContent.contentSizeForViewInPopover=CGSizeMake(500, 400);
    
    if([SendAppointmentPopoverController isPopoverVisible])
        [SendAppointmentPopoverController dismissPopoverAnimated:YES];
    SendAppointmentPopoverController = [[UIPopoverController alloc]initWithContentViewController:popoverContent];
    [SendAppointmentPopoverController presentPopoverFromRect:sendAppointment.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
    
    emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 60, 300, 40)];
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.font = [UIFont systemFontOfSize:15];
    emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextField.keyboardType = UIKeyboardTypeDefault;
    emailTextField.returnKeyType = UIReturnKeyDone;
    
    dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 110, 300, 40)];
    dateTextField.borderStyle = UITextBorderStyleRoundedRect;
    dateTextField.font = [UIFont systemFontOfSize:15];
    dateTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    dateTextField.keyboardType = UIKeyboardTypeDefault;
    dateTextField.returnKeyType = UIReturnKeyDone;
    
    date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:date];
    dateTextField.text = dateString;
    
    timeTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 160, 300, 40)];
    timeTextField.borderStyle = UITextBorderStyleRoundedRect;
    timeTextField.font = [UIFont systemFontOfSize:15];
    timeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    timeTextField.keyboardType = UIKeyboardTypeDefault;
    timeTextField.returnKeyType = UIReturnKeyDone;
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc]init];
    [timeFormat setDateFormat:@"h:mm a"];
    NSString *timeString = [timeFormat stringFromDate:date];
    timeTextField.text = timeString;
    
    locationTextField = [[UITextField alloc] initWithFrame:CGRectMake(90, 210, 300, 40)];
    locationTextField.borderStyle = UITextBorderStyleRoundedRect;
    locationTextField.font = [UIFont systemFontOfSize:15];
    locationTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    locationTextField.keyboardType = UIKeyboardTypeDefault;
    locationTextField.returnKeyType = UIReturnKeyDone;
    locationTextField.text = @"Chennai";
    
    saveInvite = [[UIButton alloc]init];
    [saveInvite setTitle:@"Save Invite" forState:UIControlStateNormal];
    [saveInvite setBackgroundColor:[UIColor grayColor]];
    [saveInvite addTarget:self action:@selector(saveInvite:) forControlEvents:UIControlEventTouchUpInside];
    saveInvite.frame = CGRectMake(100, 300, 110, 30);
    
    sendInvite = [[UIButton alloc]init];
    [sendInvite setTitle:@"Send Invite" forState:UIControlStateNormal];
    [sendInvite setBackgroundColor:[UIColor grayColor]];
    [sendInvite addTarget:self action:@selector(sendInvite:) forControlEvents:UIControlEventTouchUpInside];
    sendInvite.frame = CGRectMake(270, 300, 110, 30);
    
    
    [popoverContent.view addSubview:emailTextField];
    [popoverContent.view addSubview:dateTextField];
    [popoverContent.view addSubview:timeTextField];
    [popoverContent.view addSubview:locationTextField];
    [popoverContent.view addSubview:saveInvite];
    [popoverContent.view addSubview:sendInvite];
}

-(void)sendInvite:(id)sender
{
    
}

-(void)saveInvite:(id)sender
{
    
}

- (void)viewDidUnload
{
    [self setSocialFeedsActivityIndicator:nil];
    [self setAddEventToAccountButton:nil];
    [self setAddOpportunityToAccountButton:nil];
    [self setAccountIconImageView:nil];
    [self setAccountEditButton:nil];
    [self setAccountAddressLabel:nil];
    [self setAccountPhoneNumberLabel:nil];
    [self setAccountNumberOfEmployees:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


#pragma mark Notes Notificaiton Methods

- (void)notesAddedForAccount:(NSNotification *)notification
{
    NSLog(@"object: %@",notification.object);
    
    if ([[notification.object objectForKey:NOTES_STATUS] boolValue]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"ADDING_NOTES", @"Adding Notes...");
        [self performSelectorInBackground:@selector(addNotesToAccount:) withObject:notification.object];
    }
    
    else
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:context]];
        // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", self.AccObject.accountID];
        // [request setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        if ([results count]>0)
        {
            Notes *notesObject=[NSEntityDescription
                                insertNewObjectForEntityForName:@"Notes"
                                inManagedObjectContext:context];
            notesObject.noteTitle=[notification.object objectForKey:NOTES_TITLE];
            notesObject.noteContent=[notification.object objectForKey:NOTES_CONTENT];
            notesObject.noteCreationDate=[[NSDate alloc]init];
            notesObject.notesCRMSyncStatus=[NSNumber numberWithBool:NO];
            
            Accounts *accObj=[results objectAtIndex:0];
            [accObj addNotesTaggedToAccountObject:notesObject];
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save notes for customer %@", [error localizedDescription]);
            }
            
            SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[accObj.notesTaggedToAccount allObjects]];
            
        }
    }
    
}

- (void)notesDeletedForAccount:(NSNotification *)notification
{
    
    Accounts *accObject;
    Notes *notesObj;
    
    NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:context]];
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", self.AccObject.accountID];
    //  [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count]>0)
    {
        accObject = (Accounts *)[results objectAtIndex:0];
    }
    
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context]];
    //  predicate = [NSPredicate predicateWithFormat:@"noteID == %@", notification.object];
    //  [request setPredicate:predicate];
    
    results = [context executeFetchRequest:request error:&error];
    
    if ([results count]>0)
    {
        notesObj = (Notes *)[results objectAtIndex:0];
    }
    
    if([notesObj.notesCRMSyncStatus boolValue])
    {
        //delete notes in CRM
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"DELETING_NOTE", @"Deleting Note...");
        [self performSelectorInBackground:@selector(deleteNotesForAccount:) withObject:notification.object];
        
    }
    
    else
    {
        [accObject removeNotesTaggedToAccountObject:notesObj];
        
        [context deleteObject:notesObj];
        
        if (![context save:&error])
        {
            NSLog(@"Sorry, couldn't delete notes for customer %@", [error localizedDescription]);
        }
    }
    
}
- (void)addNotesToAccount:(NSDictionary *)notesDict
{
    /*
     
     ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
     [zohoHelper addNotesToRecordID:self.AccObject.accountID withNoteTitle:[notesDict objectForKey:NOTES_TITLE] andNoteContent:[notesDict objectForKey:NOTES_CONTENT]];
     [self.AccObject removeNotesTaggedToAccount:self.AccObject.notesTaggedToAccount];
     [self.AccObject addNotesTaggedToAccount:[zohoHelper fetchNotesForRecordID:self.AccObject.accountID inModule:@"Accounts"]];
     [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];
     
     */
}

- (void)deleteNotesForAccount:(NSString *)noteID
{
    /*
     ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
     [zohoHelper deleteNotesFromZoho:noteID];
     [self.AccObject removeNotesTaggedToAccount:self.AccObject.notesTaggedToAccount];
     [self.AccObject addNotesTaggedToAccount:[zohoHelper fetchNotesForRecordID:self.AccObject.accountID inModule:@"Accounts"]];
     
     [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];
     */
    
}
- (void)updateAfterAddingNotes
{
    // SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.AccObject.notesTaggedToAccount allObjects]];
    
    // NSLog(@"Notes for this customers: %@",self.AccObject.notesTaggedToAccount);
    [HUD hide:YES];
    
}


#pragma mark Account Edit Methods

- (IBAction)accountEditButtonClicked:(id)sender  {
    
    AddEditAccountsViewController *editVC=[[AddEditAccountsViewController alloc]initWithNibName:@"AddEditAccountsViewController" bundle:nil];
    editVC.delegate=self;
    //  editVC.accountObject=self.AccObject;
    // accountID=self.AccObject.accountID;
    editVC.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:editVC animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                          self.view.bounds.size.height/2 - 325,
                          650, 650);
    r = [self.view convertRect:r toView:editVC.view.superview.superview];
    editVC.view.superview.frame = r;
}





#pragma mark CHANGES BY SWARNAVA


//Display data in Account Details

- (void)loadAccountData
{
    self.companyID.text   = self.AccObject.companyID;
    self.companyName.text = self.AccObject.companyName;
}


//Gets called for Adding Opportunity

- (IBAction)addOpportunityToAccountButtonPressed:(id)sender {
    
    AddNewOpportunityController *addNewOppVC=[[AddNewOpportunityController alloc]initWithNibName:@"AddNewOpportunityController" bundle:nil];
    addNewOppVC.accountObject=self.AccObject;
    addNewOppVC.edit = FALSE;
    addNewOppVC.sucessDelegate = self;
    addNewOppVC.opportunityRelatedToModule=AccountsModule;
    addNewOppVC.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:addNewOppVC animated:YES completion:NULL];
    
    
    CGRect r = CGRectMake(0,0,640, 640);
    r = [self.view convertRect:r toView:addNewOppVC.view.superview.superview];
    addNewOppVC.view.superview.superview.frame = r;
    
}

// Call back SUCCESS method for adding an Account

-(void)showSuccess:(Opportunity *)object
{
    if(SAppDelegateObject.opportArray)
    {
        [SAppDelegateObject.opportArray addObject:object];
        NSSortDescriptor *nameSorter = [[NSSortDescriptor alloc]initWithKey:@"CustomerName" ascending:YES];
        [SAppDelegateObject.opportArray sortUsingDescriptors:[NSArray arrayWithObject:nameSorter]];
    }
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= [NSString stringWithFormat:@"Opportunity id %@ created successfully",object.OpportunityId];
    
}

// Call back NO CONTACT(Error) method for adding an Account

-(void)showNoPrimaryContact
{
    [Utils showMessage:NO_CONTACT_ERROR withTitle:NSLocalizedString(@"ALERT",@"Alert")];
}

@end
