//
//  ShowCustomerDetails.m
//  iPitch V2
//
//  Created by Krishna Chaitanya on 13/02/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "ShowCustomerDetails.h"
#import "iPitchConstants.h"
#import "ModelTrackingClass.h"
#import "QuartzCore/CALayer.h"
#import "ShowAccountsViewController.h"
#import "Events.h"
#import "CalendarViewController.h"
#import "ShowOpportunityViewController.h"
#import "AppDelegate.h"
#import "Customers.h"
#import "Twitter.h"
#import "Utils.h"
#import "AsyncImageView.h"
#import "iPitchAnalytics.h"
#import "ZohoHelper.h"
#import "SearchAccounts.h"
#import "RearMasterTableViewController.h"
#import "AsyncImageView.h"
#import "Notes.h"
#import "AddNewOpportunityController.h"
#import "AddEditCustomerViewController.h"
#import "ThemeHelper.h"


@interface ShowCustomerDetails () <AddEditCustomerStatusDelegate>
{
    NSString *customerID;
}

@end

@implementation ShowCustomerDetails
@synthesize custDesignation, custName, custAddress, sendAppointment, recipient360Button, Backbutton, CustomerDetailView, OtherCustomerView, profileIconBtn, cispview,SocialCustomerView,accountButton,accountView, customerObject,custPhone,tweetTable,ActivityTable,OpportunityTable, skypeButton, Searchbtn, UserIcon, NotificationIcon, horizontalLine;
@synthesize socialFeedsActivityIndicator, LeadObject;
@synthesize socialFeedsTitleLabel,activitiesTitleLabel,relatedCustomersTitleLabel,upcomingAppointmentsLabel,CustomerDetailLabel;
@synthesize titleLabel,customerIconImageView,customerEmail,customerEditFieldsButton;

#define PRODUCTS_SOLD 0
#define PRODUCTS_PITCHED 1
#define RECOMMENDED_PRODUCTS 2

#define SAppDelegateObject ((AppDelegate *)[[UIApplication sharedApplication] delegate])

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TaggedAccount = [[NSMutableArray alloc] init];
  
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    self.titleLabel.text=NSLocalizedString(@"CUSTOMER_OVERVIEW", @"Customer Overview");
    self.CustomerDetailLabel.text=NSLocalizedString(@"CUSTOMER_DETAIL", @"Customer Details");
    self.activitiesTitleLabel.text=NSLocalizedString(@"ACTIVITIES", @"Activities");
    self.oppTitleLabel.text=NSLocalizedString(@"OPPORTUNITIES", @"Opportunities");
    self.socialFeedsTitleLabel.text=NSLocalizedString(@"SOCIAL_FEEDS", @"Social Feeds");
    self.relatedCustomersTitleLabel.text=NSLocalizedString(@"RELATED_CUSTOMERS", @"Related Customers");
    self.upcomingAppointmentsLabel.text=NSLocalizedString(@"UPCOMING_APPOINTMENTS", @"Upcoming Appointments");
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"search_icon.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_btn.png"]];
       

    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        Searchbtn.backgroundColor = [ UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_search_icon_1.png"]];
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
         horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
         Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_back_btn.png"]];
    }
    
    socialFeedsArray = [[NSMutableArray alloc]init];
    
     self.ActivityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
     self.OpportunityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];

    [CustomerDetailView.layer setCornerRadius:5];
    [OtherCustomerView.layer setCornerRadius:5];
    [SocialCustomerView.layer setCornerRadius:5];
    
    [self.custName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.custName setTextAlignment:UITextAlignmentLeft];
    [self.custName setBackgroundColor:[UIColor clearColor]];
    self.custName.textColor = [Utils colorFromHexString:@"275d75"];
    
    
    [self.custDesignation setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.custDesignation setTextAlignment:UITextAlignmentLeft];
    [self.custDesignation setBackgroundColor:[UIColor clearColor]];
    self.custDesignation.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.customerEmail setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.customerEmail setTextAlignment:UITextAlignmentLeft];
    [self.customerEmail setBackgroundColor:[UIColor clearColor]];
    self.customerEmail.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.custAddress setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.custAddress setTextAlignment:UITextAlignmentLeft];
    [self.custAddress setBackgroundColor:[UIColor clearColor]];
    self.custAddress.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.custPhone setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.custPhone setTextAlignment:UITextAlignmentLeft];
    [self.custPhone setBackgroundColor:[UIColor clearColor]];
    self.custPhone.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    self.recipient360Button=[[UIButton alloc]initWithFrame:CGRectMake(50, 208, 30, 30)];
    [self.recipient360Button setBackgroundImage:[UIImage imageNamed:@"360_icon.png"] forState:UIControlStateNormal];
    
    [self.accountView setBackgroundColor:[ UIColor colorWithPatternImage:[UIImage imageNamed:@"account_btn.png" ]]];
    
    [self.customerIconImageView.layer setMasksToBounds:YES];
    [self.customerIconImageView.layer setCornerRadius:6];

    customersArray=[[ NSMutableArray alloc] init];

    [self loadCustomerData];
          
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesAddedForCustomer:) name:NOTES_ADDED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesDeletedForCustomer:) name:NOTES_DELETED_NOTIFICATION object:nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    [[iPitchAnalytics sharedInstance] trackView:@"Customer Details"];
    [super viewWillAppear:animated];
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


