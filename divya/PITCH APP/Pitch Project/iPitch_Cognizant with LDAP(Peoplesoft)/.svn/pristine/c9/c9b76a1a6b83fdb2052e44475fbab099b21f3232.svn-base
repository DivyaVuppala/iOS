//
//  LeadDetailsViewController.m
//  iPitch V2
//
//  Created by Satheeshwaran on 5/11/13.
//  Copyright (c) 2013 Cognizant. All rights reserved.
//

#import "LeadDetailsViewController.h"
#import "Utils.h"
#import "iPitchConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "Twitter.h"
#import "iPitchAnalytics.h"
#import "AppDelegate.h"
#import "ZohoHelper.h"
#import "ZohoConstants.h"
#import "AsyncImageView.h"
#import "Events.h"
#import "SWRevealViewController.h"
#import "CalendarViewController.h"
#import "ModelTrackingClass.h"
#import "RearMasterTableViewController.h"
#import "AddEditLeadViewController.h"
#import "Notes.h"

@interface LeadDetailsViewController ()<AddEditLeadStatusDelegate>
{
    NSString *leadID;
}

@end

@implementation LeadDetailsViewController
@synthesize leadAddress, leadDesignation, leadDetailLabel, leadDetailView, leadEditFieldsButton, leadEmail, leadIconImageView, leadName, leadPhone, leadThirdView,LeadObject,tweetTable,ActivityTable, skypeButton,  UserIcon, NotificationIcon, horizontalLine,OtherleadView,socialFeedsActivityIndicator,socialFeedsTitleLabel,SocialLeadView;

@synthesize activitiesTitleLabel,relatedCustomersTitleLabel,upcomingAppointmentsLabel;
@synthesize titleLabel,Backbutton,leadDescriptionLabel,leadDescriptionTitleLabel,leadRatingLabel,leadRatingTitleLabel,leadSourceLabel,leadSourceTitleLabel,leadStatusLabel,leadStatusTitleLabel;