#pragma mark Loading SocialFeeds

- (void)loadSocialFeed
{
    [self.socialFeedsActivityIndicator startAnimating];
    [self performSelectorInBackground:@selector(startLoadingSocialFeeds) withObject:nil];
}

-(void)startLoadingSocialFeeds
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tweetsLoaded:) name:@"tweetsLoaded" object:nil];
    [Twitter getTweetsFortwitterID:self.customerObject.twitterID];
}

-(void)tweetsLoaded:(NSNotification *)notification
{
    
    [socialFeedsArray addObjectsFromArray:notification.object];
    [self performSelectorOnMainThread:@selector(updateTweets) withObject:nil waitUntilDone:YES];
}


-(void)updateTweets
{
    NSLog(@"Tweets: %@", socialFeedsArray);
    [tweetTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationBottom];
    [self.socialFeedsActivityIndicator stopAnimating];
    [self.socialFeedsActivityIndicator setHidden:YES];
}

-(IBAction)SkypebuttonClicked:(id)sender{
    NSLog(@"skype:%@", customerObject.skypeID);
    
    if ([[UIApplication sharedApplication] canOpenURL:[ NSURL URLWithString:@"skype:" ]]) {
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

          [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Skyle Call Clicked" withLabel:nil withValue:nil];
        [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:[NSString stringWithFormat:@"skype://%@", customerObject.skypeID]]];
    }
    
    else
    {
        [Utils showMessage:@"Skype not installed in device" withTitle:@"Alert"];
    }
    
}

#pragma mark Core Data Cutomer Helpers

- (void)loadCustomerData
{
    
    [self loadSocialFeed];
    
    if(self.customerObject.customerImageURL.length>0)
    [self.customerIconImageView setImageURL:[NSURL URLWithString:self.customerObject.customerImageURL]];

    SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.customerObject.notesTaggedToCustomer allObjects]];
    self.custName.text =[NSString stringWithFormat:@"%@ %@",self.customerObject.firstName, self.customerObject.lastName];
    self.customerEmail.text=self.customerObject.emailID;
    self.custDesignation.text =  self.customerObject.department;
    self.custAddress.text =  [NSString stringWithFormat:@"%@, %@, %@", self.customerObject.mailingStreet, self.customerObject.mailingCity,self.customerObject.mailingState];
    self.custPhone.text = self.customerObject.phoneNumber;
    [self.accountButton setTitle:self.customerObject.accountName forState:UIControlStateNormal];
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", self.customerObject.accountID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [customersArray addObjectsFromArray:fetchedObjects];

}

- (void)refreshCurrenCustomerObjectFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customers"
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", customerID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
   if([fetchedObjects count]>0)
   {
    self.customerObject=(Customers *)[fetchedObjects objectAtIndex:0];
    [self loadCustomerData];
    
   }
    
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
    if (tableView.tag == 1)
    {
           NSLog(@"leadcount: %d", [[self.customerObject.eventsTaggedToCustomers allObjects] count]);
       return [[self.customerObject.eventsTaggedToCustomers allObjects] count];
    }
    else if (tableView.tag == 2)
        return [[self.customerObject.opportunitiesTaggedToCustomers allObjects] count];
    else if (tableView.tag == 3)
        return [socialFeedsArray count];
    else if (tableView.tag == 4)
        return [customersArray count];
    else
    return 0;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
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

        Customers *userObject =[customersArray objectAtIndex:indexPath.row];
        
        if (userObject.customerImageURL.length>0)
        [profileIcon setImageURL:[NSURL URLWithString:userObject.customerImageURL]];

        [profileIcon.layer setCornerRadius:6.0];
        [profileIcon.layer setMasksToBounds:YES];

        UILabel *custOmerName = [[UILabel alloc]init];
        custOmerName.frame = CGRectMake(80, 15, 150, 22);
        custOmerName.text = [NSString stringWithFormat:@"%@ %@",userObject.firstName, userObject.lastName];
       [custOmerName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
       [custOmerName setTextAlignment:UITextAlignmentLeft];
       [custOmerName setBackgroundColor:[UIColor clearColor]];
       custOmerName.textColor = [ Utils colorFromHexString:@"275d75"];

        
        UILabel *custDesig = [[UILabel alloc]init];
        custDesig.frame = CGRectMake(80, 40, 180, 18);
        custDesig.text = userObject.mailingCity;
        [custDesig setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [custDesig setTextAlignment:UITextAlignmentLeft];
        [custDesig setBackgroundColor:[UIColor clearColor]];
        custDesig.textColor = [ Utils colorFromHexString:@"6d6c6c"];
    

        UILabel *custOrg = [[UILabel alloc]init];
        custOrg.frame = CGRectMake(80, 60, 180, 18);
        custOrg.text = userObject.mailingStreet;
        [custOrg setFont:[UIFont fontWithName:FONT_BOLD size:14]];
        [custOrg setTextAlignment:UITextAlignmentLeft];
        [custOrg setBackgroundColor:[UIColor clearColor]];
        custOrg.textColor = [ Utils colorFromHexString:@"6d6c6c"];

    
        [cell.contentView addSubview:profileIcon];
        [cell.contentView addSubview:custOmerName];
        [cell.contentView addSubview:custDesig];
        [cell.contentView addSubview:custOrg];
    }
    
    else if (tableView.tag == 3)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleTableIdentifier];
        
       /* if ( indexPath.row %2 ==0)
        {
            cell.imageView.image = [UIImage imageNamed:@"linkedin_user1.png"];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"linkedin_user2.png"];
            
        }*/
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.imageView setImage:[UIImage imageNamed:@"twitter_loading.png"]];
        [cell.imageView setImageURL:[NSURL URLWithString:[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]]];
    
        [cell.imageView.layer setCornerRadius:6.0];
        [cell.imageView.layer setMasksToBounds:YES];
        
        NSLog(@"url: %@",[[socialFeedsArray objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"]);
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
            Opportunities *PotentialObject = [[self.customerObject.opportunitiesTaggedToCustomers allObjects] objectAtIndex:indexPath.row];
        
            OppLabel.text =PotentialObject.opportunityName;
    
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
    ActivityLabel.textColor = [ Utils colorFromHexString:@"6d6c6c"];
    [ActivityLabel setNumberOfLines:0];
    
    UIView *sideViews = [[UIView alloc]init];
    sideViews.frame = CGRectMake(0, 0, 4, 47);
    Events *activityObject = [[self.customerObject.eventsTaggedToCustomers allObjects] objectAtIndex:indexPath.row];
    NSLog(@"activityObject:%@", activityObject);
     NSLog(@"[self.customerObject.eventsTaggedToCustomers allObjects]:%@", [self.customerObject.eventsTaggedToCustomers allObjects]);
        ActivityLabel.text =activityObject.eventTitle;
      
    cell.contentView.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    

        if (indexPath.row == 0)
        {
    
            sideViews.backgroundColor = [Utils colorFromHexString: @"83a811"];
        }
        else{
             sideViews.backgroundColor = [Utils colorFromHexString: @"5e5e5e"];
        }
            
    [cell.contentView addSubview:ActivityLabel];
    [cell.contentView addSubview:sideViews];
}
    return cell;
}


#pragma mark TableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (tableView.tag ==2)
    {
        
        Opportunities * opportunitytObject =  [[ self.customerObject.opportunitiesTaggedToCustomers allObjects] objectAtIndex:indexPath.row];
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Opportunity  Clicked" withLabel:opportunitytObject.opportunityName withValue:nil];
        ShowOpportunityViewController *viewController = [[ShowOpportunityViewController alloc] initWithNibName:@"ShowOpportunityViewController" bundle:nil];
        viewController.PotentialObject = opportunitytObject;
        [self.navigationController pushViewController:viewController animated:YES];

    }
    
    else if (tableView.tag == 1)
    {
        
        Events *event = [[self.customerObject.eventsTaggedToCustomers allObjects] objectAtIndex:indexPath.row];
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];

           [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Activity Clicked" withLabel:event.eventTitle withValue:nil];
        CalendarViewController *calendarViewController=[[CalendarViewController alloc]initWithNibName:@"CalendarViewController" bundle:nil];
        
        NSDateFormatter *dateForamtter=[[NSDateFormatter alloc]init];
        [dateForamtter setDateFormat:@"dd-MMM-yy"];
        
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
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"EventClickedFromDashboard" object:event];
    
    }
}