#pragma mark View Life Cycle Methods

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_BG_IMAGE]]];
    
    self.titleLabel.text=NSLocalizedString(@"LEAD_OVERVIEW", @"Lead Overview");
    self.leadDetailLabel.text=NSLocalizedString(@"LEAD_DETAILS", @"Lead Details");
    self.activitiesTitleLabel.text=NSLocalizedString(@"ACTIVITIES", @"Activities");
    self.socialFeedsTitleLabel.text=NSLocalizedString(@"SOCIAL_FEEDS", @"Social Feeds");
    self.relatedCustomersTitleLabel.text=NSLocalizedString(@"RELATED_CUSTOMERS", @"Related Customers");
    self.upcomingAppointmentsLabel.text=NSLocalizedString(@"UPCOMING_APPOINTMENTS", @"Upcoming Appointments");
    
    if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME1_NAME])
    {
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"horzontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back_btn.png"]];
        
        
    }
    else if ([[Utils userDefaultsGetObjectForKey:IPITCH_CURRENT_THEME_NAME] isEqualToString:IPITCH_THEME2_NAME])
    {
        NotificationIcon.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_notification_icon.png"]];
        horizontalLine.image = [UIImage imageNamed:@"Theme2_horizontal_line.png"];
        Backbutton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Theme2_back_btn.png"]];
    }
    
    socialFeedsArray = [[NSMutableArray alloc]init];
    
    self.ActivityTable.backgroundColor = [Utils colorFromHexString:@"f6f6f6"];
    
    [leadDetailView.layer setCornerRadius:5];
    [SocialLeadView.layer setCornerRadius:5];
    [OtherleadView.layer setCornerRadius:5];
    
    [self.leadName setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.leadName setTextAlignment:UITextAlignmentLeft];
    [self.leadName setBackgroundColor:[UIColor clearColor]];
    self.leadName.textColor = [Utils colorFromHexString:@"275d75"];
    
    
    [self.leadDesignation setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadDesignation setTextAlignment:UITextAlignmentLeft];
    [self.leadDesignation setBackgroundColor:[UIColor clearColor]];
    self.leadDesignation.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.leadEmail setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadEmail setTextAlignment:UITextAlignmentLeft];
    [self.leadEmail setBackgroundColor:[UIColor clearColor]];
    self.leadEmail.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.leadAddress setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadAddress setTextAlignment:UITextAlignmentLeft];
    [self.leadAddress setBackgroundColor:[UIColor clearColor]];
    self.leadAddress.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.leadPhone setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadPhone setTextAlignment:UITextAlignmentLeft];
    [self.leadPhone setBackgroundColor:[UIColor clearColor]];
    self.leadPhone.textColor = [Utils colorFromHexString:@"6d6c6c"];
    
    [self.leadRatingLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.leadRatingLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadRatingLabel setBackgroundColor:[UIColor clearColor]];
    self.leadRatingLabel.textColor = [Utils colorFromHexString:GRAY_COLOR_CODE];
    
    [self.leadRatingTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadRatingTitleLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadRatingTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.leadRatingTitleLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    
    [self.leadDescriptionLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.leadDescriptionLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    self.leadDescriptionLabel.textColor = [Utils colorFromHexString:GRAY_COLOR_CODE];
    
    [self.leadDescriptionTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadDescriptionTitleLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadDescriptionTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.leadDescriptionTitleLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    
    [self.leadStatusLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.leadStatusLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadStatusLabel setBackgroundColor:[UIColor clearColor]];
    self.leadStatusLabel.textColor = [Utils colorFromHexString:GRAY_COLOR_CODE];
    
    [self.leadStatusTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadStatusTitleLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadStatusTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.leadStatusTitleLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    
    [self.leadSourceLabel setFont:[UIFont fontWithName:FONT_BOLD size:18]];
    [self.leadSourceLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadSourceLabel setBackgroundColor:[UIColor clearColor]];
    self.leadSourceLabel.textColor = [Utils colorFromHexString:GRAY_COLOR_CODE];
    
    [self.leadSourceTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:16]];
    [self.leadSourceTitleLabel setTextAlignment:UITextAlignmentLeft];
    [self.leadSourceTitleLabel setBackgroundColor:[UIColor clearColor]];
    self.leadSourceTitleLabel.textColor = [Utils colorFromHexString:ORANGE_COLOR_CODE];
    
    [self.leadIconImageView.layer setMasksToBounds:YES];
    [self.leadIconImageView.layer setCornerRadius:6];
    
    customersArray=[[ NSMutableArray alloc] init];
    
    [self loadLeadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesAddedForLead:) name:NOTES_ADDED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notesDeletedForLead:) name:NOTES_DELETED_NOTIFICATION object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    [self setLeadStatusLabel:nil];
    [self setLeadDescriptionTitleLabel:nil];
    [self setLeadDescriptionLabel:nil];
    [self setLeadSourceLabel:nil];
    [self setLeadRatingLabel:nil];
    [self setLeadStatusLabel:nil];
    [self setLeadSourceTitleLabel:nil];
    [self setLeadRatingTitleLabel:nil];
    [self setLeadStatusTitleLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
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
    [Twitter getTweetsFortwitterID:self.LeadObject.leadTwitterID];
}

-(void)tweetsLoaded:(NSNotification *)notification
{
    [socialFeedsArray removeAllObjects];
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
    NSLog(@"skype:%@", self.LeadObject.leadSkypeID);
    
    if ([[UIApplication sharedApplication] canOpenURL:[ NSURL URLWithString:@"skype:" ]]) {
        
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Skyle Call Clicked" withLabel:nil withValue:nil];
        [[UIApplication sharedApplication] openURL:[ NSURL URLWithString:[NSString stringWithFormat:@"skype://%@", self.LeadObject.leadSkypeID]]];
    }
    
    else
    {
        [Utils showMessage:@"Skype not installed in device" withTitle:@"Alert"];
    }
    
}

#pragma mark Core Data Lead Helpers

- (void)loadLeadData
{
    
    [self loadSocialFeed];
    
    if(self.LeadObject.leadImageURL.length>0)
    [self.leadIconImageView setImageURL:[NSURL URLWithString:self.LeadObject.leadImageURL]];
    
    SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.LeadObject.notesTaggedToLead allObjects]];
    self.leadName.text =[NSString stringWithFormat:@"%@ %@",self.LeadObject.leadFirstName, self.LeadObject.leadLastName];
    self.leadEmail.text=self.LeadObject.leadCompany;
    self.leadDesignation.text =  self.LeadObject.leadTitle;
    self.leadAddress.text =  [NSString stringWithFormat:@"%@, %@, %@", self.LeadObject.mailingStreet, self.LeadObject.mailingCity,self.LeadObject.mailingState];
    self.leadPhone.text = self.LeadObject.leadPhone;
    self.leadSourceLabel.text=self.LeadObject.leadSource;
    self.leadRatingLabel.text=self.LeadObject.leadRating;
    self.leadStatusLabel.text=self.LeadObject.leadStatus;
    self.leadDescriptionLabel.text=self.LeadObject.leadDescription;
    
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:LEADS_MODULE
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", self.LeadObject.leadID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    [customersArray addObjectsFromArray:fetchedObjects];
    
}

- (void)refreshLeadObjectFromCoreDataStore
{
    NSManagedObjectContext *context = SAppDelegateObject.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:LEADS_MODULE
                                              inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", leadID];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setEntity:entity];
    
    NSError *error=nil;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if([fetchedObjects count]>0)
    {
        self.LeadObject=(Leads *)[fetchedObjects objectAtIndex:0];
        [self loadLeadData];
        
    }
    
}

#pragma mark Adding Activity To Customer

- (IBAction)addActivityToLeadsButton:(id)sender {
    
    AddEventViewController *addNewEventController=[[AddEventViewController alloc]initWithNibName:@"AddEventViewController" bundle:nil];
    addNewEventController.eventRelatedToModule=LeadModule;
    addNewEventController.eventRelatedToID=self.LeadObject.leadID;
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
        NSLog(@"leadcount: %d", [[self.LeadObject.eventsTaggedToLead allObjects] count]);
        return[[self.LeadObject.eventsTaggedToLead allObjects] count];
    }
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
    
   /* if (tableView.tag == 4)
    {
        
        UIImageView *profileIcon = [[UIImageView alloc]init];
        profileIcon.image=[UIImage imageNamed:@"Empty_user_profile_picture.png"];
        profileIcon.frame = CGRectMake(15, 25, 50, 50);
        
        Customers *userObject =[customersArray objectAtIndex:indexPath.row];
        
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
    }*/
    
     if (tableView.tag == 3)
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
    
   /* else if (tableView.tag == 2)
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
    }*/
    
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
        Events *activityObject = [[self.LeadObject.eventsTaggedToLead allObjects] objectAtIndex:indexPath.row];
        NSLog(@"activityObject:%@", activityObject);
        NSLog(@"[self.customerObject.eventsTaggedToCustomers allObjects]:%@", [self.LeadObject.eventsTaggedToLead allObjects]);
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
    
    /*if (tableView.tag ==2)
    {
        
        Opportunities * opportunitytObject =  [[ self.customerObject.opportunitiesTaggedToCustomers allObjects] objectAtIndex:indexPath.row];
        [[iPitchAnalytics sharedInstance] setCurrentAnalyticsEngine:iPitchAnlyticsTypeGA];
        
        [[iPitchAnalytics sharedInstance] trackEventForScreen:@"Customer Details Screen" withAction:@"Opportunity  Clicked" withLabel:opportunitytObject.opportunityName withValue:nil];
        ShowOpportunityViewController *viewController = [[ShowOpportunityViewController alloc] initWithNibName:@"ShowOpportunityViewController" bundle:nil];
        viewController.PotentialObject = opportunitytObject;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }*/
    
     if (tableView.tag == 1)
    {
        
        Events *event = [[self.LeadObject.eventsTaggedToLead allObjects] objectAtIndex:indexPath.row];
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

-(IBAction)BackbuttonClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)leadEditButtonClicked:(id)sender
{
    AddEditLeadViewController *editVC=[[AddEditLeadViewController alloc]initWithNibName:@"AddEditLeadViewController" bundle:nil];
    editVC.delegate=self;
    editVC.leadObject=self.LeadObject;
    leadID=self.LeadObject.leadID;
    editVC.modalPresentationStyle=UIModalPresentationFormSheet;
    [self presentModalViewController:editVC animated:YES];
    CGRect r = CGRectMake(self.view.bounds.size.width/2 - 325,
                          self.view.bounds.size.height/2 - 325,
                          650, 650);
    r = [self.view convertRect:r toView:editVC.view.superview.superview];
    editVC.view.superview.frame = r;
}