-(IBAction)profileIconClicked:(id)sender
{
    cispview = [[SalesProcessViewController alloc] init];
    [self.navigationController pushViewController:cispview animated:YES];
}
-(IBAction)BackbuttonClicked:(id)sender{
    
     [self.navigationController popViewControllerAnimated:YES];
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
    emailTextField.text = self.customerObject.mailingCity;
    
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
    [self setAccountButton:nil];
    [self setAccountView:nil];
    [self setSocialFeedsTitleLabel:nil];
    [self setRelatedCustomersTitleLabel:nil];
    [self setOppTitleLabel:nil];
    [self setActivitiesTitleLabel:nil];
    [self setUpcomingAppointmentsLabel:nil];
    [self setTitleLabel:nil];
    [self setCustomerIconImageView:nil];
    [self setAddActivityToCustomersButton:nil];
    [self setAddOpportunityToCustomerButton:nil];
    [self setCustomerEditFieldsButton:nil];
    [self setCustomerEmail:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark Adding Activity To Customer 

- (IBAction)addActivityToCustomersButton:(id)sender {
    
    AddEventViewController *addNewEventController=[[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
    addNewEventController.eventRelatedToModule=CustomerModule;
    addNewEventController.eventRelatedToID=self.customerObject.customerID;
    addNewEventController.delegate=self;
    addNewEventController.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:addNewEventController animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 335,
                          self.view.bounds.size.height/2 - 320,
                          700, 640);
    r = [self.view convertRect:r toView:addNewEventController.view.superview.superview];
    addNewEventController.view.superview.frame = r;
}

-(void)eventSaved:(Events *)event
{
    [self.ActivityTable reloadData];
}

-(void)eventCancelled
{
    
}

#pragma mark Customer Opportunity Methods

- (IBAction)addOpportunityButtonClicked:(id)sender
{
    AddNewOpportunityController *addNewOppVC=[[AddNewOpportunityController alloc]initWithNibName:@"AddNewOpportunityController" bundle:nil];
    addNewOppVC.customerObject=self.customerObject;
    addNewOppVC.opportunityRelatedToModule=CustomerModule;
    addNewOppVC.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:addNewOppVC animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 350,
                          self.view.bounds.size.height/2 - 320,
                          700, 640);
    r = [self.view convertRect:r toView:addNewOppVC.view.superview.superview];
    addNewOppVC.view.superview.frame = r;

}

- (IBAction)accountButtonClicked:(id)sender
{
    [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
    
    [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Account Clicked" withLabel:customerObject.accountName withValue:nil];
    
    [[ModelTrackingClass sharedInstance] setModelObject:customerObject.accountName forKey:@"AccountsearchText"];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = NSLocalizedString(@"LOADING", @"Loading...");
    
    [self performSelectorInBackground:@selector(fetchAccountDetails) withObject:nil];
    
   

}

- (void)fetchAccountDetails
{
    ZohoHelper * zohocheck = [[ ZohoHelper alloc]init];
    [zohocheck searchAccountsFromZoho];
    
    [TaggedAccount removeAllObjects];
    [TaggedAccount addObjectsFromArray:[[ModelTrackingClass sharedInstance] getModelObjectForKey:@"searchAccountArray"]];
    
    Accounts * AccountObject1;

    if([TaggedAccount count]>0)
    {
    SearchAccounts *user = [TaggedAccount objectAtIndex:0];
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
   // NSString *accountID = user.AccountID;
    
    
//    if (![zohocheck checkAttributeWithAttributeName:@"accountID" InEntityWithEntityName:@"Accounts" ForPreviousItems:accountID inContext:context] )
//    {
//        
//        AccountObject1 = [NSEntityDescription
//                                     insertNewObjectForEntityForName:@"Accounts"
//                                     inManagedObjectContext:context];
//        
////        AccountObject1.accountName = user.AccountName;
////        AccountObject1.accountID = user.AccountID;
////        AccountObject1.acconuntPhoneNo = user.AccountPhoneNo;
////        AccountObject1.accountNo = user.AccountNo;
////        AccountObject1.accountType = user.AccountType;
////        AccountObject1.accountOwnerShip = user.OwnerShip;
////        AccountObject1.accountWebSite = user.Website;
////        AccountObject1.accountIndustry = user.AccountIndustry;
////        AccountObject1.mailingCity = user.MailingCity;
////        AccountObject1.mailingCountry = user.MailingCountry;
////        AccountObject1.mailingState = user.MailingState;
////        AccountObject1.mailingStreet = user.MailingStreet;
////        AccountObject1.mailingZIP = user.MailingZIP;
////        AccountObject1.annualRevenue = user.AnnualRevenue;
////        AccountObject1.numberOfEmployees = user.employees;
////        AccountObject1.parentAccountId = user.ParentAccountId;
//        
//    }
//    
//    else
//    {
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        [request setEntity:[NSEntityDescription entityForName:@"Accounts" inManagedObjectContext:context]];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountID == %@", accountID];
//        [request setPredicate:predicate];
//        
//        NSError *error = nil;
//        NSArray *results = [context executeFetchRequest:request error:&error];
//        
//        if ([results count]>0)
//        {
//            
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
//            
//        }
//    }

    NSString * accountid = @"Accounts";
 //   [zohocheck FetchRelatedActivitiesForEntity: accountid :user.AccountID];
    [zohocheck TagActivitiesToAccounts];
    NSString *relatedid = @"accountid";
  //  [zohocheck FetchRelatedOpportunitiesForEntity:relatedid :user.AccountID];
    [zohocheck TagOpportunitiesToAccounts];
    
    }
    
    [self performSelectorOnMainThread:@selector(updateAfterAccountDetailsFetch:) withObject:AccountObject1 waitUntilDone:YES];

}


- (void)updateAfterAccountDetailsFetch:(Accounts *)accountObject
{
    [HUD hide:YES];
    ShowAccountsViewController *viewController = [[ShowAccountsViewController alloc] initWithNibName:@"ShowAccountsViewController" bundle:Nil];
    viewController.AccObject = accountObject;
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark Notes Notificaiton Methods

- (void)notesAddedForCustomer:(NSNotification *)notification
{
    NSLog(@"object: %@",notification.object);

    if ([[notification.object objectForKey:NOTES_STATUS] boolValue]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"ADDING_NOTES", @"Adding Notes...");
        [self performSelectorInBackground:@selector(addNotesToCustomer:) withObject:notification.object];
    }
    
    else
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Customers" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", self.customerObject.customerID];
        [request setPredicate:predicate];
        
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

            Customers *custObject=[results objectAtIndex:0];
            [custObject addNotesTaggedToCustomerObject:notesObject];
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save notes for customer %@", [error localizedDescription]);
            }
            
            SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[custObject.notesTaggedToCustomer allObjects]];

        }
    }

}