#pragma mark AddEditLeadViewController Delegates

- (void)leadDataSavedSuccessfully
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText= @"Lead Added Saved Successfully!!";
    [self refreshLeadObjectFromCoreDataStore];

   
}

- (void)leadDataSaveFailedWithError:(NSError *)error
{
    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD hide:YES afterDelay:HUD_ALERT_TIMING];
    HUD.mode =MBProgressHUDModeText;
    HUD.labelText=@"Sorry could not Add Lead";
    
    NSLog(@"error: %@",error.localizedDescription);
}


#pragma mark Notes Notificaiton Methods

- (void)notesAddedForLead:(NSNotification *)notification
{
    NSLog(@"object: %@",notification.object);
    
    if ([[notification.object objectForKey:NOTES_STATUS] boolValue]) {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"ADDING_NOTES", @"Adding Notes...");
        [self performSelectorInBackground:@selector(addNotesToLead:) withObject:notification.object];
    }
    
    else
    {
        NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Leads" inManagedObjectContext:context]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", self.LeadObject.leadID];
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
            
            Leads *leadObject=[results objectAtIndex:0];
            [leadObject addNotesTaggedToLeadObject:notesObject];
            
            if (![context save:&error])
            {
                NSLog(@"Sorry, couldn't save notes for customer %@", [error localizedDescription]);
            }
            
            SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[leadObject.notesTaggedToLead allObjects]];
            
        }
    }
    
}

- (void)notesDeletedForLead:(NSNotification *)notification
{
    
    Leads *leadObject;
    Notes *notesObj;
    
    NSManagedObjectContext *context=SAppDelegateObject.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Leads" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"leadID == %@", self.LeadObject.leadID];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count]>0)
    {
        leadObject = (Leads *)[results objectAtIndex:0];
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
        [self performSelectorInBackground:@selector(deleteNotesForLead:) withObject:notification.object];
        
    }
    
    else
    {
        [leadObject removeNotesTaggedToLeadObject:notesObj];
        
        [context deleteObject:notesObj];
        
        if (![context save:&error])
        {
            NSLog(@"Sorry, couldn't delete notes for customer %@", [error localizedDescription]);
        }
    }
    
}
- (void)addNotesToLead:(NSDictionary *)notesDict
{
    ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
    [zohoHelper addNotesToRecordID:self.LeadObject.leadID withNoteTitle:[notesDict objectForKey:NOTES_TITLE] andNoteContent:[notesDict objectForKey:NOTES_CONTENT]];
    [self.LeadObject removeNotesTaggedToLead:self.LeadObject.notesTaggedToLead];
    [self.LeadObject addNotesTaggedToLead:[zohoHelper fetchNotesForRecordID:self.LeadObject.leadID inModule:@"Leads"]];
    [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];
}

- (void)deleteNotesForLead:(NSString *)noteID
{
    ZohoHelper *zohoHelper=[[ZohoHelper alloc]init];
    [zohoHelper deleteNotesFromZoho:noteID];
    [self.LeadObject removeNotesTaggedToLead:self.LeadObject.notesTaggedToLead];
    [self.LeadObject addNotesTaggedToLead:[zohoHelper fetchNotesForRecordID:self.LeadObject.leadID inModule:@"Leads"]];
    
    [self performSelectorOnMainThread:@selector(updateAfterAddingNotes) withObject:nil waitUntilDone:YES];
    
}
- (void)updateAfterAddingNotes
{
    SAppDelegateObject.notesArray = [[NSMutableArray alloc]initWithArray:[self.LeadObject.notesTaggedToLead allObjects]];
    
    NSLog(@"Notes for this customers: %@",self.LeadObject.notesTaggedToLead);
    [HUD hide:YES];
    
}



@end