- (void)notesDeletedForCustomer:(NSNotification *)notification
{
    
    Customers *customerObj;
    Notes *notesObj;
    
    NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customers" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"customerID == %@", self.customerObject.customerID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count]>0)
    {
        customerObj = (Customers *)[results objectAtIndex:0];
    }
    
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Notes" inManagedObjectContext:context]];
    predicate = [NSPredicate predicateWithFormat:@"noteID == %@", notification.object];
    [request setPredicate:predicate];
    
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
        [self performSelectorInBackground:@selector(deleteNotesForCustomer:) withObject:notification.object];

    }
    
    else
    {
    [customerObj removeNotesTaggedToCustomerObject:notesObj];
 
    [context deleteObject:notesObj];
        
    if (![context save:&error])
    {
        NSLog(@"Sorry, couldn't delete notes for customer %@", [error localizedDescription]);
    }
    }
    
}
- (void)addNotesToCustomer:(NSDictionary *)notesDict
{
    ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
    [zohoHelper addNotesToRecordID:self.customerObject.customerID withNoteTitle:[notesDict objectForKey:NOTES_TITLE] andNoteContent:[notesDict objectForKey:NOTES_CONTENT]];
    [self.customerObject removeNotesTaggedToCustomer:self.customerObject.notesTaggedToCustomer];
    [self.customerObject addNotesTaggedToCustomer:[zohoHelper fetchNotesForRecordID:self.customerObject.customerID inModule:@"Contacts"]];
    [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];
}

- (void)deleteNotesForCustomer:(NSString *)noteID
{
    ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
    [zohoHelper deleteNotesFromZoho:noteID];
    [self.customerObject removeNotesTaggedToCustomer:self.customerObject.notesTaggedToCustomer];
    [self.customerObject addNotesTaggedToCustomer:[zohoHelper fetchNotesForRecordID:self.customerObject.customerID inModule:@"Contacts"]];

    [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];

}
- (void)updateAfterAddingNotes
{
    SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.customerObject.notesTaggedToCustomer allObjects]];
    
    NSLog(@"Notes for this customers: %@",self.customerObject.notesTaggedToCustomer);
    [HUD hide:YES];

}

#pragma mark Customer Edit Fields

- (IBAction)customerEditFieldsClicked:(id)sender {
    
    
    AddEditCustomerViewController *editVC=[[AddEditCustomerViewController alloc]initWithNibName:@"AddEditCustomerViewController" bundle:nil];
    editVC.delegate=self;
    editVC.customerObject=self.customerObject;
    customerID=self.customerObject.customerID;
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
    
    [self refreshCurrenCustomerObjectFromCoreDataStore];
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
